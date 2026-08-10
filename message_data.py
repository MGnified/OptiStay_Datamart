import random
from faker import Faker

faker = Faker()


def generate_message(characters: int, support: bool = False) -> tuple:
    """
    Generate dummy message data including sending information.

    Args:
        characters (int): number of characters in the message text
        support (bool): if True the data is generated between user and admin, defaults to false.

    Returns:
        tuple: tuple containing message text, sent at timestamp, sender and receiver user ID.
    """
    text = faker.text(max_nb_chars=characters).replace("\n", " ")
    sent_at = str(faker.date_time_this_year(before_now=True, after_now=False))

    sender = random.randint(1, 20)
    receiver = random.randint(1, 20) if not support else random.randint(1, 5)

    if sender == receiver:
        sender = random.randint(1, 20)
        receiver = random.randint(1, 20) if not support else random.randint(1, 5)

    booking_id = random.choice(["NULL", random.randint(1, 20), random.randint(1,20), random.randint(1,20)])

    return text, sent_at, receiver, sender, booking_id


with open("data/user_messages.txt", "w") as message:
    for _ in range(20):
        message.write(f"{generate_message(random.randint(10, 500))},\n")


with open("data/support_messages.txt", "w") as message:
    for _ in range(20):
        message.write(f"{generate_message(random.randint(10, 500), True)},\n")

print("Data successfully generated!")
