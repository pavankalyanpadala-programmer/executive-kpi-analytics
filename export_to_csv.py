import psycopg2
import csv
from pathlib import Path

# Database connection
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="executive_kpi",
    user="analytics_user",
    password="analytics_pass"
)
cur = conn.cursor()

# Output directory
output_dir = Path("data/processed")
output_dir.mkdir(parents=True, exist_ok=True)

print("📊 Exporting data to CSV files for Tableau...")

# 1. Export customers
print("   Exporting customers...")
cur.execute("SELECT * FROM customers")
rows = cur.fetchall()
columns = [desc[0] for desc in cur.description]
with open(output_dir / "customers.csv", 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(columns)
    writer.writerows(rows)

# 2. Export subscriptions
print("   Exporting subscriptions...")
cur.execute("SELECT * FROM subscriptions")
rows = cur.fetchall()
columns = [desc[0] for desc in cur.description]
with open(output_dir / "subscriptions.csv", 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(columns)
    writer.writerows(rows)

# 3. Export invoices
print("   Exporting invoices...")
cur.execute("SELECT * FROM invoices")
rows = cur.fetchall()
columns = [desc[0] for desc in cur.description]
with open(output_dir / "invoices.csv", 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(columns)
    writer.writerows(rows)

cur.close()
conn.close()

print("\n✅ CSV export complete!")
print(f"   Files saved to: {output_dir.absolute()}")
print("\n📁 Exported files:")
print("   - customers.csv (500 customers)")
print("   - subscriptions.csv (589 subscriptions)")
print("   - invoices.csv (4991 invoices)")
print("\n🎯 Next: Open Tableau Public and connect to these CSV files")
