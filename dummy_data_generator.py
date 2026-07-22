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

# dictionary to map ISO Alpha-2 to ISO  Alpha-3
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

def generate_dummy_data(locale: str) -> tuple:
    """
    Generate dummy data (name, email, address) ensuring all data is in the same locale

    Args:
        locale (str): definition of the locale for the Faker in

    Returns
        tuple: tuple of name, email, address, country
    """
    fake = Faker(locale)
    first_name = fake.first_name()
    last_name = fake.last_name()

    email_first = unidecode(first_name.lower()).replace(" ", "")
    email_last = unidecode(last_name.lower()).replace(" ", "")

    email = f"{email_first}.{email_last}@{fake.free_email_domain()}"

    address = fake.address().replace("\n", ", ")
    country = countries[fake.current_country_code()]

    return first_name, last_name, email, address, country


# defining people data
people_data = []
headers = ["first_name", "last_name", "email", "address", "country"]
for _ in range(20):
    locale = random.choice(locales)
    people_data.append(generate_dummy_data(locale))

# generate extra addresses for data variety
extra_addresses = []
for _ in range(10):
    fake = Faker(random.choice(locales))
    address = fake.address().replace("\n", ", ")
    country = countries[fake.current_country_code()]
    extra_addresses.append((address, country))

# creating DataFrames to store results as .csv file
people_df = pd.DataFrame(people_data, columns=headers)
address_df = pd.DataFrame(extra_addresses, columns=["address", 'country'])

people_df.to_csv("people.csv", index=False)
address_df.to_csv("address.csv", index=False)
