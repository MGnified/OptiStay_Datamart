
from faker import Faker
import random
from datetime import timedelta

fake = Faker()


def generate_booking(past:bool, future: bool):
    check_in = fake.date_this_year(before_today=past, after_today=future)

    min_stay = check_in + timedelta(days=1)
    max_stay = check_in + timedelta(days=14)

    check_out = fake.date_between_dates(date_start=min_stay, date_end=max_stay)

    return f"('{check_in}'),('{check_out}')"

booking_dates = []
random_bool = random.choice([True, False])

for _ in range(20):
    dates = generate_booking(random_bool, random_bool)
    booking_dates.append(dates)

print(tuple(booking_dates))


payment_methods = ['cash', 'card']

def make_payments():
    method = random.choice(payment_methods)
    date = fake.date_this_year()

    return method, str(date)

make_payments()
    