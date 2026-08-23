from faker import Faker
import random
import pandas as pd
from datetime import date, datetime, timedelta

fake = Faker()

bookings_df = pd.read_excel(r'data/booking_full.xlsx')
amenities_df = pd.read_excel(r'data/apartment_amenities.xlsx')
feetypes_df = pd.read_excel('data/feetypes.xlsx')


taxes = {'AUT':0.1, 'DEU': 0.07, 'CHE': 0.038, 'FRA':0.1, 'NLD': 0.21}

taxes = [
    0.1,  # austria
    0.07,  # germany
    0.038,  # switzerland
    0.1,  # France
    0.21,  # Netherlands
]


def generate_fee_payment(booking_row: pd.Series) -> list[tuple]:

    cleaning_fee = feetypes_df[1]



    # feetype_id = feetypes_df[feetypes_df['FeetypeID']]
    # payment_id = random.randint(1, 20)
    # price = round(50 * random.random(), 2)

    return feetype_id, payment_id, price


with open("data/fee_payments.txt", "w") as fees:
    for _ in range(50):
        fees.write(f"{generate_fee_payment()},\n")

payment_method = random.randint(1,10)


# def generate_payment(row: int, df: pd.DataFrame) -> tuple | None:

#     receipt = str(df["booking_date"][row])

#     sub_total = df["price"][row] * df["total_nights"][row]
#     service_fee = round(200 * random.random(), 2)
#     total_tax = round(random.choice(taxes) * sub_total)
#     total_amount = round(sub_total + service_fee + total_tax, 2)
#     booking_id = row + 1
#     method = random.randint(1, 11)
#     address = random.randint(1, 30)

#     return (
#         receipt,
#         float(sub_total),
#         service_fee,
#         total_tax,
#         float(total_amount),
#         booking_id,
#         method,
#         address,
#     )

# with open("data/payments.txt", "w") as pay:
#     for i in range(len(bookings_df)):
#         payment = generate_payment(row=i, df=bookings_df)
#         pay.write(f"{payment},\n")

# def generate_host_payment(row, df) -> tuple:

#     pay_date = str(df["receipt"][row] + timedelta(hours=24))
#     commission = round(df["total_amount"][row] * 0.03, 2)
#     host_fees = round(100 * random.random(), 2)
#     gross = round(df["total_amount"][row] + commission + host_fees, 2)
#     net = round(gross - commission, 2)
#     share = random.choice([1, round(random.random(), 2)]) 
#     paid_to = random.choice(["Host", "CoHost"]) if share < 1 else "Host" 
#     payment_id = row + 1
#     payee_id = random.randint(1, 20)

#     return (
#         f'{pay_date}',
#         float(gross),
#         float(commission),
#         float(host_fees),
#         float(net),
#         float(share),
#         paid_to,
#         payment_id,
#         payee_id,
#     )

# with open("data/host_payments.txt", "w") as host:
#     for i in range(20):
#         host.write(f"{generate_host_payment(row=i, df=payments)},\n")


# print("Data successfully generated!")
