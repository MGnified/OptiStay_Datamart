from faker import Faker
import random
import pandas

fake = Faker()



def generate_payment() -> tuple:

    receipt = str(fake.date_time_this_year(before_now=True, after_now=False))
    sub_total = round(10000 * random.random(), 2)
    service_fee = round(200 * random.random(), 2)
    total_tax = round(50 * random.random(), 2)
    total_amount = round(sub_total + service_fee + total_tax, 2)
    booking_id = random.randint(0, 40)
    method = random.randint(1, 10)
    address = random.randint(1, 30)

    return (
        receipt,
        sub_total,
        service_fee,
        total_tax,
        total_amount,
        booking_id,
        method,
        address,
    )


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


with open("data/payments.txt", "w") as payment:
    for _ in range(20):
        payment.write(f"{generate_payment()},\n")

with open("data/fee_payments.txt", "w") as fees:
    for _ in range(20):
        fees.write(f"{generate_fee_payment()},\n")

with open("data/host_payments.txt", "w") as host:
    for _ in range(20):
        host.write(f"{generate_host_payment()},\n")


print("Data successfully generated!")
