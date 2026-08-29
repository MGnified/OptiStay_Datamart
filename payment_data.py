# %%
from faker import Faker
import random
import pandas as pd
from datetime import date, datetime, timedelta

fake = Faker()

bookings_df = pd.read_excel(r"data/booking_full.xlsx")
amenities_df = pd.read_excel(r"data/apartment_amenities.xlsx")
feetypes_df = pd.read_excel("data/feetypes.xlsx")
print(feetypes_df)
print(bookings_df.head())
print(amenities_df.head())

# print(amenities_df['Amenity'].unique())
# print(f'bookings_df: {bookings_df.columns}')
# print(f'amenities_df: {amenities_df.columns}')
# print(f'feetypes_df: {feetypes_df.columns}')


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

# round(random.uniform(fee_prices[1][0], fee_prices[1][1]), 2)

apartment_amenities = (
    amenities_df.groupby("ApartmentID")["Amenity"].apply(set).to_dict()
)

payment_methods = {9, 10}  # excluded ids for gift card & Corporate invoice


# %%
def generate_fee_payment(
    booking_row: pd.Series, payment_id: int, payment_method_id: int, subtotal: float, 
):
    """Generate dummy data for fee payments with randomized prices based on a previously created dictionary."""

    fees = []

    # default fees for ever booking -> prices randomized based on predefined list
    cleaning = round(random.uniform(fee_prices[1][0], fee_prices[1][1]), 2)
    linen_towels = round(random.uniform(fee_prices[11][0], fee_prices[11][1]), 2)

    fees.append((1, payment_id, cleaning))
    fees.append((11, payment_id, linen_towels))

    # specifying number of additional fees to add, randomizing them & subsetting additional amenities for fees
    num_of_fees = random.choices([0, 1, 2, 3, 4, 5], weights=[0.5, 0.1, 0.1, 0.1, 0.1, 0.1], k=1)[0]
    randomized_fees = random.sample([4, 5, 8, 9, 10], num_of_fees)
    amenity_set = apartment_amenities[booking_row["ApartmentID"]]

    # appending randomized fees with no connection to amenities 
    for fee in randomized_fees:
        fees.append((fee, payment_id, round(random.uniform(fee_prices[fee][0], fee_prices[fee][1]), 2),))

    # appending parking if defined in amenity for this booked apartment
    if "Parking" in amenity_set:
        fees.append((7,payment_id,round(random.uniform(fee_prices[7][0], fee_prices[7][1]), 2)))

    # Resort is only paid if a swimming pool exists
    if "Swimming Pool" in amenity_set:
        fees.append((6,payment_id,round(random.uniform(fee_prices[6][0], fee_prices[6][1]), 2)))

    # pets are only paid for apartments with ped amenities, not only guest has pet therefore only 50% of these bookings
    if amenity_set & {"Dog bed", "Pet Bowls"} and random.random() < 0.5:
        fees.append((2,payment_id,round(random.uniform(fee_prices[2][0], fee_prices[2][1]), 2)))

    # determining if extra guest fee has to be paid, when number of bedrooms + 1 is exceeded
    extra_guests = booking_row["NumberOfGuests"] - (booking_row["NumberOfBedrooms"] + 1)

    if extra_guests > 0:
        extra_guest_price = float(extra_guests * (random.uniform(fee_prices[3][0], fee_prices[3][1]))) 
        fees.append((3, payment_id, round(extra_guest_price, 2)))

    # adding platform fees randomly for protections
    if random.random() < 0.5:
        protection = subtotal * random.uniform(platform_fee_prices[14][0], platform_fee_prices[14][1])
        fees.append((14, payment_id, round(protection, 2)))

    # check switzerland for currency conversion
    if booking_row["Country"] == "CHE":
        conversion = subtotal * random.uniform(platform_fee_prices[12][0], platform_fee_prices[12][1])
        fees.append((12, payment_id, round(conversion, 2)))

    # only adding payment processing methods to every type other than gift cards and corporate invoice
    if payment_method_id not in payment_methods:
        processing = subtotal * random.uniform(platform_fee_prices[13][0], platform_fee_prices[13][1])
        fees.append((13, payment_id, round(processing, 2)))
    
    return fees


generate_fee_payment(bookings_df.iloc[0], 1, 4, 1000)
#%% 
payment_method = random.randint(1, 10)
 
def generate_payment(booking_row: pd.Series, payment_id: int, booking_id: int, payment_method_id: int, ) -> tuple:
    """Generate dummy data of payments for each booking."""
    receipt = str(booking_row[''])

    sub_total = df["price"][row] * df["total_nights"][row]
    service_fee = round(200 * random.random(), 2)
    total_tax = round(random.choice(taxes) * sub_total)
    total_amount = round(sub_total + service_fee + total_tax, 2)

    method = random.randint(1, 11)

    # simplified address id since user id is equivalent to address ID in dummy data
    address = booking_row['UserID']


    return (
        receipt,
        float(sub_total),
        service_fee,
        total_tax,
        float(total_amount),
        booking_id,
        payment_method_id,
        address, 
    )


with open("data/payments.txt", "w") as pay:
    for i in range(len(bookings_df)):
        payment = generate_payment(row=i, df=bookings_df)
        pay.write(f"{payment},\n")


def generate_host_payout(row, df) -> tuple:
    """Generate dummy data for host payouts based for each payment entry."""
    pay_date = str(df["receipt"][row] + timedelta(hours=24))
    commission = round(df["total_amount"][row] * 0.03, 2)
    host_fees = round(100 * random.random(), 2)
    gross = round(df["total_amount"][row] + commission + host_fees, 2)
    net = round(gross - commission, 2)
    share = random.choice([1, round(random.random(), 2)])
    paid_to = random.choice(["Host", "CoHost"]) if share < 1 else "Host"
    payment_id = row + 1
    payee_id = random.randint(1, 20)

    return (
        f"{pay_date}",
        float(gross),
        float(commission),
        float(host_fees),
        float(net),
        float(share),
        paid_to,
        payment_id,
        payee_id,
    )


with open("data/host_payments.txt", "w") as host:
    for i in range(20):
        host.write(f"{generate_host_payout(row=i, df=payments)},\n")

with open("data/fee_payments.txt", "w") as fees:
    for _ in range(50):
        fees.write(f"{generate_fee_payment()},\n")

print("Data successfully generated!")
