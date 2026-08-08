import random
from faker import Faker

fake = Faker()

user_pos_feedback = [
    "Very nice apartment! Perfectly located and clean.",
    "looked exactly like in the pictures",
    "Definitely coming again!",
]

user_neutral_feedback = ["Stay was okay.", "No complaints"]

user_neg_feedback = [
    "Horrible apartment! Never again!",
    "Dirty and bad service",
]

host_pos_feedback = ["Left the apartment clean and paid right away", "Very polite and reliable"]

host_neg_feedback = ["Didn't like them", "Left a mess in the apartment!!"]


review_type = ["Host", "Guest", "Guest"]


def generate_review(rating: int, type: str):
    if type == 'Guest':
        if rating >= 4:
            comment = random.choice(['NULL', random.choice(user_pos_feedback)])

        elif rating == 3:
            comment = random.choice(['NULL', random.choice(user_neutral_feedback)])

        else:
            comment = random.choice(['NULL', random.choice(user_neg_feedback)])

    elif type == 'Host':
        if rating >= 4:
            comment = random.choice(['NULL', random.choice(host_pos_feedback)])

        elif rating == 3:
            comment = 'NULL'

        else:
            comment = random.choice(['NULL', random.choice(host_neg_feedback)])

    date = str(fake.date_time_this_year())
    user_id = random.randint(1,20)
    booking_id = random.randint(1,20)

    return rating, comment, type, date, user_id, booking_id


rating = random.randint(0, 5)


with open("data/reviews.txt", "w") as review:
    for _ in range(40):
        review.write(f"{generate_review(random.randint(0, 5), random.choice(review_type))}\n")

print("Data successfully generated!")