-- ============================================================
-- EXECUTIVE KPI ANALYTICS FOR SAAS BUSINESS
-- Database: PostgreSQL (executive_kpi)
-- Purpose: Power Tableau dashboards for CFO/CEO insights
-- ============================================================

-- ============================================================
-- 1. MRR/ARR TRENDS BY MONTH (with MoM growth)
-- ============================================================
WITH monthly_mrr AS (
    SELECT 
        DATE_TRUNC('month', s.start_date) AS month,
        SUM(s.mrr) AS mrr,
        COUNT(DISTINCT s.customer_id) AS active_customers
    FROM subscriptions s
    WHERE s.start_date <= DATE_TRUNC('month', CURRENT_DATE)
      AND (s.end_date IS NULL OR s.end_date >= DATE_TRUNC('month', CURRENT_DATE))
    GROUP BY DATE_TRUNC('month', s.start_date)
    ORDER BY month
),
mrr_with_growth AS (
    SELECT 
        month,
        mrr,
        mrr * 12 AS arr,
        active_customers,
        mrr / NULLIF(active_customers, 0) AS arpu,
        LAG(mrr) OVER (ORDER BY month) AS prev_month_mrr,
        (mrr - LAG(mrr) OVER (ORDER BY month)) / NULLIF(LAG(mrr) OVER (ORDER BY month), 0) * 100 AS mom_growth_pct
    FROM monthly_mrr
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') AS month,
    ROUND(mrr::numeric, 2) AS mrr,
    ROUND(arr::numeric, 2) AS arr,
    active_customers,
    ROUND(arpu::numeric, 2) AS arpu,
    ROUND(mom_growth_pct::numeric, 2) AS mom_growth_percent
FROM mrr_with_growth
ORDER BY month;


-- ============================================================
-- 2. CUSTOMER CHURN ANALYSIS (Logo & Revenue Churn)
-- ============================================================
WITH monthly_churn AS (
    SELECT 
        DATE_TRUNC('month', s.end_date) AS churn_month,
        COUNT(DISTINCT s.customer_id) AS churned_customers,
        SUM(s.mrr) AS churned_mrr
    FROM subscriptions s
    WHERE s.end_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', s.end_date)
),
monthly_base AS (
    SELECT 
        DATE_TRUNC('month', GENERATE_SERIES(
            (SELECT MIN(start_date) FROM subscriptions),
            (SELECT MAX(COALESCE(end_date, CURRENT_DATE)) FROM subscriptions),
            '1 month'::interval
        )) AS month
),
active_base AS (
    SELECT 
        b.month,
        COUNT(DISTINCT s.customer_id) AS total_customers_start_month,
        SUM(s.mrr) AS total_mrr_start_month
    FROM monthly_base b
    LEFT JOIN subscriptions s 
        ON s.start_date < b.month + INTERVAL '1 month'
        AND (s.end_date IS NULL OR s.end_date >= b.month)
    GROUP BY b.month
)
SELECT 
    TO_CHAR(a.month, 'YYYY-MM') AS month,
    COALESCE(c.churned_customers, 0) AS churned_customers,
    a.total_customers_start_month AS total_customers,
    ROUND((COALESCE(c.churned_customers, 0)::numeric / NULLIF(a.total_customers_start_month, 0) * 100), 2) AS logo_churn_rate,
    ROUND(COALESCE(c.churned_mrr, 0)::numeric, 2) AS churned_mrr,
    ROUND(a.total_mrr_start_month::numeric, 2) AS total_mrr,
    ROUND((COALESCE(c.churned_mrr, 0) / NULLIF(a.total_mrr_start_month, 0) * 100), 2) AS revenue_churn_rate
FROM active_base a
LEFT JOIN monthly_churn c ON a.month = c.churn_month
WHERE a.total_customers_start_month > 0
ORDER BY a.month;


-- ============================================================
-- 3. COHORT RETENTION ANALYSIS
-- ============================================================
WITH customer_cohorts AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM customers
),
cohort_activity AS (
    SELECT 
        c.cohort_month,
        s.customer_id,
        DATE_TRUNC('month', s.start_date) AS activity_month,
        EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', s.start_date), c.cohort_month)) * 12 
            + EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', s.start_date), c.cohort_month)) AS months_since_signup
    FROM customer_cohorts c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    WHERE s.end_date IS NULL OR s.end_date >= DATE_TRUNC('month', s.start_date)
),
cohort_sizes AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM customer_cohorts
    GROUP BY cohort_month
)
SELECT 
    TO_CHAR(ca.cohort_month, 'YYYY-MM') AS cohort,
    ca.months_since_signup AS months_after_signup,
    COUNT(DISTINCT ca.customer_id) AS active_customers,
    cs.cohort_size AS original_cohort_size,
    ROUND((COUNT(DISTINCT ca.customer_id)::numeric / NULLIF(cs.cohort_size, 0) * 100), 2) AS retention_rate
