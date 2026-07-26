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


def generate_review(rating: int):
    if rating >= 4:
        return rating, random.choice([null, random.choice(pos_feedback)])

    elif rating == 3:
        return rating, random.choice([null, random.choice(feedback)])
    else:
        return rating, random.choice([null, random.choice(neg_feedback)])


rating = random.randint(0, 5)

with open ()
    for _ in range(20):
        (generate_review(random.randint(0, 5)))
