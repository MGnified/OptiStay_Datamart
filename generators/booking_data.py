# %%
from faker import Faker
import random
from datetime import timedelta

fake = Faker()


def generate_booking(past: bool, future: bool) -> tuple:

    # date calculation
    check_in = fake.date_this_year(before_today=past, after_today=future)
    min_stay = check_in + timedelta(days=1)
    max_stay = check_in + timedelta(days=14)
    check_out = fake.date_between_dates(date_start=min_stay, date_end=max_stay)

    num_guests = random.randint(1, 5)

    # price per night has to be added based on apartment
    total_nights = check_out - check_in

    # 
    booking_type = random.randint(1, 10)
    user_id = random.randint(1, 20)
    apartment = random.randint(1, 20)
    
    return (
        f'{check_in}',
        f'{check_out}',
        num_guests,
        total_nights.days,
        booking_type,
        user_id,
        apartment,
    )


booking_dates = []
random_bool = random.choice([True, False])

# generate_booking(random_bool, random_bool)

with open("data/data.booking_data", "w") as data:
    for _ in range(30):
        data.write(str(generate_booking(random_bool, random_bool)))
        data.write("\n")
