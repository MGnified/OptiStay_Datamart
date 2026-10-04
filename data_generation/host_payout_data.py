import numpy as np
import pandas as pd
from datetime import timedelta
from faker import Faker

fake = Faker()

# dataframes
payment_df = pd.read_excel("data/payments.xlsx")
payment_df["Receipt"] = pd.to_datetime(payment_df["Receipt"], format="ISO8601")
bookings_df = pd.read_excel(r"data/booking_full.xlsx")
cohost_df = pd.read_csv("data/cohost_apartment.csv")

# look up dictionaries
cohost_checklist = dict(zip(cohost_df["ApartmentID"], cohost_df["CoHostID"]))
booked_apartments = dict(zip(bookings_df["BookingID"], bookings_df["ApartmentID"]))
apartment_hosts = dict(zip(bookings_df["BookingID"], bookings_df["HostUserID"]))


def generate_host_payout(payment_row: pd.Series, payment_id: int) -> list[tuple]:
    """Generate dummy data for host payouts for each payment entry."""

    # creating list to store all payments
    payouts = []

    # retrieving pay date from booking date + 24 hours
    pay_date = str(payment_row["Receipt"] + timedelta(hours=24))

    # calculating payout values based on payment data
    host_fees = round(
        payment_row["TotalAmount"]
        - payment_row["SubTotalAmount"]
        - payment_row["ServiceFeeGuest"]
        - payment_row["TotalTax"],
        2,
    )
    gross = payment_row["SubTotalAmount"] + host_fees
    commission = payment_row["SubTotalAmount"] * 0.03
    net = round(gross - commission, 2)

    # check if cohosts are involved in the apartment
    apartment = booked_apartments[payment_row["BookingID"]]

    # integrating split for hosts and cohosts
    if apartment in cohost_checklist:
        # host part
        share = 0.7  # choosing 70/30 split for all bookings to simplify data generation
        paid_to = "Host"
        payee_id = apartment_hosts[payment_row["BookingID"]]

        payouts.append(
            (
                pay_date,
                float(round(gross * share, 2)),
                float(round(commission * share, 2)),
                float(round(host_fees * share, 2)),
                float(round(net * share, 2)),
                share,
                paid_to,
                payment_id,
                payee_id,
            )
        )

        # co-host part
        share = 0.3
        paid_to = "CoHost"
        payee_id = cohost_checklist[apartment]
        payouts.append(
            (
                pay_date,
                float(round(gross * share, 2)),
                float(round(commission * share, 2)),
                float(round(host_fees * share, 2)),
                float(round(net * share, 2)),
                share,
                paid_to,
                payment_id,
                payee_id,
            )
        )

    # logic if only host is involved
    else:
        share = 1.0
        paid_to = "Host"
        payee_id = apartment_hosts[payment_row["BookingID"]]
        payouts.append(
            (
                pay_date,
                float(gross),
                float(commission),
                float(host_fees),
                float(net),
                share,
                paid_to,
                payment_id,
                payee_id,
            )
        )

    return payouts


with open("data/host_payments.txt", "w") as payout_txt:
    for idx, row in payment_df.iterrows():
        payouts = generate_host_payout(row, row["PaymentID"])
        for payout in payouts:
            payout_txt.write(f"{payout}, \n")

print("Data successfully generated.")
