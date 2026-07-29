import random
from faker import Faker

faker = Faker()


def generate_message(characters: int):
    text = faker.text(max_nb_chars=characters)
    return text


with open(r"data\user_messages.txt", "w") as message:
    for _ in range(20):
        message.write(generate_message(random.randint(10, 1600)))
        message.write(f"\n {'=' * 40} \n")

with open(r"data\support_messages.txt", "w") as message:
    for _ in range(20):
        message.write(generate_message(random.randint(10, 1600)))
        message.write(f"\n {'=' * 40} \n")
