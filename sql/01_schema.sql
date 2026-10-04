/* ==================================================
PROJECT: OptiStay Datamart
AUTHOR: Maximilian Gräf
DATABASE CREATION AND TABLE INITIALIZATION
==================================================== */

-- Please note the execution order to ensure frictionless execution
-- 01_table_creation -> 02_alter_table_changes -> 03_dummy_data_inserts -> 
-- 04_trigger_creation -> 05_constraint_tests -> 06_joins_and_analysis 

-- Creation of the core database
DROP DATABASE IF EXISTS OptiStayDatamart;

CREATE DATABASE OptiStayDatamart CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE OptiStayDatamart;

-- Dropping tables if they already exist in reversed order so foreign keys don't block deletion
-- Used to re-run the table section alone without dropping the whole database
DROP TABLE IF EXISTS Wishlists;
DROP TABLE IF EXISTS Recommendations;
DROP TABLE IF EXISTS CoHostAssignments;
DROP TABLE IF EXISTS ApartmentAmenities;
DROP TABLE IF EXISTS CustomerSupport;
DROP TABLE IF EXISTS UserChats;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS FeePayments;
DROP TABLE IF EXISTS HostPayouts;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS PaymentMethods;
DROP TABLE IF EXISTS FeeTypes;
DROP TABLE IF EXISTS BookingTypes;
DROP TABLE IF EXISTS Pictures;
DROP TABLE IF EXISTS Apartments;
DROP TABLE IF EXISTS Amenities;
DROP TABLE IF EXISTS ApartmentNeighbourhoods;
DROP TABLE IF EXISTS ApartmentStyles;
DROP TABLE IF EXISTS Hosts;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Addresses;
DROP TABLE IF EXISTS Admins;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  REFERENCE & ENTITY TABLES (tables that other tables reference to)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Admins and Addresses are created first, since both don't have any Forein keys
CREATE TABLE Admins (
  AdminID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for admin users',
  FirstName VARCHAR(500) NOT NULL COMMENT 'Legal first name',
  LastName VARCHAR(500) NOT NULL COMMENT 'Legal last name',
  Email VARCHAR(254) UNIQUE NOT NULL COMMENT 'Must contain an @ sign',
  Password VARCHAR(32) NOT NULL COMMENT 'Must contain at least 8 and up to 32 characters',
  PRIMARY KEY (AdminID),
  CONSTRAINT Admin_FrstLng CHECK (LENGTH(FirstName) >= 2),
  CONSTRAINT Admin_LstLng CHECK (LENGTH(LastName) >= 2),
  CONSTRAINT Admin_Eml CHECK (Email LIKE '%@%'),
  CONSTRAINT Admin_PwLng CHECK (LENGTH(Password) BETWEEN 8 AND 32)
) ENGINE = InnoDB COMMENT = 'Dimension table storing system administrators';

CREATE TABLE Addresses (
  AddressID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for address data',
  Street VARCHAR(500) NOT NULL COMMENT 'Must contain at least 2 characters',
  HouseNumber VARCHAR(500) NOT NULL COMMENT 'Can contain various characters (e.g., 15b)',
  City VARCHAR(500) NOT NULL COMMENT 'Must contain at least 2 characters',
  PostalCode VARCHAR(10) NOT NULL COMMENT 'Can contain various strings and numbers',
  Country VARCHAR(500) NOT NULL COMMENT 'Must contain at least 2 characters',
  PRIMARY KEY (AddressID),
  CONSTRAINT Address_StrLng CHECK (LENGTH(Street) >= 2),
  CONSTRAINT Address_CitLng CHECK (LENGTH(City) >= 2),
  CONSTRAINT Address_PstlCd CHECK (LENGTH(PostalCode) >= 3),
  CONSTRAINT Address_CouLng CHECK (LENGTH(Country) >= 2)
) ENGINE = InnoDB COMMENT = 'Dimension table storing addresses of users and apartments';

