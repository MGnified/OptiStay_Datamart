from faker import Faker
import random
import pandas as pd
from datetime import date

fake = Faker()


df = pd.read_csv(r"data\booking_data.csv")
df["check_in"] = pd.to_datetime(df["check_in"])
df["check_out"] = pd.to_datetime(df["check_out"])


def generate_payment(row: int, df: pd.DataFrame) -> tuple | None:

    if df["check_in"][row] > pd.to_datetime(date.today()):
        return None

    receipt = str(fake.date_time_this_year(before_now=True, after_now=False))

    sub_total = df["price"][row] * df["total_nights"][row]
    service_fee = round(200 * random.random(), 2)
    total_tax = round(50 * random.random(), 2)
    total_amount = round(sub_total + service_fee + total_tax, 2)
    booking_id = row + 1
    method = random.randint(1, 11)
    address = random.randint(1, 30)

    return (
        receipt,
        float(sub_total),
        service_fee,
        total_tax,
        float(total_amount),
        booking_id,
        method,
        address,
    )


with open("data/payments.txt", "w") as pay:
    for i in range(len(df)):
        payment = generate_payment(row=i, df=df)
        if payment is None:
            continue
        else:
            pay.write(f"{payment},\n")


def generate_fee_payment() -> tuple:
    payment_id = random.randint(1, 20)
    price = round(100 * random.random(), 2)

    return payment_id, price


def generate_host_payment() -> tuple:

    date = str(fake.date_time_this_year(before_now=True, after_now=False))
    commission = round(10 * random.random(), 2)
    host_fees = round(100 * random.random(), 2)
    gross = round((1000 * random.random() + commission + host_fees), 2)
    net = round(gross - commission, 2)
    paid_to = random.choice(["Host", "CoHost"])
    payment_id = random.randint(1, 20)
    payee_id = random.randint(1, 20)

    return date, gross, commission, host_fees, net, paid_to, payment_id, payee_id


with open("data/fee_payments.txt", "w") as fees:
    for _ in range(50):
        fees.write(f"{generate_fee_payment()},\n")

with open("data/host_payments.txt", "w") as host:
    for _ in range(20):
        host.write(f"{generate_host_payment()},\n")


print("Data successfully generated!")
