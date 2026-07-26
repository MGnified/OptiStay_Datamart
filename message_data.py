import random
from faker import Faker

faker = Faker()

def generate_message(characters: int):
    text = faker.text(max_nb_chars = characters)
    return text + "\n ----------------------------------- \n"


with open (r'data\messages.txt', "w") as message:
        for _ in range(20):
            message.write(generate_message(random.randint(10,1600)))




