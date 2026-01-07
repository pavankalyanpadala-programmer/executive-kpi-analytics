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

## 🧮 SQL Highlights

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

---

## 📈 Dashboards (Tableau)

The Tableau dashboards provide **executive-level visibility** into business performance:

- **Executive Overview**: MRR, growth rate, churn
- **Revenue Trends**: Monthly and yearly trends
- **Customer Segmentation**: Revenue by industry and plan
- **Cohort Retention**: Retention heatmaps
- **Churn Analysis**: Churn by segment and usage behavior

📸 Dashboard screenshots are included in the repository.

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

## 📂 Repository Structure

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
