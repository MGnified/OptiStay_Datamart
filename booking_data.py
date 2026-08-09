import random
from datetime import date, timedelta
import pandas as pd
from faker import Faker

fake = Faker()

prices = [
    120.00,
    85.00,
    250.00,
    95.00,
    150.00,
    400.00,
    75.00,
    110.00,
    90.00,
    600.00,
    300.00,
    180.00,
    65.00,
    70.00,
    130.00,
    140.00,
    220.00,
    80.00,
    500.00,
    160.00,
]


def generate_booking() -> tuple:
    """
    Generate booking dummy data with various information.

    Args:
        None

    Returns
        tuple: tuple consisting of booking date, check-in, check-out, number of guests, price, total nights, user id and apartment id
    """
    # Check-in and Check-out calculations
    check_in = fake.date_this_year(before_today=True, after_today=True)
    min_stay = check_in + timedelta(days=1)
    max_stay = check_in + timedelta(days=14)
    check_out = fake.date_between_dates(date_start=min_stay, date_end=max_stay)
    total_nights = check_out - check_in

    # booking date calculation
    booking_opening_date = date(2025, 12, 31)
    last_booking_date = check_in - timedelta(1)
    booking_date = fake.date_between(booking_opening_date, last_booking_date)

    # booking data randomizer
    num_guests = random.randint(1, 5)
    booking_type = random.randint(1, 10)
    user_id = random.randint(1, 20)
    apartment = random.randint(1, 20)
    price = prices[apartment - 1]

    return (
        f"{booking_date}",
        f"{check_in}",
        f"{check_out}",
        num_guests,
        price,
        total_nights.days,
        booking_type,
        user_id,
        apartment,
    )


booking_dates = []

# generate_booking(random_bool, random_bool)

with open("data/booking_data.txt", "w") as data:
    for _ in range(40):
        data.write(f"{generate_booking()},\n")
        
print("Data successfully generated!")
