# Executive KPI & Business Performance Analytics Platform

**SaaS Subscription Analytics**

---

## 📌 Project Overview

This project builds an **end-to-end analytics platform** for a B2B SaaS subscription business, designed to help leadership track growth, retention, and revenue performance through well-defined KPIs, advanced SQL analytics, and executive dashboards.

The platform demonstrates how raw transactional and usage data can be transformed into **actionable business insights** using PostgreSQL, advanced SQL, and Tableau.

---

## 🧠 Business Problem

SaaS companies rely on **key performance indicators (KPIs)** such as MRR, churn, and retention to understand business health and guide strategic decisions.

However, raw data is often spread across multiple systems (subscriptions, payments, usage logs), making it difficult to:

- Measure revenue growth accurately
- Identify churn drivers
- Understand customer behavior by segment
- Provide leadership with a single source of truth

This project addresses those challenges by building a **SQL-first analytics pipeline** and executive dashboards for KPI tracking and decision support.

---

## 🎯 Project Goals

- Define and compute **core SaaS KPIs** from raw data
- Perform **advanced SQL analysis** using CTEs and window functions
- Build **executive-level Tableau dashboards** for KPI storytelling
- Identify key trends and churn drivers
- Translate analytics into **business recommendations**

---

## 🗂️ Data Model

The analysis uses a realistic SaaS-style data model:

- **customers** – customer attributes (industry, region, signup date)
- **subscriptions** – plan type, billing cycle, status
- **payments** – invoices, payment amounts, timestamps
- **usage_events** – product feature usage logs
- **churn_events** – churn dates and reasons

Synthetic data is generated to reflect realistic SaaS growth and churn patterns.

---

## 📊 Key KPIs Tracked

### Revenue Metrics
- **MRR** (Monthly Recurring Revenue)
- **ARR** (Annual Recurring Revenue)
- **Revenue Growth** (MoM)
- **ARPU** (Average Revenue Per User)

### Retention Metrics
- Customer **Churn Rate**
- **Net Revenue Retention**
- **Cohort Retention**

### Customer & Product Metrics
- Revenue by plan type and industry
- Usage patterns vs churn
- Segment-level performance

---

## 📐 KPI Definitions

- **MRR** = Sum of active monthly subscription revenue
- **ARR** = MRR × 12
- **Churn Rate** = (Customers churned in period) / (Active customers at start of period)
- **ARPU** = Total revenue / Active customers
- **Retention Rate** = Percentage of customers retained over time by cohort

Clear KPI definitions ensure **consistent and interpretable metrics** for stakeholders.

---

## 🛠️ Tech Stack

- **Database**: PostgreSQL
- **Querying**: Advanced SQL (CTEs, Window Functions, Aggregations)
- **Data Processing**: Python
- **Visualization**: Tableau
- **Version Control**: GitHub

---

100


Example SQL used to compute **monthly revenue trends**:

```sql
WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC('month', payment_date) AS month,
    SUM(amount) AS revenue
  FROM payments
  GROUP BY 1
)
SELECT
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
  (revenue - LAG(revenue) OVER (ORDER BY month))
    / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) AS revenue_growth_rate
FROM monthly_revenue;
```

This demonstrates:
- **CTE usage**
- **Window functions**
- **Time-based trend analysis**

- ### 2️⃣ **Churn Rate Calculation**

```sql
-- Calculate monthly churn rate
WITH monthly_stats AS (
  SELECT
    DATE_TRUNC('month', churn_date) AS month,
    COUNT(DISTINCT customer_id) AS churned_customers
  FROM churn_events
  GROUP BY 1
),
active_customers AS (
  SELECT
    DATE_TRUNC('month', start_date) AS month,
    COUNT(DISTINCT customer_id) AS total_active
  FROM subscriptions
  WHERE status = 'active'
  GROUP BY 1
)
SELECT
  a.month,
  COALESCE(c.churned_customers, 0) AS churned,
  a.total_active AS active_customers,
  ROUND(100.0 * COALESCE(c.churned_customers, 0) / NULLIF(a.total_active, 0), 2) AS churn_rate_pct
FROM active_customers a
LEFT JOIN monthly_stats c ON a.month = c.month
ORDER BY a.month;
```

This demonstrates:
- **Multiple CTEs** for complex logic
- **LEFT JOIN** to handle months with zero churn
- **COALESCE** for null handling
- **Percentage calculations**

- ### 3️⃣ **Cohort Retention Analysis**

```sql
-- Cohort retention by signup month
WITH cohorts AS (
  SELECT
    customer_id,
    DATE_TRUNC('month', signup_date) AS cohort_month
  FROM customers
),
activity AS (
  SELECT
    c.customer_id,
    c.cohort_month,
    DATE_TRUNC('month', p.payment_date) AS activity_month,
    EXTRACT(MONTH FROM AGE(p.payment_date, c.cohort_month)) AS months_since_signup
  FROM cohorts c
  JOIN payments p ON c.customer_id = p.customer_id
)
SELECT
  cohort_month,
  months_since_signup,
  COUNT(DISTINCT customer_id) AS active_customers,
  ROUND(100.0 * COUNT(DISTINCT customer_id) / 
    FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (
      PARTITION BY cohort_month ORDER BY months_since_signup
    ), 2) AS retention_rate_pct
FROM activity
GROUP BY 1, 2
ORDER BY 1, 2;
```

