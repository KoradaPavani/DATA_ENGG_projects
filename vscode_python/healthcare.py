import csv
import random
from faker import Faker

fake = Faker("en_IN")
Faker.seed(1)


def maybe_null(value, probability=0.1):
    return value if random.random() > probability else ""



employee_ids = []
employee_rows = []

for i in range(1, 50001):
    employee_ids.append(i)

    employee_rows.append({
        "employee_id": i,
        "employee_name": fake.name(),
        "gender": random.choice(["Male", "Female"]),
        "date_of_birth": fake.date_of_birth(minimum_age=21, maximum_age=60),
        "email": maybe_null(fake.email(), 0.1),
        "phone": maybe_null(fake.phone_number(), 0.05),
        "department": random.choice(["IT", "HR", "Finance", "Operations", "Admin"]),
        "designation": random.choice(["Engineer", "Analyst", "Manager", "Executive"]),
        "city": fake.city(),
        "state": fake.state(),
        "join_date": fake.date_between(start_date="-5y", end_date="today"),
        "salary": random.randint(300000, 1200000),
        "employment_status": random.choice(["Active", "On Leave", "Resigned"])
    })

with open("employee.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=employee_rows[0].keys())
    writer.writeheader()
    writer.writerows(employee_rows)
    
    
claim_rows = []
claim_id = 1

for emp_id in employee_ids:
    for _ in range(random.randint(1, 3)):
        status = random.choice(["Approved", "Rejected", "Pending"])
        claim_amount = random.randint(5000, 200000)

        claim_rows.append({
            "claim_id": claim_id,
            "employee_id": emp_id,
            "hospital_name": maybe_null(fake.company(), 0.05),
            "diagnosis": maybe_null(fake.word(), 0.05),
            "treatment_type": random.choice(["Inpatient", "Outpatient"]),
            "admission_date": fake.date_between(start_date="-3y", end_date="today"),
            "discharge_date": fake.date_between(start_date="-3y", end_date="today"),
            "claim_amount": claim_amount,
            "approved_amount": claim_amount if status == "Approved" else "",
            "claim_status": status,
            "claim_date": fake.date_between(start_date="-3y", end_date="today")
        })
        claim_id += 1

with open("healthcare_claims.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=claim_rows[0].keys())
    writer.writeheader()
    writer.writerows(claim_rows)



transaction_rows = []
transaction_id = 1

for emp_id in employee_ids:
    for _ in range(random.randint(2, 4)):
        payment_mode = random.choice(["UPI", "Bank Transfer", "Cash"])

        transaction_rows.append({
            "transaction_id": transaction_id,
            "employee_id": emp_id,
            "transaction_type": random.choice(["Salary", "Claim_Payout", "Reimbursement"]),
            "amount": random.randint(10000, 150000),
            "payment_mode": payment_mode,
            "bank_name": "" if payment_mode == "Cash" else fake.bank(),
            "account_number": "" if payment_mode == "Cash" else fake.bban(),
            "transaction_date": fake.date_between(start_date="-3y", end_date="today"),
            "transaction_status": random.choice(["Success", "Failed", "Pending"])
        })
        transaction_id += 1

with open("finance_transactions.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=transaction_rows[0].keys())
    writer.writeheader()
    writer.writerows(transaction_rows)
