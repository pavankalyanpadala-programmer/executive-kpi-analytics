import psycopg2
from datetime import datetime, timedelta
import random
from faker import Faker

# Initialize Faker
fake = Faker()

# Database connection
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="executive_kpi",
    user="analytics_user",
    password="analytics_pass"
)
cur = conn.cursor()

# Configuration
START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2025, 12, 31)
NUM_CUSTOMERS = 500
SEGMENTS = ['SMB', 'Mid-Market', 'Enterprise']
REGIONS = ['North America', 'Europe', 'Asia Pacific', 'Latin America']
PLANS = {
    'SMB': [('Basic', 'Monthly', 50), ('Standard', 'Monthly', 100), ('Basic', 'Annual', 40)],
    'Mid-Market': [('Professional', 'Monthly', 500), ('Business', 'Monthly', 800), ('Professional', 'Annual', 400)],
    'Enterprise': [('Enterprise', 'Monthly', 2000), ('Premium', 'Monthly', 3500), ('Enterprise', 'Annual', 1800)]
}

print("🚀 Starting SaaS data generation...")

# Generate customers
customers = []
current_date = START_DATE

for i in range(NUM_CUSTOMERS):
    # Spread signups over 2 years with growth trend
    signup_date = START_DATE + timedelta(days=random.randint(0, (END_DATE - START_DATE).days))
    
    segment = random.choices(
        SEGMENTS,
        weights=[60, 30, 10],  # More SMB, fewer Enterprise
        k=1
    )[0]
    
    customer = {
        'name': fake.company(),
        'email': fake.email(),
        'signup_date': signup_date,
        'segment': segment,
        'region': random.choice(REGIONS)
    }
    customers.append(customer)

# Insert customers
print(f"📊 Inserting {len(customers)} customers...")
for customer in customers:
    cur.execute("""
        INSERT INTO customers (customer_name, email, signup_date, segment, region)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING customer_id
    """, (customer['name'], customer['email'], customer['signup_date'], 
          customer['segment'], customer['region']))
    customer['id'] = cur.fetchone()[0]

conn.commit()
print(f"✅ Inserted {len(customers)} customers")

# Generate subscriptions and invoices
print("💳 Generating subscriptions and invoices...")
subscription_count = 0
invoice_count = 0

for customer in customers:
    # Each customer gets 1-2 subscriptions over time
    num_subscriptions = random.choices([1, 2], weights=[80, 20], k=1)[0]
    
    for _ in range(num_subscriptions):
        # Pick plan based on segment
        plan_name, plan_type, base_mrr = random.choice(PLANS[customer['segment']])
        mrr = base_mrr * random.uniform(0.9, 1.2)  # Add variation
        
        start_date = customer['signup_date'] + timedelta(days=random.randint(0, 30))
        
        # Simulate churn: 15% cancel within first year, 10% in second year
        churned = random.random() < 0.15
        if churned:
            subscription_length = random.randint(90, 365)  # 3-12 months
            end_date = start_date + timedelta(days=subscription_length)
            if end_date > END_DATE:
                end_date = None  # Still active
        else:
            end_date = None  # Active subscription
        
        # Insert subscription
        cur.execute("""
            INSERT INTO subscriptions (customer_id, plan_name, plan_type, start_date, end_date, mrr)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING subscription_id
        """, (customer['id'], plan_name, plan_type, start_date, end_date, mrr))
        subscription_id = cur.fetchone()[0]
        subscription_count += 1
        
        # Generate monthly invoices
        invoice_date = start_date
        actual_end = end_date if end_date else END_DATE
        
        while invoice_date <= actual_end:
            # Monthly invoice amount (Annual plans get 1 big invoice)
            if plan_type == 'Annual':
                amount = mrr * 12 * 0.9  # 10% discount for annual
                num_invoices = 1
            else:
                amount = mrr
                num_invoices = 999  # Monthly recurring
            
            # Payment status: 95% paid, 3% unpaid, 2% refunded
            status = random.choices(
                ['Paid', 'Unpaid', 'Refunded'],
                weights=[95, 3, 2],
                k=1
            )[0]
            
            cur.execute("""
                INSERT INTO invoices (subscription_id, invoice_date, amount, status)
                VALUES (%s, %s, %s, %s)
            """, (subscription_id, invoice_date, amount, status))
            invoice_count += 1
            
            # Move to next month
            if plan_type == 'Annual':
                invoice_date = invoice_date.replace(year=invoice_date.year + 1)
            else:
                invoice_date = (invoice_date.replace(day=1) + timedelta(days=32)).replace(day=1)
            
            if invoice_date > actual_end:
                break

conn.commit()
print(f"✅ Created {subscription_count} subscriptions")
print(f"✅ Generated {invoice_count} invoices")

# Summary stats
cur.execute("SELECT COUNT(*) FROM customers")
total_customers = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM subscriptions WHERE end_date IS NULL")
active_subs = cur.fetchone()[0]

cur.execute("SELECT SUM(mrr) FROM subscriptions WHERE end_date IS NULL")
total_mrr = cur.fetchone()[0]

cur.execute("SELECT COUNT(DISTINCT customer_id) FROM subscriptions WHERE end_date IS NULL")
active_customers = cur.fetchone()[0]

print("\n" + "="*50)
print("📈 DATA GENERATION COMPLETE")
print("="*50)
print(f"Total Customers: {total_customers}")
print(f"Active Customers: {active_customers}")
print(f"Active Subscriptions: {active_subs}")
print(f"Total MRR: ${total_mrr:,.2f}")
print(f"ARR: ${total_mrr * 12:,.2f}")
print(f"ARPU: ${total_mrr / active_customers:,.2f}")
print("="*50)

cur.close()
conn.close()

print("\n✅ Ready for Tableau connection!")
print("   Host: localhost")
print("   Port: 5432")
print("   Database: executive_kpi")
print("   User: analytics_user")
