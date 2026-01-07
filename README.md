

```markdown
# Executive KPI & Business Performance Analytics Platform

**SaaS Business Intelligence Dashboard**  
*PostgreSQL + Tableau + Python*

![Dashboard Preview](screenshots/dashboard_screenshot.png)

## 🔗 Live Dashboard
[View Interactive Tableau Dashboard](https://public.tableau.com/app/profile/pavankalyan.padala/viz/Executive-KPI-Analytics-SaaS/ExecutiveKPIDashboard-SaaSPerformance)

## 📊 Project Overview
Executive-level analytics platform for a SaaS subscription business, demonstrating end-to-end data pipeline development and business intelligence capabilities.

### Key Metrics Tracked:
- **Monthly Recurring Revenue (MRR)** & Annual Recurring Revenue (ARR)
- **Customer Growth** & Retention Analysis
- **Churn Rate** (Logo & Revenue Churn)
- **ARPU** (Average Revenue Per User)
- **Segment Performance** (SMB, Mid-Market, Enterprise)

## 🛠️ Tech Stack
- **Database:** PostgreSQL 18 (Docker)
- **Data Generation:** Python (Faker, psycopg2)
- **Visualization:** Tableau Public
- **SQL:** Advanced queries (CTEs, Window Functions, Date Manipulation)

## 📁 Project Structure
```
executive-kpi-analytics/
├── data/
│   ├── raw/              # Raw CSV exports
│   └── processed/        # Processed data for Tableau
├── sql/
│   └── executive_kpis.sql    # KPI calculation queries
├── generate_saas_data.py     # Data generation script
├── export_to_csv.py          # CSV export for Tableau
├── dashboard/                # Tableau workbooks
├── screenshots/              # Dashboard images
└── README.md
```

## 🚀 Key Features

### 1. **Realistic SaaS Data Generation**
- 500+ customers across 3 segments (SMB, Mid-Market, Enterprise)
- 589 subscriptions with varied pricing ($50-$5000/month MRR)
- 4,991 invoices over 2 years (2024-2025)
- Simulated churn patterns (15% annual churn rate)

### 2. **Advanced SQL Analytics**
```sql
-- Example: Monthly MRR with Growth Rate
WITH monthly_mrr AS (
    SELECT 
        DATE_TRUNC('month', start_date) AS month,
        SUM(mrr) AS mrr
    FROM subscriptions
    WHERE end_date IS NULL OR end_date >= DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY month
)
SELECT 
    month,
    mrr,
    mrr * 12 AS arr,
    (mrr - LAG(mrr) OVER (ORDER BY month)) / LAG(mrr) OVER (ORDER BY month) * 100 AS mom_growth_pct
FROM monthly_mrr;
```

### 3. **Executive Dashboard**
Three interactive visualizations:
- **Revenue Trends:** Monthly revenue with seasonal patterns ($170K-$340K range)
- **Segment Analysis:** MRR breakdown showing Enterprise dominance ($125K MRR)
- **Customer Growth:** Cumulative customer acquisition (50→500 customers)

## 📈 Key Insights

| Metric | Value |
|--------|-------|
| Total Customers | 500 |
| Active Customers | 456 (91.2% retention) |
| Total MRR | $238,056 |
| ARR | $2.86M |
| ARPU | $522/customer |

**Revenue Distribution:**
- Enterprise: 52% ($125K MRR)
- Mid-Market: 39% ($93K MRR)
- SMB: 9% ($20K MRR)

## 🔧 Setup Instructions

### Prerequisites
- Docker Desktop
- Python 3.8+
- Tableau Public (free)

### Database Setup
```bash
# Start PostgreSQL container
docker run -d \
  --name exec-kpi-postgres \
  -e POSTGRES_USER=analytics_user \
  -e POSTGRES_PASSWORD=analytics_pass \
  -e POSTGRES_DB=executive_kpi \
  -v exec_kpi_pgdata:/var/lib/postgresql \
  -p 5432:5432 \
  postgres

# Install Python dependencies
pip install psycopg2-binary Faker

# Generate data
python generate_saas_data.py

# Export to CSV for Tableau
python export_to_csv.py
```

### Tableau Connection
1. Open Tableau Public
2. Connect to CSV files in `data/processed/`
3. Create relationships:
   - `customers.customer_id` → `subscriptions.customer_id`
   - `subscriptions.subscription_id` → `invoices.subscription_id`

## 💼 Business Value
This project demonstrates:
- ✅ **SQL Proficiency:** Complex joins, CTEs, window functions
- ✅ **Data Modeling:** Normalized schema design for SaaS metrics
- ✅ **Business Acumen:** Understanding of key SaaS KPIs
- ✅ **Visualization:** Executive-level dashboard design
- ✅ **End-to-End Pipeline:** Data generation → Storage → Analysis → Reporting

## 🎯 Use Cases
- **CFO/CEO:** Revenue health monitoring and growth tracking
- **Sales:** Customer segment performance analysis
- **Customer Success:** Churn identification and retention planning
- **Investors:** ARR growth and unit economics validation

## 📚 Skills Demonstrated
- PostgreSQL database design and management
- Python data generation and ETL
- Advanced SQL (CTEs, window functions, date operations)
- Tableau dashboard development
- Business metrics calculation (MRR, ARR, churn, ARPU)
- Docker containerization

## 👤 Author
**Pavan Kalyan Padala**  
Data Scientist | Analytics Engineer  
[LinkedIn](https://linkedin.com/in/yourprofile) | [Portfolio](https://github.com/yourusername)

## 📝 License
MIT License - Feel free to use this project for learning and portfolio purposes.

---

*Built as a portfolio project to demonstrate data engineering and business intelligence capabilities for SaaS analytics roles.*
```

*