import random

import pandas as pd
from faker import Faker

fake = Faker()

bookings_df = pd.read_excel(r"data/booking_full.xlsx")
amenities_df = pd.read_excel(r"data/apartment_amenities.xlsx")
feetypes_df = pd.read_excel("data/feetypes.xlsx")
cohost_df = pd.read_csv("data/cohost_apartment.csv")

taxes = {"AUT": 0.1, "DEU": 0.07, "CHE": 0.038, "FRA": 0.1, "NLD": 0.21}

fee_prices = {
    1: (10.00, 15.00),  # cleaning
    2: (5.00, 10.00),  # pets
    3: (20.00, 40.00),  # extra guest
    4: (25.00, 30.00),  # late checkout
    5: (25.00, 30.00),  # early check in
    6: (40.00, 60.00),  # resort
    7: (5.00, 10.00),  # parking
    8: (10.00, 30.00),  # equipment rental
    9: (100.00, 300.00),  # event party
    10: (5.00, 10.00),  # infant equipment
    11: (5.00, 10.00),  # linen & towels
}

platform_fee_prices = {
    12: (0.01, 0.03),  # currency conversion (only sui)
    13: (0.01, 0.03),  # payment processing
    14: (0.05, 0.15),  # booking protection
}

apartment_amenities = (
    amenities_df.groupby("ApartmentID")["Amenity"].apply(set).to_dict()
)

payment_methods = {9, 10}  # excluded ids for gift card & Corporate invoice


def generate_fee_payment(
    booking_row: pd.Series, 
    payment_id: int, 
    payment_method_id: int, 
    subtotal: float,
) -> list[tuple]:
    """Generate dummy data for fee payments with randomized prices 
    based on a previously created dictionary."""

    fees = []

    # default fees for ever booking -> prices randomized based on predefined list
    cleaning = round(random.uniform(fee_prices[1][0], fee_prices[1][1]), 2)
    linen_towels = round(random.uniform(fee_prices[11][0], fee_prices[11][1]), 2)

    fees.append((1, payment_id, cleaning))
    fees.append((11, payment_id, linen_towels))

    # specifying number of additional fees to add, randomizing them & subsetting additional amenities for fees
    num_of_fees = random.choices(
        [0, 1, 2, 3, 4, 5], weights=[0.5, 0.1, 0.1, 0.1, 0.1, 0.1], k=1
    )[0]

    randomized_fees = random.sample([4, 5, 8, 9, 10], num_of_fees)
    amenity_set = apartment_amenities[booking_row["ApartmentID"]]

    # appending randomized fees with no connection to amenities
    for fee in randomized_fees:
        fees.append(
            (
                fee,
                payment_id,
                round(random.uniform(fee_prices[fee][0], fee_prices[fee][1]), 2),
            )
        )

    # appending parking if defined in amenity for this booked apartment
    if "Parking" in amenity_set:
        fees.append(
            (
                7,
                payment_id,
                round(random.uniform(fee_prices[7][0], fee_prices[7][1]), 2),
            )
        )

    # Resort is only paid if a swimming pool exists
    if "Swimming Pool" in amenity_set:
        fees.append(
            (
                6,
                payment_id,
                round(random.uniform(fee_prices[6][0], fee_prices[6][1]), 2),
            )
        )

    # pets are only paid for apartments with ped amenities, not only guest has pet therefore only 50% of these bookings
    if amenity_set & {"Dog bed", "Pet Bowls"} and random.random() < 0.5:
        fees.append(
            (
                2,
                payment_id,
                round(random.uniform(fee_prices[2][0], fee_prices[2][1]), 2),
            )
        )

    # determining if extra guest fee has to be paid, when number of bedrooms + 1 is exceeded
    extra_guests = booking_row["NumberOfGuests"] - (booking_row["NumberOfBedrooms"] + 1)

    if extra_guests > 0:
        extra_guest_price = float(
            extra_guests * (random.uniform(fee_prices[3][0], fee_prices[3][1]))
        )
        fees.append((3, payment_id, round(extra_guest_price, 2)))

    # adding platform fees randomly for protections
    if random.random() < 0.5:
        protection = subtotal * random.uniform(
            platform_fee_prices[14][0], platform_fee_prices[14][1]
        )
        fees.append((14, payment_id, round(protection, 2)))

    # check switzerland for currency conversion
    if booking_row["Country"] == "CHE":
        conversion = subtotal * random.uniform(
            platform_fee_prices[12][0], platform_fee_prices[12][1]
        )
        fees.append((12, payment_id, round(conversion, 2)))

    # only adding payment processing methods to every type other than gift cards and corporate invoice
    if payment_method_id not in payment_methods:
        processing = subtotal * random.uniform(
            platform_fee_prices[13][0], platform_fee_prices[13][1]
        )
        fees.append((13, payment_id, round(processing, 2)))

    return fees


def generate_payment(
        booking_row: pd.Series,
        booking_id: int,
        payment_method_id: int,
        fee_list: list[tuple],
        subtotal: float,
) -> tuple:
    """Generate dummy data of payments for each booking."""
    receipt = str(booking_row["BookingDate"])

    platform_total = 0.0
    host_total = 0.0 

    # split fees by category 
    # platform fees for guests as ServiceFeeGuest, and hosts fees through HostPayouts
    for fee in fee_list:
        price = fee[2]
        if fee[0] in platform_fee_prices:
            platform_total += price
        else:
            host_total += price

    total_tax = round(subtotal * taxes[booking_row["Country"]], 2)

    # host fees included in TotalAmount but paid via HostPayout -> not returned here
    total_amount = round(subtotal + platform_total + host_total + total_tax, 2)

    # invoice goes to bookers own address, data was generated via UserID = AddressID
    address = booking_row["UserID"]

    return (
        receipt,
        float(subtotal),
        round(platform_total, 2),
        float(total_tax),
        float(total_amount),
        booking_id,
        payment_method_id,
        int(address),
    )


payment_id = 1
fee_payments = []
payments = []

with (
    open("data/fee_payments.txt", "w") as fee_txt,
    open("data/payments.txt", "w") as payment_txt,
):
    for idx, row in bookings_df.iterrows():
        sub_total = row["PricePerNight"] * row["TotalNights"]
        payment_method = random.randint(1, 10)

        fee_payment = generate_fee_payment(row, payment_id, payment_method, sub_total)
        for fee in fee_payment:
            fee_txt.write(f"{fee}, \n")

        payment = generate_payment(
            row, row["BookingID"], payment_method, fee_payment, sub_total
        )
        payment_txt.write(f"{payment}, \n")

        payment_id += 1

print("Data successfully generated!")
