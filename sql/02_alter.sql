/* ==================================================
PROJECT: OptiStay Datamart
AUTHOR: Maximilian Gräf
ALTER TABLE STATEMENTS 
==================================================== */

-- Please note the execution order to ensure frictionless execution
-- 01_table_creation -> 02_alter_table_changes -> 03_dummy_data_inserts -> 
-- 04_trigger_creation -> 05_constraint_tests -> 06_joins_and_analysis

USE OptiStayDatamart;

-- Admin names are reduced to VARCHAR(100) to include longer names from various cultures
ALTER TABLE Admins
  MODIFY COLUMN FirstName VARCHAR(100) NOT NULL COMMENT 'Legal first name',
  MODIFY COLUMN LastName VARCHAR(100) NOT NULL COMMENT 'Legal last name';

-- reducing character length of Street, City and HouseNumber and change Country to ISO-Alpha3 format after receiving feedback
ALTER TABLE Addresses
  MODIFY COLUMN Street VARCHAR(255) NOT NULL COMMENT 'The name of the Street must contain at least 2 characters',
  MODIFY COLUMN City VARCHAR(100) NOT NULL COMMENT 'The name of the City must contain at least 2 characters',
  MODIFY COLUMN HouseNumber VARCHAR(10) NOT NULL COMMENT 'Can contain various characters (e.g., 15b)', 
  MODIFY COLUMN Country CHAR(3) NOT NULL COMMENT 'ISO Alpha-3 format with exactly 3 characters';

-- dropping the previous country length constraint since CHAR(3) enforces exactly 3 characters
ALTER TABLE Addresses
  DROP CONSTRAINT Address_CouLng;

-- adding constraint so addresses are unique
ALTER TABLE Addresses
  ADD CONSTRAINT Address_UnqAddrs UNIQUE(Street, City, HouseNumber, Country);

-- adding the phone number as contacting method for better communication issues
ALTER TABLE Users
  ADD COLUMN PhoneNumber VARCHAR(30) UNIQUE 
  COMMENT 'Optional phone number in international phone format' 
  AFTER Email;

-- User names reduced after receiving feeback
ALTER TABLE Users
  MODIFY COLUMN FirstName VARCHAR(100) NOT NULL COMMENT 'Legal first name',
  MODIFY COLUMN LastName VARCHAR(100) NOT NULL COMMENT 'Legal last name';

-- adding unique ID to user id for hosts to prevent multiple entries
ALTER TABLE Hosts 
  ADD CONSTRAINT Host_UnqUsrID UNIQUE(UserID);

-- reducing the VARCHAR limits for all apartment relevant descriptive tables
ALTER TABLE ApartmentStyles
  MODIFY COLUMN Style VARCHAR(50) NOT NULL COMMENT 'Designation of the style, (e.g., Modern, Scandinavian, ...)'; 

ALTER TABLE ApartmentNeighbourhoods
  MODIFY COLUMN Type VARCHAR(50) NOT NULL COMMENT 'Designation of the Neighbourhood (e.g., Urban, Financial, ...)';

ALTER TABLE Amenities
  MODIFY COLUMN Amenity VARCHAR(50) NOT NULL COMMENT 'Name of the Amenitiy, (e.g., WiFi, Swimming Pool, ...)';

-- adding upper bound to number of bedrooms to ensure realistic numbers
ALTER TABLE Apartments 
  DROP CONSTRAINT Apartment_NumBdrm,
  ADD CONSTRAINT Apartment_NumBdrm CHECK (NumberOfBedrooms BETWEEN 1 AND 10); 

-- reducing the VARCHAR limits for all booking relevant descriptive tables
ALTER TABLE BookingTypes
  MODIFY COLUMN Type VARCHAR(50) NOT NULL COMMENT 'Type of booking (Business Travel, Family Trip, ...)';

ALTER TABLE FeeTypes
  MODIFY COLUMN Type VARCHAR(50) NOT NULL COMMENT 'Type of fee (Cleaning, Pets, ...)';

ALTER TABLE PaymentMethods
  MODIFY COLUMN Method VARCHAR(50) UNIQUE NOT NULL COMMENT 'Payment method (Credit Card, PayPal, ...)';

-- add constraint to ensure Payments and HostPayouts are unique 
ALTER TABLE Payments 
  ADD CONSTRAINT Payment_UnqPmntPerBkng UNIQUE(BookingID);

ALTER TABLE HostPayouts 
  ADD CONSTRAINT HosPayout_UnqPayoutPrBkng UNIQUE(PaymentID, PaidTo);

-- adding constraint for Reviews to only implement bookingID and rating type once per booking
ALTER TABLE Reviews 
  ADD CONSTRAINT Reviews_UnqBkngType UNIQUE(BookingID, RatingType);

-- adding unique constraint to ensure only one cohost per apartment (70/30  split)
ALTER TABLE CoHostAssignments
  ADD CONSTRAINT CoHostAssignments_OneChstPrAprtmnt UNIQUE(ApartmentID);
  