-- creating Users after addresses due to the FK relationship 
CREATE TABLE Users (
  UserID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for users',
  FirstName VARCHAR(500) NOT NULL COMMENT 'Legal first name',
  LastName VARCHAR(500) NOT NULL COMMENT 'Legal last name',
  Email VARCHAR(254) UNIQUE NOT NULL COMMENT 'Must contain an @ sign',
  Password VARCHAR(32) NOT NULL COMMENT 'Must contain at least 8 and up to 32 characters',
  AddressID INTEGER NOT NULL COMMENT 'Foreign key referencing to the Addresses table',
  PRIMARY KEY (UserID),
  FOREIGN KEY (AddressID) REFERENCES Addresses (AddressID) ON DELETE RESTRICT,
  CONSTRAINT User_FrstLng CHECK (LENGTH(FirstName) >= 2),
  CONSTRAINT User_LstLng CHECK (LENGTH(LastName) >= 2),
  CONSTRAINT User_Eml CHECK (Email LIKE '%@%'),
  CONSTRAINT User_PwLng CHECK (LENGTH(Password) BETWEEN 8 AND 32)
) ENGINE = InnoDB COMMENT = 'Dimension table storing user data';

-- linking users to hosts
CREATE TABLE Hosts (
  HostID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for hosts',
  UserID INTEGER NOT NULL COMMENT 'Foreign key referencing to the Users table',
  PRIMARY KEY (HostID),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE RESTRICT
) ENGINE = InnoDB COMMENT = 'Dimension table storing host-users';

-- creating descriptive contextual tables needed for apartments
CREATE TABLE ApartmentStyles (
  StyleID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the apartment style',
  Style VARCHAR(500) UNIQUE NOT NULL COMMENT 'Designation of the style, (e.g., Modern, Scandinavian, ...)',
  PRIMARY KEY (StyleID),
  CONSTRAINT ApartmentStyle_Lng CHECK (LENGTH(Style) >= 3)
) ENGINE = InnoDB COMMENT = 'Dimension table storing apartment styles';

CREATE TABLE ApartmentNeighbourhoods (
  NeighbourhoodID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the apartments neighbourhood',
  Type VARCHAR(500) UNIQUE NOT NULL COMMENT 'Designation of the Neighbourhood (e.g., Urban, Financial, ...)',
  PRIMARY KEY (NeighbourhoodID),
  CONSTRAINT Neighbourhood_Lng CHECK (LENGTH(Type) >= 3)
) ENGINE = InnoDB COMMENT = 'Dimension table storing apartment neighbourhood types';

CREATE TABLE Amenities (
  AmenityID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for amenities',
  Amenity VARCHAR(500) UNIQUE NOT NULL COMMENT 'Name of the Amenity, (e.g., WiFi, Swimming Pool, ...)',
  PRIMARY KEY (AmenityID),
  CONSTRAINT Amenity_Lng CHECK (LENGTH(Amenity) >= 3)
) ENGINE = InnoDB COMMENT = 'Dimension table storing amenities';

-- Creating the Apartments table with foreign keys to the above
CREATE TABLE Apartments (
  ApartmentID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for apartments',
  NumberOfBedrooms INTEGER NOT NULL COMMENT 'Apartments must contain at least 1 bedroom',
  BasePricePerNight DECIMAL(10, 2) NOT NULL COMMENT 'Base rent for the night',
  HostID INTEGER NOT NULL COMMENT 'Foreign key referencing to Hosts',
  AddressID INTEGER NOT NULL COMMENT 'Foreign key referencing to Addresses',
  StyleID INTEGER COMMENT 'Optional foreign key referencing to ApartmentStyles',
  NeighbourhoodID INTEGER COMMENT 'Optional foreign key referencing to ApartmentNeighbourhoods',
  PRIMARY KEY (ApartmentID),
  FOREIGN KEY (HostID) REFERENCES Hosts (HostID) ON DELETE RESTRICT,
  FOREIGN KEY (AddressID) REFERENCES Addresses (AddressID) ON DELETE RESTRICT,
  FOREIGN KEY (StyleID) REFERENCES ApartmentStyles (StyleID) ON DELETE RESTRICT,
  FOREIGN KEY (NeighbourhoodID) REFERENCES ApartmentNeighbourhoods (NeighbourhoodID) ON DELETE RESTRICT,
  CONSTRAINT Apartment_NumBdrm CHECK (NumberOfBedrooms >= 1),
  CONSTRAINT Apartment_BasPrc CHECK (BasePricePerNight > 0)
) ENGINE = InnoDB COMMENT = 'Dimension table storing apartment information';

