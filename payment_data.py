from faker import Faker
import random
import pandas as pd
from datetime import date, datetime, timedelta

fake = Faker()

bookings = pd.read_csv(r"data\booking_data.csv")
bookings["check_in"] = pd.to_datetime(bookings["check_in"])
bookings["check_out"] = pd.to_datetime(bookings["check_out"])
bookings["booking_date"] = pd.to_datetime(bookings["booking_date"])

# print(bookings.dtypes)
# print(bookings.head())

taxes = [
    0.1,  # austria
    0.07,  # germany
    0.038,  # switzerland
    0.1,  # France
    0.21,  # Netherlands
]


def generate_payment(row: int, df: pd.DataFrame) -> tuple | None:

    receipt = str(df["booking_date"][row])

    sub_total = df["price"][row] * df["total_nights"][row]
    service_fee = round(200 * random.random(), 2)
    total_tax = round(random.choice(taxes) * sub_total)
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
    for i in range(len(bookings)):
        payment = generate_payment(row=i, df=bookings)
        pay.write(f"{payment},\n")

file = "data/payments.txt"

pay_headers = [
    "receipt",
    "sub_total",
    "service_fee",
    "total_tax",
    "total_amount",
    "booking_id",
    "method",
    "address",
    "Nothing",
]

raw_payments = pd.read_csv(file, header=None, names=pay_headers, index_col=None)

pay_cols = [
    "receipt",
    "sub_total",
    "service_fee",
    "total_tax",
    "total_amount",
    "booking_id",
    "method",
    "address",
]

payments = raw_payments[pay_cols]

payments["receipt"] = payments["receipt"].str.strip("(")
payments["receipt"] = pd.to_datetime(payments["receipt"])
payments["address"] = payments["address"].str.strip(")").astype(int)


def generate_host_payment(row, df) -> tuple:

    pay_date = str(df["receipt"][row] + timedelta(hours=24))
    commission = round(df["total_amount"][row] * 0.03, 2)
    host_fees = round(100 * random.random(), 2)
    gross = round(df["total_amount"][row] + commission + host_fees, 2)
    net = round(gross - commission, 2)
    share = random.choice([1, round(random.random(), 2)]) 
    paid_to = random.choice(["Host", "CoHost"]) if share < 1 else "Host" 
    payment_id = row + 1
    payee_id = random.randint(1, 20)

    return (
        f'{pay_date}',
        float(gross),
        float(commission),
        float(host_fees),
        float(net),
        float(share),
        paid_to,
        payment_id,
        payee_id,
    )


with open("data/host_payments.txt", "w") as host:
    for i in range(20):
        host.write(f"{generate_host_payment(row=i, df=payments)},\n")

file = "data/host_payments.txt"

host_headers = [
    "pay_date",
    "gross",
    "commission",
    "host_fees",
    "net",
    "share",
    "paid_to",
    "payment_id",
    "payee_id",
    'Nothing'
]

raw_hosts = pd.read_csv(file, header=None, names=host_headers, index_col=None)

host_cols = [
    "pay_date",
    "gross",
    "commission",
    "host_fees",
    "net",
    "share",
    "paid_to",
    "payment_id",
    "payee_id",
]

hosts = raw_hosts[host_cols]

hosts['pay_date'] = hosts['pay_date'].str.strip('(')
hosts['pay_date'] = pd.to_datetime(hosts['pay_date'])
hosts['payee_id'] = hosts["payee_id"].str.strip(')')


# def generate_fee_payment() -> tuple:

#     feetype_id = random.randint(1, 15)
#     payment_id = random.randint(1, 28)
#     price = round(50 * random.random(), 2)

#     return feetype_id, payment_id, price


# with open("data/fee_payments.txt", "w") as fees:
#     for _ in range(50):
#         fees.write(f"{generate_fee_payment()},\n")


print("Data successfully generated!")
