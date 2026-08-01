import random

from faker import Faker
from unidecode import unidecode

Faker.seed(3)

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


def generate_user_data(locale: str, address_only: bool = False) -> tuple:
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

    if address_only:
        return street, building_number, city, postal_code, country

    return (
        [first_name, last_name, email, phone],
        [street, building_number, city, postal_code, country],
    )


# generating people/user data
people_data = []
address_data = []

for idx in range(1, 21):
    locale = random.choice(locales)
    data = generate_user_data(locale)

    person = list(data[0])
    person.append(idx)
    people_data.append(person)
    address_data.append(data[1])

address_sql_vals = [tuple(i) for i in address_data]
people_sql_vals = [tuple(i) for i in people_data]

# generate extra addresses for data variety

extra_addresses = []

for _ in range(10):
    address_locales = ["de_DE", "de_AT", "fr_FR"]
    locale = random.choice(address_locales)
    address = generate_user_data(locale, True)
    extra_addresses.append(address)

extra_address_vals = [tuple(i) for i in extra_addresses]


with open("data/personal_data.txt", "w") as data:
    for address in address_sql_vals:
        data.write(f"{address}\n")
    data.write(f"{'-' * 60}\n")
    for people in people_sql_vals:
        data.write(f"{people}\n")
    data.write(f"{'-' * 60}\n")
    for extra in extra_address_vals:
        data.write(f"{extra}\n")