-- Pictures after apartments -> every picture needs an apartment to reference
CREATE TABLE Pictures (
  PictureID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for images',
  URL VARCHAR(768) UNIQUE NOT NULL COMMENT 'Stores the cloud-url where the picture is stored',
  ApartmentID INTEGER NOT NULL COMMENT 'Foreign key referencing to Apartments',
  PRIMARY KEY (PictureID),
  FOREIGN KEY (ApartmentID) REFERENCES Apartments (ApartmentID) ON DELETE CASCADE,
  CONSTRAINT Picture_Url CHECK (
    URL LIKE 'http://%' OR
    URL LIKE 'https://%'
  )
) ENGINE = InnoDB COMMENT = 'Dimension table storing image url locations';

-- creating descriptive contextual tables needed for bookings
CREATE TABLE BookingTypes (
  BookingTypeID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the type of booking',
  Type VARCHAR(500) UNIQUE NOT NULL COMMENT 'Type of booking (Business Travel, Family Trip, ...)',
  PRIMARY KEY (BookingTypeID),
  CONSTRAINT BookingType_Lng CHECK (LENGTH(Type) >= 3)
) ENGINE = InnoDB COMMENT = 'Dimension table storing booking types';

CREATE TABLE FeeTypes (
  FeeTypeID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the type of fee',
  Type VARCHAR(500) UNIQUE NOT NULL COMMENT 'Type of fee (Cleaning, Pets, ...)',
  Category ENUM('Host', 'Platform') NOT NULL COMMENT 'Distinguishing categories (Platform or Host)',
  PRIMARY KEY (FeeTypeID),
  CONSTRAINT FeeType_Lng CHECK (LENGTH(Type) >= 3)
) ENGINE = InnoDB COMMENT = 'Dimension table storing fee types';

CREATE TABLE PaymentMethods (
  PaymentMethodID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the payment method',
  Method VARCHAR(500) UNIQUE NOT NULL COMMENT 'Payment method (Credit Card, PayPal, ...)',
  PRIMARY KEY (PaymentMethodID),
  CONSTRAINT PaymentMethod_Lng CHECK (LENGTH(Method) >= 2)
) ENGINE = InnoDB COMMENT = 'Dimension table storing payment methods';


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TRANSACTIONAL & EVENT TABLES (tables of records of things happened)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Bookings first since almost every event is based on bookings
CREATE TABLE Bookings (
  BookingID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the booking',
  BookingDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Exact timestamp when the booking was made',
  CheckInDate DATE NOT NULL COMMENT 'Arrival Date',
  CheckOutDate DATE NOT NULL COMMENT 'Departure Date',
  NumberOfGuests INTEGER NOT NULL COMMENT 'Amount of arriving guests',
  PricePerNight DECIMAL(10, 2) NOT NULL COMMENT 'Derived from Apartments.BasePricePerNight',
  TotalNights INTEGER NOT NULL COMMENT 'Total nights of staying',
  BookingTypeID INTEGER COMMENT 'Optional foreign key referencing to BookingTypes',
  UserID INTEGER NOT NULL COMMENT 'Foreign key referencing to Users',
  ApartmentID INTEGER NOT NULL COMMENT 'Foreign key referencing to Apartments',
  PRIMARY KEY (BookingID),
  FOREIGN KEY (BookingTypeID) REFERENCES BookingTypes (BookingTypeID) ON DELETE RESTRICT,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE RESTRICT,
  FOREIGN KEY (ApartmentID) REFERENCES Apartments (ApartmentID) ON DELETE RESTRICT,
  CONSTRAINT Booking_DateChckIn CHECK (BookingDate <= CheckInDate),
  CONSTRAINT Booking_ChkInBefChckOut CHECK (CheckOutDate > CheckInDate),
  CONSTRAINT Booking_NrGuests CHECK (NumberOfGuests >= 1),
  CONSTRAINT Booking_PrcPerNght CHECK (PricePerNight > 0),
  CONSTRAINT Booking_TtlNghts CHECK (TotalNights >= 1)
) ENGINE = InnoDB COMMENT = 'Fact table storing booking information';