FROM cohort_activity ca
JOIN cohort_sizes cs ON ca.cohort_month = cs.cohort_month
GROUP BY ca.cohort_month, ca.months_since_signup, cs.cohort_size
ORDER BY ca.cohort_month, ca.months_since_signup;


-- ============================================================
-- 4. SEGMENT & REGIONAL PERFORMANCE
-- ============================================================
SELECT 
    c.segment,
    c.region,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN s.end_date IS NULL THEN s.customer_id END) AS active_customers,
    ROUND(SUM(CASE WHEN s.end_date IS NULL THEN s.mrr ELSE 0 END)::numeric, 2) AS total_mrr,
    ROUND(AVG(CASE WHEN s.end_date IS NULL THEN s.mrr END)::numeric, 2) AS avg_mrr_per_customer,
    ROUND((SUM(CASE WHEN s.end_date IS NULL THEN s.mrr ELSE 0 END) * 12)::numeric, 2) AS total_arr
FROM customers c
LEFT JOIN subscriptions s ON c.customer_id = s.customer_id
GROUP BY c.segment, c.region
ORDER BY total_mrr DESC;


-- ============================================================
-- 5. PLAN PERFORMANCE (by plan type)
-- ============================================================
SELECT 
    s.plan_name,
    s.plan_type,
    COUNT(DISTINCT s.subscription_id) AS total_subscriptions,
    COUNT(DISTINCT CASE WHEN s.end_date IS NULL THEN s.subscription_id END) AS active_subscriptions,
    ROUND(AVG(s.mrr)::numeric, 2) AS avg_mrr,
    ROUND(SUM(CASE WHEN s.end_date IS NULL THEN s.mrr ELSE 0 END)::numeric, 2) AS total_active_mrr,
    ROUND((COUNT(DISTINCT CASE WHEN s.end_date IS NOT NULL THEN s.subscription_id END)::numeric 
        / NULLIF(COUNT(DISTINCT s.subscription_id), 0) * 100), 2) AS churn_rate
FROM subscriptions s
GROUP BY s.plan_name, s.plan_type
ORDER BY total_active_mrr DESC;


-- ============================================================
-- 6. INVOICE PAYMENT ANALYSIS
-- ============================================================
SELECT 
    DATE_TRUNC('month', i.invoice_date) AS month,
    COUNT(*) AS total_invoices,
    SUM(CASE WHEN i.status = 'Paid' THEN 1 ELSE 0 END) AS paid_invoices,
    SUM(CASE WHEN i.status = 'Unpaid' THEN 1 ELSE 0 END) AS unpaid_invoices,
    SUM(CASE WHEN i.status = 'Refunded' THEN 1 ELSE 0 END) AS refunded_invoices,
    ROUND(SUM(i.amount)::numeric, 2) AS total_invoiced,
    ROUND(SUM(CASE WHEN i.status = 'Paid' THEN i.amount ELSE 0 END)::numeric, 2) AS total_collected,
    ROUND((SUM(CASE WHEN i.status = 'Paid' THEN i.amount ELSE 0 END) / NULLIF(SUM(i.amount), 0) * 100), 2) AS collection_rate
FROM invoices i
GROUP BY DATE_TRUNC('month', i.invoice_date)
ORDER BY month;
