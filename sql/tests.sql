/* ==================================================
PROJECT: OptiStay Datamart
AUTHOR: Maximilian Gräf
CHECKING ERROR CONSTRAINTS
==================================================== */

-- Please note the execution order to ensure frictionless execution
-- 01_table_creation -> 02_alter_table_changes -> 03_dummy_data_inserts -> 
-- 04_trigger_creation -> 05_constraint_tests -> 06_joins_and_analysis

USE OptiStayDatamart;

/* +++++++++++++++++++++++++++++++++++++++++++++++++
  LENGTH CHECK CONSTRAINTS
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- creating an address with a Postal Code less than 3 characters -> violating Address_PstlCd
INSERT INTO Addresses (Street, HouseNumber, City, PostalCode, Country) VALUES
  ('Woldemar-Budig-Allee', '9-7', 'Eggenfelden', '17', 'DEU');

-- inserting apartment neighbourhood with less than 3 characters -> violating Neighbourhood_Lng
INSERT INTO ApartmentNeighbourhoods (Type) VALUES ('XX');

-- inserting payment method with less than 2 characters -> violating PaymentMethod_Lng
INSERT INTO PaymentMethods (Method) VALUES ('X');


/* +++++++++++++++++++++++++++++++++++++++++++++++++
  UNIQUE CHECK CONSTRAINTS 
  (Only Hosts has a constraint name, since it was defined later on in ALTER TABLE)
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- inserting duplicate UserID into Hosts -> violating constraint from ALTER TABLE Host_UnqUsrID
INSERT INTO Hosts (UserID) VALUES (3);

-- inserting user with same email as another user, same name is chosen to be confirm with email structure
INSERT INTO Users (FirstName, LastName, Email, PhoneNumber, Password, AddressID) VALUES
  ('Noël', 'Allain', 'noel.allain@laposte.net', '+49 31593461', 'MyPassword123', 30);

-- inserting duplicate in apartment styles
INSERT INTO ApartmentStyles (Style) VALUES ('Modern');

-- inserting duplicate in booking types
INSERT INTO BookingTypes (Type) VALUES ('Business Travel');


/* +++++++++++++++++++++++++++++++++++++++++++++++++
  NUMERIC CHECK CONSTRAINTS
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- inserting apartment with baseprice <= 0 -> violating Apartment_BasPrc
INSERT INTO Apartments (NumberOfBedrooms, BasePricePerNight, HostID, AddressID, StyleID, NeighbourhoodID) VALUES
  (1, -50.00, 4, 30, 1, 10);

-- inserting booking with Check-in after Check-out -> violating Booking_ChkInBefChckOut
INSERT INTO Bookings (BookingDate, CheckInDate, CheckOutDate, NumberOfGuests, PricePerNight, TotalNights, BookingTypeID, UserID, ApartmentID) VALUES
  ('2026-08-11 21:47:42', '2026-10-10', '2026-10-01', 1, 85.0, 10, 9, 17, 2);

-- inserting review with rating out of range 0-5 -> violating Review_Rtg
INSERT INTO Reviews(Rating, Comment, RatingType, ReviewDate, UserID, BookingID) VALUES
  (6, NULL, 'Guest', '2026-05-23 22:11:48', 10, 1);

-- inserting payment with Total Tax > SubTotal -> violating Payment_TtlTax
INSERT INTO Payments(Receipt, SubTotalAmount, ServiceFeeGuest, TotalTax, TotalAmount, BookingID, PaymentMethodID, InvoiceAddressID) VALUES
  ('2026-05-23 13:32:11', 975.0, 27.54, 1097.5, 2100.04, 16, 8, 1);

-- inserting host payout with commission > gross -> violating HostPayout_PltfrmComm
INSERT INTO HostPayouts(PaymentDate, GrossAmount, PlatformCommission, HostFees, NetAmount, HostShare, PaidTo, PaymentID, PayeeID) VALUES
  ('2026-05-23 13:32:11', 1371.96, 2037.8, 111.96, 1334.16, 1.0, 'Host', 1, 15);

-- inserting feepayment with price not greater than 0 -> violating FeePayment_Prc
INSERT INTO FeePayments(FeeTypeID, PaymentID, Price) VALUES
  (2, 14, -10.00);


/* +++++++++++++++++++++++++++++++++++++++++++++++++
  FORMAT CHECK CONSTRAINTS
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- inserting admin without @ in email -> violating Admin_Eml
INSERT INTO Admins (FirstName, LastName, Email, Password) VALUES
  ('Erika', 'Ortmann', 'e.ortmannoptistay.com', 'IamAdmin2026!');

-- inserting picture without https -> violating Picture_Url
INSERT INTO Pictures (URL, ApartmentID) VALUES 
  ('cdn.optistay.com/img/apt01_bath.jpg', 1); 


/* +++++++++++++++++++++++++++++++++++++++++++++++++
  SELF REFERENCE CONSTRAINTS
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- inserting message with SenderID = ReceiverID -> violating UserChat_RcvrNotSndr
INSERT INTO UserChats(MessageText, SentAt, SenderID, ReceiverID, BookingID) VALUES
  ('Wonder understand.', '2026-06-12 21:40:42', 3, 3, NULL);

-- inserting self recommendation -> violating Recommendation_NotSelf
INSERT INTO Recommendations (RecommendedBy, RecommendedTo, ApartmentID) VALUES
  (18, 18, 14);


/* +++++++++++++++++++++++++++++++++++++++++++++++++
  COMPOSITE PRIMARY KEY
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- inserting duplicate apartmentamenities pair -> violating Primary Key
INSERT INTO ApartmentAmenities (ApartmentID, AmenityID) VALUES
  (1, 1);


/* +++++++++++++++++++++++++++++++++++++++++++++++++
  FOREIGN KEY VIOLATION
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- insert customer support message for non existing admin
INSERT INTO CustomerSupport(MessageText, SentAt, AssigneeID, OpenerID, BookingID) VALUES
  ('Skin strong oil.', '2026-05-27 20:04:37', 10, 8, 17);

-- inserting non existing user in cohosts assignment
INSERT INTO CoHostAssignments (CoHostID, ApartmentID, AssignmentDate) VALUES
  (25, 16, '2026-07-15');


/* +++++++++++++++++++++++++++++++++++++++++++++++++
  NOT NULL AND ENUM CONSTRAINTS
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- inserting NULL amenity 
INSERT INTO Amenities (Amenity) VALUES (NULL);

-- inserting wishlist entry with AddingDate NULL
INSERT INTO Wishlists (ApartmentID, UserID, AddingDate) VALUES
  (8, 5, NULL);

-- inserting Feetype with category not in ENUM
INSERT INTO FeeTypes (Type, Category) VALUES
  ('Smoking Penalty', 'Penalty');

-- =========================================================================
-- TRIGGER TESTS
-- =========================================================================

/* +++++++++++++++++++++++++++++++++++++++++++++++++
 TRIGGER TEST HOSTPAYOUTS 
+++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Confirm all triggers are registered in the database
SHOW TRIGGERS;

-- Test Booking on Apartment 13, having co host and host -> two payout rows are expected
INSERT INTO Bookings (BookingDate, CheckInDate, CheckOutDate, NumberOfGuests, PricePerNight, TotalNights, BookingTypeID, UserID, ApartmentID) VALUES
  ('2026-05-13 20:55:39', '2026-08-04', '2026-08-09', 2, 180.0, 5, 5, 18, 13);

-- Retrieve the generated BookingID
SELECT MAX(BookingID) FROM Bookings; 

-- Creating Payment for the booking. TotalAmount is inserted without the host fees -> fee rows can only be added once the payment exists
INSERT INTO Payments (Receipt, SubTotalAmount, ServiceFeeGuest, TotalTax, TotalAmount, BookingID, PaymentMethodID, InvoiceAddressID) VALUES
  ('2026-05-13 20:55:39', 900.00,  7.00, 63.00, 970.00, 21, 1, 18);

-- Retrive the generated PaymentID
SELECT MAX(PaymentID) FROM Payments;

-- Inserting fees for this payment: 3 host and 1 platform 
INSERT INTO FeePayments (FeeTypeID, PaymentID, Price) VALUES
  (1, 21, 10.00), -- Cleaning
  (5, 21, 25.00), -- Early Check In
  (11, 21, 5.00), -- Linen & Towels
  (13, 21, 7.00); -- PaymentProcessing -> Platform

-- sum of the host-category fees only, i.e. the amount the trigger willa dd -> expected 47.00
SELECT SUM(Price) FROM FeePayments
  JOIN FeeTypes ON FeePayments.FeeTypeID = FeeTypes.FeeTypeID
  WHERE FeePayments.PaymentID = 21 AND FeeTypes.Category = 'Host';  

-- Updating the payment row, the changed total amount should fire the trigger
UPDATE Payments 
  SET TotalAmount = 1010.00 -- total amount of 970 + calculated 40
  WHERE PaymentID = 21;

-- Two payout rows, split 70/30, dates 24 hours after receipt
SELECT * FROM HostPayouts WHERE PaymentID = 21;


/* +++++++++++++++++++++++++++++++++++++++++++++++++
   TRIGGER TEST SIGNAL TRIGGERS
+++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Apartment 1 belongs to Host 1 -> UserID 3, so the same pair is used for the first three tests
-- Host as co-host of their own apartment 
INSERT INTO CoHostAssignments (CoHostID, ApartmentID, AssignmentDate) VALUES 
  (3, 1, DEFAULT);

-- Host wishlisting their own apartment
INSERT INTO Wishlists (ApartmentID, UserID, AddingDate) VALUES
  (1, 3, DEFAULT);

-- Apartment recommended to its own host
INSERT INTO Recommendations (RecommendedBy, RecommendedTo, ApartmentID) VALUES 
  (10, 3, 1);

-- Review dated before the checkout of booking 23 
INSERT INTO Reviews (Rating, Comment, RatingType, ReviewDate, UserID, BookingID) VALUES
  (4, NULL, 'Guest', '2026-08-05 13:44:21', 18, 21);

-- Check if a correctly inserted review works
INSERT INTO Reviews (Rating, Comment, RatingType, ReviewDate, UserID, BookingID) VALUES
  (4, NULL, 'Guest', '2026-08-09 11:52:01', 18, 21);

-- Check if it is inserted
SELECT * FROM Reviews WHERE BookingiD = 21;

-- Apartment 1 has 4 pictures (IDs 1-4), three are deleted so exactly one remains
DELETE FROM Pictures WHERE PictureID IN (1,2,3);

-- Deleting the last remaining picture
DELETE FROM Pictures WHERE PictureID = 4;

-- =========================================================================
-- DELETE CONSTRAINT TESTS
-- =========================================================================

-- RESTRICT: the previosly created booking 21 is referenced by a payment (ID 21) -> delete is rejected 
DELETE FROM Bookings WHERE BookingID = 21;

-- Selecting an apartment that is wishlisted but has no bookings -> not blocked by RESTRICT
SELECT w.ApartmentID, COUNT(*)
  FROM Wishlists w
  LEFT JOIN Bookings b on w.ApartmentID = b.ApartmentID
  WHERE b.BookingID IS NULL
  GROUP BY w.ApartmentID;

-- Apartment 14 is wishlisted but has no by two users and has pictures
-- Counting both children tables 
SELECT COUNT(*) AS WishlistEntries_Before FROM Wishlists WHERE ApartmentID = 14;
SELECT COUNT(*) AS NumPictures_Before FROM Pictures WHERE ApartmentID = 14;

-- CASCADE: remove the apartment and delete wishlists and picture entries with it
DELETE FROM Apartments WHERE ApartmentID = 14;

-- both child tables are now empy for apartment 14
SELECT COUNT(*) AS WishlistEntries_After FROM Wishlists WHERE ApartmentID = 14;
SELECT COUNT(*) AS NumPictures_After FROM Pictures WHERE ApartmentID = 14;