-- Payment related event tables
CREATE TABLE Payments (
  PaymentID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the payment',
  Receipt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Exact timestamp of the payment',
  SubTotalAmount DECIMAL(10, 2) NOT NULL COMMENT 'Base Price of the booking',
  ServiceFeeGuest DECIMAL(10, 2) NOT NULL DEFAULT 0 COMMENT 'Total amount of all Platform category fees',
  TotalTax DECIMAL(10, 2) NOT NULL COMMENT 'Total Tax of the SubTotalAmount',
  TotalAmount DECIMAL(10, 2) NOT NULL COMMENT 'Total Amount to be paid',
  BookingID INTEGER NOT NULL COMMENT 'Foreign key referencing to Bookings',
  PaymentMethodID INTEGER NOT NULL COMMENT 'Foreign key referencing to PaymentMethods',
  InvoiceAddressID INTEGER NOT NULL COMMENT 'Foreign key referencing to Addresses',
  PRIMARY KEY (PaymentID),
  FOREIGN KEY (BookingID) REFERENCES Bookings (BookingID) ON DELETE RESTRICT,
  FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods (PaymentMethodID) ON DELETE RESTRICT,
  FOREIGN KEY (InvoiceAddressID) REFERENCES Addresses (AddressID) ON DELETE RESTRICT,
  CONSTRAINT Payment_SubTtlChck CHECK (SubTotalAmount > 0),
  CONSTRAINT Payment_TtlAmnt CHECK (TotalAmount > 0),
  CONSTRAINT Payment_SrvcFee CHECK (ServiceFeeGuest >= 0),
  CONSTRAINT Payment_TtlTax CHECK (
    TotalTax > 0 AND
    TotalTax < SubTotalAmount
  )
) ENGINE = InnoDB COMMENT = 'Fact table storing payment information';

CREATE TABLE HostPayouts (
  HostPayoutID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the HostPayouts',
  PaymentDate TIMESTAMP NOT NULL COMMENT 'Date when the host is paid -> 24 hours after guests paid',
  GrossAmount DECIMAL(10, 2) NOT NULL COMMENT 'Total Amount to be paid incl. Host type fees',
  PlatformCommission DECIMAL(10, 2) NOT NULL COMMENT '3% commission for the platform',
  HostFees DECIMAL(10, 2) NOT NULL DEFAULT 0 COMMENT 'Sum of all Host category feetypes',
  NetAmount DECIMAL(10, 2) NOT NULL COMMENT 'Final amount the host gets paid',
  HostShare DECIMAL(4, 3) NOT NULL COMMENT '70/30 split if the apartment has a Co-Host',
  PaidTo ENUM('Host', 'CoHost') NOT NULL COMMENT 'Distinguishes between payout to Host or Co-Host',
  PaymentID INTEGER NOT NULL COMMENT 'Foreign key referencing to Payments',
  PayeeID INTEGER NOT NULL COMMENT 'Foreign key referencing to Users',
  PRIMARY KEY (HostPayoutID),
  FOREIGN KEY (PaymentID) REFERENCES Payments (PaymentID) ON DELETE RESTRICT,
  FOREIGN KEY (PayeeID) REFERENCES Users (UserID) ON DELETE RESTRICT,
  CONSTRAINT HostPayout_GrssAmnt CHECK (GrossAmount > 0),
  CONSTRAINT HostPayout_PltfrmComm CHECK (
    PlatformCommission > 0 AND
    PlatformCommission < GrossAmount
  ),
  CONSTRAINT HostPayout_HstFee CHECK (HostFees >= 0),
  CONSTRAINT HostPayout_NtAmnt CHECK (NetAmount > 0),
  CONSTRAINT HostPayout_HstShr CHECK (HostShare > 0)
) ENGINE = InnoDB COMMENT = 'Fact table storing payouts to the host';

