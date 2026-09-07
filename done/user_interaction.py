import random
import pandas as pd

from faker import Faker

fake = Faker()

apartment_df = pd.read_excel("data/apartment_data.xlsx")
cohost_df = pd.read_csv("data/cohost_apartment.csv")


def generate_recommendation() -> tuple:
    """Generate dummy data for recommendations between users."""

    # locating a randomized row to determine apartments & hosts/cohosts
    row = apartment_df.iloc[random.randint(0, len(apartment_df) - 1)]
    apartment_id = row["ApartmentID"]
    host_id = row["UserID"]
    cohost_check = cohost_df[cohost_df["ApartmentID"] == apartment_id]
    cohost_checklist = cohost_check["CoHostID"].to_list()

    # determining random users & ensure no hosts/cohosts get recommended hosted apartments
    recommended_by = random.randint(1, 20)
    recommended_to = random.randint(1, 20)

    while (
        recommended_by == recommended_to
        or recommended_to == host_id
        or recommended_to in cohost_checklist
    ):
        recommended_to = random.randint(1, 20)

    return recommended_by, recommended_to, int(apartment_id)


with open("data/recommendations.txt", "w") as entry:
    for _ in range(20):
        entry.write(f"{generate_recommendation()},\n")


def generate_wishlist() -> tuple:
    """Generate dummy data for wishlist entries."""

    # locating randomized apartment row & extracting apartment & hosts/cohosts
    row = apartment_df.iloc[random.randint(0, len(apartment_df) - 1)]
    apartment_id = row["ApartmentID"]

    host_id = row["UserID"]

    cohost_check = cohost_df[cohost_df["ApartmentID"] == apartment_id]
    cohost_checklist = cohost_check["CoHostID"].to_list()

    # randomized user ID & logic that no host/cohost wishes hosted apartment
    user_id = random.randint(1, 20)

    while user_id == host_id or user_id in cohost_checklist:
        user_id = random.randint(1, 20)

    # randomized date for wishlist entry
    adding_date = fake.date_this_year(True, False)

    return int(apartment_id), user_id, str(adding_date)


with open("data/wishlist.txt", "w") as entry:
    for _ in range(20):
        entry.write(f"{generate_wishlist()},\n")

print("Data successfully generated!")
