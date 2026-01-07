# 📊 Executive KPI & Business Performance Analytics

> **End-to-end SaaS analytics platform** demonstrating PostgreSQL, Python, and Tableau for executive-level business intelligence

[![Tableau Dashboard](https://img.shields.io/badge/Tableau-Live%20Dashboard-blue?style=for-the-badge&logo=tableau)](https://public.tableau.com/app/profile/pavankalyan.padala/viz/Executive-KPI-Analytics-SaaS/ExecutiveKPIDashboard-SaaSPerformance)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-336791?style=for-the-badge&logo=postgresql)](https://www.postgresql.org/)
[![Python](https://img.shields.io/badge/Python-3.8+-3776AB?style=for-the-badge&logo=python)](https://www.python.org/)

---

## 🎯 Project Overview

Executive-level analytics platform built for a **SaaS subscription business**, tracking key performance indicators critical to CFOs, CEOs, and investors. This project demonstrates full-stack data engineering: from database design and data generation to advanced SQL analytics and interactive visualization.

### 📈 Key Business Metrics

| Metric | Value | Description |
|--------|-------|-------------|
| 💰 **MRR** | $238,056 | Monthly Recurring Revenue |
| 📅 **ARR** | $2.86M | Annual Recurring Revenue |
| 👥 **Active Customers** | 456 of 500 | 91.2% retention rate |
| 💵 **ARPU** | $522 | Average Revenue Per User |
| 📉 **Churn Rate** | 8.8% | Logo churn (annual) |

---

## 🚀 Live Demo

**[→ View Interactive Dashboard on Tableau Public](https://public.tableau.com/app/profile/pavankalyan.padala/viz/Executive-KPI-Analytics-SaaS/ExecutiveKPIDashboard-SaaSPerformance)**

The dashboard features:
- 📊 **Monthly Revenue Trends** - Seasonal patterns and growth analysis
- 👥 **Customer Growth** - Cumulative acquisition from 50 to 500 customers
- 💼 **Segment Performance** - MRR breakdown (Enterprise, Mid-Market, SMB)

---

## 🛠️ Technology Stack

```
┌─────────────┬──────────────────────────────────────┐
│ Database    │ PostgreSQL 18 (Docker)               │
│ Language    │ Python 3.8+                          │
│ Libraries   │ psycopg2, Faker                      │
│ Analytics   │ Advanced SQL (CTEs, Window Functions)│
│ Visualization│ Tableau Public                      │
└─────────────┴──────────────────────────────────────┘
```

---

## 📁 Project Structure

```
executive-kpi-analytics/
│
├── 📂 data/
│   ├── raw/                    # Raw data exports
│   └── processed/              # CSV files for Tableau
│       ├── customers.csv       # 500 customer records
│       ├── subscriptions.csv   # 589 subscription records
│       └── invoices.csv        # 4,991 invoice records
│
├── 📂 sql/
│   └── executive_kpis.sql      # Advanced SQL queries for KPI calculations
│
├── 🐍 generate_saas_data.py    # Generates realistic SaaS business data
├── 🐍 export_to_csv.py         # Exports PostgreSQL data to CSV
└── 📋 README.md                # Project documentation
```

---

## ⚡ Quick Start

### Prerequisites
- Docker Desktop installed
- Python 3.8+
- Tableau Public (free download)

### 1️⃣ Start PostgreSQL Database

```bash
docker run -d \
  --name exec-kpi-postgres \
  -e POSTGRES_USER=analytics_user \
  -e POSTGRES_PASSWORD=analytics_pass \
  -e POSTGRES_DB=executive_kpi \
  -v exec_kpi_pgdata:/var/lib/postgresql \
  -p 5432:5432 \
  postgres
```

### 2️⃣ Install Python Dependencies

```bash
pip install psycopg2-binary Faker
```

### 3️⃣ Generate Sample Data

```bash
python generate_saas_data.py
```

**Output:**
- ✅ 500 customers across 3 segments (SMB, Mid-Market, Enterprise)
- ✅ 589 subscriptions with varied pricing ($50-$5000/month)
- ✅ 4,991 invoices spanning 2024-2025
- ✅ Realistic churn patterns (15% annual rate)

### 4️⃣ Export to CSV for Tableau

```bash
python export_to_csv.py
```

### 5️⃣ Connect Tableau

1. Open Tableau Public
2. Connect to CSV files in `data/processed/`
3. Set up relationships:
   - `customers.customer_id` ↔ `subscriptions.customer_id`
   - `subscriptions.subscription_id` ↔ `invoices.subscription_id`

---

## 💡 Key Features

### 🔹 Business Insights

| Segment | MRR | % of Total | Customers |
|---------|-----|------------|-----------|  
| 🏢 **Enterprise** | $125,000 | 52% | 50 |
| 🏪 **Mid-Market** | $93,000 | 39% | 150 |
| 🏠 **SMB** | $20,000 | 9% | 300 |

### 🔹 Skills Demonstrated

- ✅ **Database Design** - Normalized schema for SaaS metrics
- ✅ **Data Engineering** - ETL pipeline with Python
- ✅ **SQL Proficiency** - CTEs, window functions, date operations  
- ✅ **Business Intelligence** - KPI calculations (MRR, ARR, churn, ARPU)
- ✅ **Data Visualization** - Executive-level Tableau dashboards
- ✅ **DevOps** - Docker containerization

---

## 💼 Business Value

### For Executives
- Track revenue health and growth trends
- Identify high-value customer segments
- Monitor churn and retention metrics  
- Make data-driven strategic decisions

### For Investors  
- Validate ARR growth trajectory
- Assess unit economics (ARPU, CAC payback)
- Evaluate customer retention
- Understand revenue concentration by segment

---

## 👨‍💻 Author

**Pavan Kalyan Padala**  
*Data Scientist | Analytics Engineer*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/yourprofile)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=for-the-badge&logo=github)](https://github.com/pavankalyanpadala-programmer)
[![Portfolio](https://img.shields.io/badge/Portfolio-Visit-FF5722?style=for-the-badge&logo=google-chrome)](https://applywizz-pavan-kalyan.vercel.app/)

---

## 📝 License

MIT License - Free to use for learning and portfolio purposes.

---

## 🙏 Acknowledgments

Built as a portfolio project to demonstrate end-to-end data engineering and business intelligence capabilities for analytics and data science roles.

---

<div align="center">

**⭐ Star this repo if you found it helpful!**

*Last Updated: January 2026*

</div>