CREATE TABLE FeePayments (
  FeeTypeID INTEGER NOT NULL COMMENT 'Compound primary key referencing to FeeTypes',
  PaymentID INTEGER NOT NULL COMMENT 'Compound primary key referencing to Payments',
  Price DECIMAL(10, 2) NOT NULL COMMENT 'Price of the specific fee',
  PRIMARY KEY (FeeTypeID, PaymentID),
  FOREIGN KEY (FeeTypeID) REFERENCES FeeTypes (FeeTypeID) ON DELETE RESTRICT,
  FOREIGN KEY (PaymentID) REFERENCES Payments (PaymentID) ON DELETE CASCADE,
  CONSTRAINT FeePayment_Prc CHECK (Price > 0)
) ENGINE = InnoDB COMMENT = 'Fact table storing fee payment information';

-- Reviews and Communication tables
CREATE TABLE Reviews (
  ReviewID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the reviews',
  Rating TINYINT NOT NULL COMMENT 'Stars restricted to 0-5',
  Comment VARCHAR(1500) COMMENT 'Optional comments to the review',
  RatingType ENUM('Host', 'Guest') NOT NULL COMMENT 'Distinguishes between Guest and Host rating',
  ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the review is submitted',
  UserID INTEGER NOT NULL COMMENT 'Foreign key referencing to users',
  BookingID INTEGER NOT NULL COMMENT 'Foreign key referencing to bookings',
  PRIMARY KEY (ReviewID),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE,
  FOREIGN KEY (BookingID) REFERENCES Bookings (BookingID) ON DELETE CASCADE,
  CONSTRAINT Review_Rtg CHECK (Rating BETWEEN 0 AND 5),
  CONSTRAINT Review_Cmnt CHECK (LENGTH(Comment) > 1)
) ENGINE = InnoDB COMMENT = 'Fact table storing reviews';

CREATE TABLE UserChats (
  ChatID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the chat',
  MessageText VARCHAR(1500) NOT NULL COMMENT 'Message related to the chat',
  SentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the message was sent',
  SenderID INTEGER NOT NULL COMMENT 'Foreign key referencing to Users sending the message',
  ReceiverID INTEGER NOT NULL COMMENT 'Foreign key referencing to Users receiving the message',
  BookingID INTEGER COMMENT 'Optional foreign key referencing to Bookings',
  PRIMARY KEY (ChatID),
  FOREIGN KEY (SenderID) REFERENCES Users (UserID) ON DELETE CASCADE,
  FOREIGN KEY (ReceiverID) REFERENCES Users (UserID) ON DELETE CASCADE,
  FOREIGN KEY (BookingID) REFERENCES Bookings (BookingID) ON DELETE CASCADE,
  CONSTRAINT UserChat_MsgTxt CHECK (LENGTH(MessageText) > 1),
  CONSTRAINT UserChat_RcvrNotSndr CHECK (SenderID != ReceiverID) 
) ENGINE = InnoDB COMMENT = 'Fact table storing chat messages';

