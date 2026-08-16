import random
from datetime import date, timedelta, datetime
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

    # Check-in and Check-out calculations
    check_in = fake.date_this_year(before_today=True, after_today=True)
    min_stay = check_in + timedelta(days=1)
    max_stay = check_in + timedelta(days=14)
    check_out = fake.date_between_dates(date_start=min_stay, date_end=max_stay)
    total_nights = check_out - check_in

    # booking date calculation
    booking_opening_date = datetime(2025, 12, 31, 0, 0, 0)
    last_booking_date = check_in - timedelta(days=1)
    booking_date = fake.date_time_between(booking_opening_date, last_booking_date)

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
    for _ in range(20):
        data.write(f"{generate_booking()},\n")

file = r'data/booking_data.txt'

headers = [
    "booking_date",
    "check_in",
    "check_out",
    "num_guests",
    "price",
    "total_nights",
    "booking_type",
    "user_id",
    "apartment",
    "Nothing",
]

bookings = pd.read_csv(file, header=None, names=headers, index_col=None)

bookings["check_in"] = pd.to_datetime(bookings["check_in"])
bookings["check_out"] = pd.to_datetime(bookings["check_out"])
bookings["booking_date"] = bookings["booking_date"].str.strip("(")
bookings["booking_date"] = pd.to_datetime(bookings["booking_date"])
bookings["apartment"] = bookings["apartment"].str.strip(")").astype(int)

cols = [
    "booking_date",
    "check_in",
    "check_out",
    "num_guests",
    "price",
    "total_nights",
    "user_id",
]

payment_bookings = bookings[cols]

payment_bookings.to_csv(r"data\booking_data.csv", columns=cols, index=False)


print("Data successfully generated!")
