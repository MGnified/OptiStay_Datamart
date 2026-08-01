import random

pos_feedback: list = [
    "Very nice apartment! Perfectly located and clean.",
    "Everything was fine and there were no problems",
    "looked exactly like in the pictures",
    "Definitely coming again!",
]

feedback: list = ["Stay was okay.", "No complaints"]

neg_feedback: list = [
    "Horrible apartment! Never again!",
    "Scam. Apartment does not look like in the images",
    "Dirty and bad service",
]

null = "NULL"

review_type = ["Host", "Guest"]


def generate_review(rating: int):
    if rating >= 4:
        comment = random.choice([null, random.choice(pos_feedback)])

    elif rating == 3:
        comment = random.choice([null, random.choice(feedback)])

    else:
        comment = random.choice(neg_feedback)

    return rating, comment


rating = random.randint(0, 5)


with open("data/reviews.txt", "w") as review:
    for _ in range(20):
        review.write(f"{generate_review(random.randint(0, 5))}\n")
