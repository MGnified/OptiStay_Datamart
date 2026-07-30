import random
from faker import Faker

fake = Faker()

def generate_recommendation() -> tuple:
    recommended_by = random.randint(1,20)
    recommended_to = random.randint(1,20)

    if recommended_by == recommended_to:
        recommended_to = random.randint(1,20)

    apartment_id = random.randint(1,20)

    return recommended_by, recommended_to, apartment_id 

def generate_wishlist()-> tuple:
    apartment_ID = random.randint(1,20)
    user_id = random.randint(1,20)
    adding_date = fake.date_this_year(True, False)

    return apartment_ID, user_id, adding_date

recommendations = [generate_recommendation() in range(20)]
wishlist = [generate_wishlist() in range(20)]

print(recommendations)
print(wishlist)

# with open ('data/recommendations_wishlists.txt', 'w') as interaction:
#     for _ in range(20):
#         interaction.write(f'{generate_recommendation()}\n')
#         interaction.write(f'{'-' * 60}\n')
#         interaction.write(f'{generate_wishlist()}')

