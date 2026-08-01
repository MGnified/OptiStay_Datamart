import random

from faker import Faker

fake = Faker()


def generate_recommendation() -> tuple:
    recommended_by = random.randint(1, 20)
    recommended_to = random.randint(1, 20)

    if recommended_by == recommended_to:
        recommended_to = random.randint(1, 20)

    apartment_id = random.randint(1, 20)

    return recommended_by, recommended_to, apartment_id


def generate_wishlist() -> tuple:
    apartment_ID = random.randint(1, 20)
    user_id = random.randint(1, 20)
    adding_date = fake.date_this_year(True, False)

    return apartment_ID, user_id, str(adding_date)


recommendations = []
wishlists = []

for _ in range(20):
    recommendations.append(generate_recommendation())
    wishlists.append(generate_wishlist())

with open("data/user_interaction.txt", "w") as interaction:
    for recommendation in recommendations:
        interaction.write(f"{recommendation}\n")
    interaction.write(f"{'-' * 60}\n")
    for wishlist in wishlists:
        interaction.write(f"{wishlist}\n")
