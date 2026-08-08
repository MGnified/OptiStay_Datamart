import random

from faker import Faker

fake = Faker()


def generate_recommendation() -> tuple:
    """
    Generate dummy recommendation data.

    Args:
        None

    Returns:
        tuple: tuple containing user ids for recommenders and recommended, and apartment id
    """
    recommended_by = random.randint(1, 20)
    recommended_to = random.randint(1, 20)

    if recommended_by == recommended_to:
        recommended_to = random.randint(1, 20)

    apartment_id = random.randint(1, 20)

    return recommended_by, recommended_to, apartment_id


def generate_wishlist() -> tuple:
    """
    Generate dummy wishlist data.

    Args:
        None

    Returns:
        tuple: tuple containing apartment and user id, and an adding date.
    """
    apartment_ID = random.randint(1, 20)
    user_id = random.randint(1, 20)
    adding_date = fake.date_this_year(True, False)

    return apartment_ID, user_id, str(adding_date)


recommendations = []
wishlists = []

for _ in range(20):
    recommendations.append(generate_recommendation())
    wishlists.append(generate_wishlist())

with open("data/recommendations.txt", "w") as entry:
    for recommend in recommendations:
        entry.write(f"{recommend}\n")

with open("data/wishlist.txt", "w") as entry:
    for wish in wishlists:
        entry.write(f"{wish}\n")

print("Data successfully generated!")