This demonstrates:
- **Self-joins** for temporal analysis
- **FIRST_VALUE window function** for cohort base calculation
- **AGE function** for month difference
- **Cohort-based grouping**

- ### 4️⃣ **Average Revenue Per User (ARPU)**

```sql
-- Calculate ARPU by month and segment
WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC('month', p.payment_date) AS month,
    c.segment,
    SUM(p.amount) AS total_revenue,
    COUNT(DISTINCT p.customer_id) AS active_customers
  FROM payments p
  JOIN customers c ON p.customer_id = c.customer_id
  GROUP BY 1, 2
)
SELECT
  month,
  segment,
  total_revenue,
  active_customers,
  ROUND(total_revenue / NULLIF(active_customers, 0), 2) AS arpu,
  LAG(ROUND(total_revenue / NULLIF(active_customers, 0), 2)) 
    OVER (PARTITION BY segment ORDER BY month) AS prev_arpu
FROM monthly_revenue
ORDER BY segment, month;
```

This demonstrates:
- **JOINs across multiple tables**
- **Segmentation analysis**
- **Null-safe division** with NULLIF
- **LAG for period-over-period comparison**

---

230
(Tableau)

The Tableau dashboards provide **executive-level visibility** into business performance:

- **Executive Overview**: MRR, growth rate, churn
- **Revenue Trends**: Monthly and yearly trends
- **Customer Segmentation**: Revenue by industry and plan
- **Cohort Retention**: Retention heatmaps
- **Churn Analysis**: Churn by segment and usage behavior

📸 Dashboard screenshots are included in the repository.

### 📊 Executive Overview
![Executive Dashboard](screenshots/dashboard_overview.png)
*KPI summary: MRR, ARR, churn rate, and growth trends*

### 📉 Cohort Retention Heatmap
![Cohort Analysis](screenshots/cohort_retention.png)
*Month-over-month retention by customer signup cohort*

### 🎯 Churn Analysis
![Churn Dashboard](screenshots/churn_analysis.png)
*Churn drivers by segment, plan type, and usage patterns*

> 💡 **Note:** Interactive Tableau workbook available in `dashboards/` folder

---

## 🔍 Key Insights & Business Recommendations

### Key Insights
- **Annual plans** show significantly lower churn compared to monthly plans
- **Enterprise customers** contribute the majority of MRR, but SMB churn is higher
- **Low product usage** correlates strongly with churn, indicating onboarding gaps

### Recommendations
- Incentivize customers to move from monthly to annual plans
- Improve onboarding and engagement for SMB customers
- Focus retention efforts on high-risk, low-usage segments

These insights demonstrate how **analytics directly informs business decisions**.

---
## 🚀 How to Use This Repo

### Step 1: Load Data into PostgreSQL
```bash
# Start PostgreSQL via Docker
docker run -d \
  --name exec-kpi-postgres \
  -e POSTGRES_PASSWORD=analytics_pass \
  -p 5432:5432 \
  postgres:18

# Load CSVs from data/processed/ folder
```

### Step 2: Run SQL Analytics
```bash
# Execute KPI queries
psql -U postgres -d executive_kpi -f sql/kpi_metrics.sql
psql -U postgres -d executive_kpi -f sql/cohort_analysis.sql
psql -U postgres -d executive_kpi -f sql/churn_analysis.sql
```

### Step 3: View Tableau Dashboards
- Open `dashboards/Executive_KPI_Dashboard.twbx` in Tableau Public
- Refresh data connection if needed
- Explore interactive visualizations

### Step 4: Use for Interviews
- Reference SQL examples during technical discussions
- Present dashboard screenshots in case studies
- Explain business insights to demonstrate impact

280


```
executive-kpi-analytics/
├── data/
│   ├── raw/
│   └── processed/
├── sql/
│   ├── kpi_metrics.sql
│   ├── cohort_analysis.sql
│   └── churn_analysis.sql
├── dashboards/
│   └── executive_kpi_dashboard.twbx
├── notebooks/
│   └── analysis.ipynb
├── screenshots/
│   └── dashboard_previews.png
└── README.md
```

---

## 🚀 How This Project Adds Value

This project demonstrates:

- Strong **business analytics thinking**
- **Advanced SQL** and KPI design
- Clear **executive storytelling**
- Ability to translate data into **actionable recommendations**

It complements machine learning and AI-focused projects by showcasing **analytics leadership** and **decision support skills**.

---

## 👤 Author

**Pavan Kalyan Padala**  
*Data Scientist | Analytics Engineer*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/yourprofile) [![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=for-the-badge&logo=github)](https://github.com/pavankalyanpadala-programmer) [![Portfolio](https://img.shields.io/badge/Portfolio-Visit-FF5722?style=for-the-badge&logo=google-chrome)](https://applywizz-pavan-kalyan.vercel.app/)

---

## 📄 License

MIT License – Free to use for learning and portfolio purposes.

---

## 🙏 Acknowledgments

Built as a portfolio project to demonstrate end-to-end data engineering and business intelligence capabilities for analytics and data science roles.

---

**⭐ Star this repo if you found it helpful!**

*Last Updated: January 2026*
