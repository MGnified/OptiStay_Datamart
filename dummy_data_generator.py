import random

import pandas as pd
from faker import Faker
from unidecode import unidecode

# setting seed for reproducibility
Faker.seed(27)

# defining locales to ensure names and addresses fit logically
locales = [
    "de_DE",
    "de_AT",
    "de_CH",
    "it_IT",
    "fr_FR",
    "en_GB",
    "da_DK",
    "es_ES",
    "nl_NL",
    "sv_SE",
    "no_NO",
]

# dictionary to map ISO Alpha-2 to ISO Alpha-3
countries = {
    "DE": "DEU",
    "AT": "AUT",
    "CH": "CHE",
    "FR": "FRA",
    "GB": "GBR",
    "IT": "ITA",
    "DK": "DNK",
    "ES": "ESP",
    "NL": "NLD",
    "SE": "SWE",
    "NO": "NOR",
}

# dictionary for country dial codes
dial_codes = {
    "DE": "+49",
    "AT": "+43",
    "CH": "+41",
    "FR": "+33",
    "GB": "+44",
    "IT": "+39",
    "DK": "+45",
    "ES": "+34",
    "NL": "+31",
    "SE": "+46",
    "NO": "+47",
}



def generate_dummy_data(locale: str) -> tuple:
    """
    Generate dummy data (name, email, address) ensuring all data is in the same locale

    Args:
        locale (str): definition of the locale for the Faker in

    Returns
        tuple: tuple of name, email, street, building_number, postal_code, city, country
    """
    fake = Faker(locale)

    # creating name details
    first_name = fake.first_name()
    last_name = fake.last_name()

    # creating contact details
    email_first = unidecode(first_name.lower()).replace(" ", "")
    email_last = unidecode(last_name.lower()).replace(" ", "")
    email = f"{email_first}.{email_last}@{fake.free_email_domain()}"
    phone = f'{dial_codes[fake.current_country_code()]} {fake.numerify('%########')}'

    # creating address details
    street = fake.street_name()
    building_number = fake.building_number()
    postal_code = fake.postcode()
    city = fake.city()
    country = countries[fake.current_country_code()]

    return (
        first_name,
        last_name,
        email,
        phone,
        street,
        building_number,
        city,
        postal_code,
        country,
    )


# generating people/user data
people_data = []
headers = [
    "first_name",
    "last_name",
    "email",
    "phone",
    "street",
    "building_number",
    "city",
    "postal_code",
    "country",
]
for _ in range(20):
    locale = random.choice(locales)
    people_data.append(generate_dummy_data(locale))

# generate extra addresses for data variety
extra_addresses = []
for _ in range(10):
    fake = Faker(random.choice(locales))

    street = fake.street_name()
    building_number = fake.building_number()
    postal_code = fake.postcode()
    city = fake.city()
    country = countries[fake.current_country_code()]

    extra_addresses.append((street, building_number, postal_code, city, country))

# creating DataFrames to store results as .csv file
people_df = pd.DataFrame(people_data, columns=headers)
address_df = pd.DataFrame(
    extra_addresses,
    columns=["street", "building_number", "postal_code", "city", "country"],
)

people_df.to_csv("people.csv", index=False)
address_df.to_csv("address.csv", index=False)
