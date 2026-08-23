import random
from datetime import date, timedelta, datetime
import pandas as pd
from faker import Faker

fake = Faker()

apartment_df = pd.read_excel('data/apartment_data.xlsx')
cohost_df = pd.read_csv('data/cohost_apartment.csv', skipinitialspace=True)
user_df = pd.read_csv('data/user_addresses.csv', skipinitialspace=True)
print(apartment_df.columns)



booking_types = {1: [1,3,6,7,8,9,10],
                 2: [1,3,5,7,8,9,10],
                 3: [1,2,3,7,8,9,10],
                 4: [1,2,3,4,7,8,9,10],
                 5: [1,2,4,7,8,9,10], 
                 6: [1,2,4,7,8,9,10], 
                 7: [1,2,4,7,8,9,10], 
                 8: [1,2,4,7,8,9,10], 
                 9: [1,2,4,7,8,9,10], 
                 10: [1,2,4,7,8,9,10], 
                 }


def generate_booking() -> tuple:

    # Check-in and Check-out calculations
    check_in = fake.date_this_year(before_today=True, after_today=True)
    min_stay = check_in + timedelta(days=1)
    max_stay = check_in + timedelta(days=14)
    check_out = fake.date_between_dates(date_start=min_stay, date_end=max_stay)
    total_nights = check_out - check_in

    # booking date calculation
    booking_opening_date = datetime(2025, 12, 31, 0, 0, 0)
    last_booking_date = min(check_in - timedelta(days=1), date.today())
    booking_date = fake.date_time_between(booking_opening_date, last_booking_date)

    # booking data randomizer
    row = apartment_df.iloc[random.randint(0, len(apartment_df) -1)]
    apartment = row['ApartmentID']
    num_guests = random.randint(1, row['NumberOfBedrooms'] *2 )
    price = row['BasePricePerNight']
    booking_type = random.choice(booking_types[num_guests])

    user_id = random.choice(user_df['UserID'])
    cohost_check = cohost_df[cohost_df['ApartmentID'] == apartment]
    cohost_checklist = cohost_check['CoHostID'].to_list() 

    while user_id == row['UserID'] or user_id in cohost_checklist:
        user_id = random.choice(user_df['UserID'])

    return (
        f"{booking_date}",
        f"{check_in}",
        f"{check_out}",
        num_guests,
        float(price),
        int(total_nights.days),
        int(booking_type),
        int(user_id),
        int(apartment),
    )



with open("data/booking_data.txt", "w") as data:
    for _ in range(20):
        data.write(f"{generate_booking()},\n")




print("Data successfully generated!")