CREATE TABLE CustomerSupport (
  TicketID INTEGER AUTO_INCREMENT COMMENT 'Surrogate primary key for the support ticket',
  MessageText VARCHAR(1500) NOT NULL COMMENT 'Message related to the support ticket',
  SentAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the message was sent',
  AssigneeID INTEGER NOT NULL COMMENT 'Foreign key referencing to Admins',
  OpenerID INTEGER NOT NULL COMMENT 'Foreign key referencing to Users',
  BookingID INTEGER COMMENT 'Optional foreign key referencing to Bookings',
  PRIMARY KEY (TicketID),
  FOREIGN KEY (AssigneeID) REFERENCES Admins (AdminID) ON DELETE RESTRICT,
  FOREIGN KEY (OpenerID) REFERENCES Users (UserID) ON DELETE CASCADE,
  FOREIGN KEY (BookingID) REFERENCES Bookings (BookingID) ON DELETE CASCADE,
  CONSTRAINT CustomerSupport_MsgTxt CHECK (LENGTH(MessageText) > 1)
) ENGINE = InnoDB COMMENT = 'Fact table storing customer support tickets';


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  JUNCTION TABLES (resolving many to many relationships)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- assignment tables
CREATE TABLE ApartmentAmenities (
  ApartmentID INTEGER NOT NULL COMMENT 'Compound primary key referencing to Apartments',
  AmenityID INTEGER NOT NULL COMMENT 'Compound primary key referencing to Amenities',
  PRIMARY KEY (ApartmentID, AmenityID),
  FOREIGN KEY (ApartmentID) REFERENCES Apartments (ApartmentID) ON DELETE CASCADE,
  FOREIGN KEY (AmenityID) REFERENCES Amenities (AmenityID) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT = 'Junction table connecting apartments and amenities';

CREATE TABLE CoHostAssignments (
  CoHostID INTEGER NOT NULL COMMENT 'Compound primary key referencing to Users',
  ApartmentID INTEGER NOT NULL COMMENT 'Compound primary key referencing to Apartments',
  AssignmentDate DATE NOT NULL DEFAULT(CURRENT_DATE) COMMENT 'Timestamp when the CoHost was assigned to the apartment',
  PRIMARY KEY (CoHostID, ApartmentID),
  FOREIGN KEY (CoHostID) REFERENCES Users (UserID) ON DELETE CASCADE,
  FOREIGN KEY (ApartmentID) REFERENCES Apartments (ApartmentID) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT = 'Junction table linking cohosts to apartments';

-- User Interactions
CREATE TABLE Recommendations (
  RecommendedBy INTEGER NOT NULL COMMENT 'Compound primary key referencing to Users recommending the apartment',
  RecommendedTo INTEGER NOT NULL COMMENT 'Compound primary key referencing to Users getting the apartment recommended',
  ApartmentID INTEGER NOT NULL COMMENT 'Compound primary key referencing to Apartments',
  PRIMARY KEY (RecommendedTo, RecommendedBy, ApartmentID),
  FOREIGN KEY (RecommendedBy) REFERENCES Users (UserID) ON DELETE CASCADE,
  FOREIGN KEY (RecommendedTo) REFERENCES Users (UserID) ON DELETE CASCADE,
  FOREIGN KEY (ApartmentID) REFERENCES Apartments (ApartmentID) ON DELETE CASCADE,
  CONSTRAINT Recommendation_NotSelf CHECK (RecommendedTo != RecommendedBy)
) ENGINE = InnoDB COMMENT = 'Junction table storing review information';

CREATE TABLE Wishlists (
  ApartmentID INTEGER NOT NULL COMMENT 'Compound primary key referencing to Apartments',
  UserID INTEGER NOT NULL COMMENT 'Compound primary key referencing to Users',
  AddingDate DATE NOT NULL DEFAULT(CURRENT_DATE) COMMENT 'Date when the apartment was added to the wishlist',
  PRIMARY KEY (ApartmentID, UserID),
  FOREIGN KEY (ApartmentID) REFERENCES Apartments (ApartmentID) ON DELETE CASCADE,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT = 'Junction table storing wishlist items';