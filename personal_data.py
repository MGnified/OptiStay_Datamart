import random

from faker import Faker
from unidecode import unidecode

# setting seed for reproducibility
Faker.seed(27)

# defining locales to ensure names and addresses fit logically
locales = [
    "de_DE",
    "de_AT",
    "de_CH",
    "fr_FR",
    "nl_NL",
]

# dictionary to map ISO Alpha-2 to ISO Alpha-3
countries = {
    "DE": "DEU",
    "AT": "AUT",
    "CH": "CHE",
    "FR": "FRA",
    "NL": "NLD",
}

# dictionary for country dial codes
dial_codes = {
    "DE": "+49",
    "AT": "+43",
    "CH": "+41",
    "FR": "+33",
    "NL": "+31",
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
    phone = f"{dial_codes[fake.current_country_code()]} {fake.numerify('########')}"

    # creating address details
    street = fake.street_name()
    building_number = fake.building_number()
    postal_code = fake.postcode()
    city = fake.city()
    country = countries[fake.current_country_code()]

    return (
        [first_name, last_name, email, phone],
        [street, building_number, city, postal_code, country],
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


address_data = []
for _ in range(20):
    locale = random.choice(locales)
    data = generate_dummy_data(locale)
    people_data.append(data[0])
    address_data.append(data[1])

# print(people_data)
# print(address_data)

address_sql_vals = [tuple(i) for i in address_data]
print(address_sql_vals)
print(f"\n {'=' * 50} \n")
people_sql_vals = [tuple(i) for i in people_data]
print(people_sql_vals)
print(f"\n {'=' * 50} \n")
# generate extra addresses for data variety

extra_addresses = []
for _ in range(10):
    fake = Faker(random.choice(locales))
    locales = ["de_DE", "de_AT", "fr_FR"]
    street = fake.street_name()
    building_number = fake.building_number()
    postal_code = fake.postcode()
    city = fake.city()
    country = countries[fake.current_country_code()]

    extra_addresses.append((street, building_number, postal_code, city, country))

extra_address_vals = [tuple(i) for i in extra_addresses]
print(extra_addresses)

with open("values.txt", "w") as values:
    values.write(str(address_sql_vals))
