import random

import pandas as pd
from datetime import datetime
from faker import Faker

fake = Faker()

# Needed columns in df: 
# booking date, check in & out, user ID, hostID
message_data_df = pd.read_excel('data/booking_messages.xlsx')

def generate_message(characters: int, support: bool = False) -> tuple:

    row = message_data_df.iloc[random.randint(0, len(message_data_df)-1)]
    text = fake.text(max_nb_chars=characters).replace("\n", " ")
    booking_date = pd.to_datetime(row['BookingDate'])
    check_out = pd.to_datetime(row['CheckOutDate'])
    sending_threshold = fake.date_time_between(booking_date, check_out)
    sent_at = fake.date_time_between(sending_threshold, datetime.now())
    booking_id = row['BookingID']

    if support:
        sender = row['UserID']
        receiver = random.randint(1,5)

    else:
        sender = random.choice([row['UserID'], row['HostID']])
        receiver = row['UserID'] if sender == row['HostID'] else row["HostID"]

    # if sender == receiver:
    #     sender = random.randint(1,20)
    #     receiver = random.randint(1, 20) if not support else random.randint(1, 5)


    return text, str(sent_at), int(receiver), int(sender), int(booking_id)


with open("data/user_messages.txt", "w") as message:
    for _ in range(20):
        message.write(f"{generate_message(random.randint(10, 500))},\n")


with open("data/support_messages.txt", "w") as message:
    for _ in range(20):
        message.write(f"{generate_message(random.randint(10, 500), True)},\n")

print("Data successfully generated!")
