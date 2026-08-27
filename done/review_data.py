import random
import pandas as pd
from datetime import datetime, date, timedelta
from faker import Faker

fake = Faker()

# Needed columns:
# check out date, host Id, user ID
review_df = pd.read_excel("data/booking_messages.xlsx")

user_pos_feedback = [
    "Very nice apartment! Perfectly located and clean.",
    "Definitely coming again!",
    "NULL"
]

user_neutral_feedback = ["Stay was okay.", "No complaints", 'NULL']

user_neg_feedback = [
    "Horrible apartment! Never again!",
    "Dirty and bad service",
    'NULL'
]

host_pos_feedback = [
    "Left the apartment clean and paid right away",
    "Very polite and reliable",
    'NULL'
]

host_neg_feedback = ["Left a mess in the apartment!", "NULL"]


review_type = ["Host", "Guest", "Guest"]

review_set = set()

def generate_review(rating: int, type: str):


    row = review_df.iloc[random.randint(0, len(review_df) - 1)]

    check_out = pd.to_datetime(row["CheckOutDate"])
    booking_id = row["BookingID"]

    while check_out > datetime.now() or (booking_id, type) in review_set: 
        row = review_df.iloc[random.randint(0, len(review_df) - 1)]
        check_out = pd.to_datetime(row["CheckOutDate"])      
        booking_id = row["BookingID"]

    review_set.add((booking_id, type))
    review_threshold = check_out + timedelta(2) 

    if type == "Guest":
        user_id = row["UserID"]
        if rating >= 4:
            comment = random.choice(user_pos_feedback)

        elif rating == 3:
            comment = random.choice(user_neutral_feedback)

        else:
            comment = random.choice(user_neg_feedback)

    if type == "Host":
        user_id = row["HostID"]
        if rating >= 4:
            comment = random.choice(host_pos_feedback)

        elif rating == 3:
            comment = "NULL"

        else:
            comment = random.choice(host_neg_feedback)


    check_out = pd.to_datetime(row["CheckOutDate"])
    review_threshold = check_out + timedelta(2)
    review_date = fake.date_time_between(check_out, review_threshold)

    return rating, comment, type, str(review_date), int(user_id), int(booking_id)


with open("data/reviews.txt", "w") as review:
    for _ in range(20):
        review.write(
            f"{generate_review(random.randint(1,5), random.choice(review_type))},\n"
        )

print("Data successfully generated!")
