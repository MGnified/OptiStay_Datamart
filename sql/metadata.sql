/* ==================================================
PROJECT: OptiStay Datamart
AUTHOR: Maximilian Gräf
METADATA RETRIEVAL
==================================================== */

-- using the information_schema database to get metadata
USE information_schema; 

-- Volume of the database divided into data and index length
SELECT SUM(DATA_LENGTH) AS TotalDataLength, SUM(INDEX_LENGTH) AS TotalIndexLength FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = 'OptiStayDatamart' AND TABLE_TYPE = 'BASE TABLE';

-- number of total tables in the database
SELECT COUNT(*) AS NumberOfTables FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = 'OptiStayDatamart' AND TABLE_TYPE = 'BASE TABLE';

-- Number of Etnries per table, not used with counts, since TABLE_ROWS is an estimate with InnoDB
SELECT 'Admins' AS TableName, COUNT(*) AS NumberOfEntries FROM OptiStayDatamart.Admins
UNION ALL
SELECT 'Apartments', COUNT(*) FROM OptiStayDatamart.Apartments
UNION ALL
SELECT 'Hosts', COUNT(*) FROM OptiStayDatamart.Hosts
UNION ALL
SELECT 'Users', COUNT(*) FROM OptiStayDatamart.Users
UNION ALL
SELECT 'Bookings', COUNT(*) FROM OptiStayDatamart.Bookings
UNION ALL
SELECT 'HostPayouts', COUNT(*) FROM OptiStayDatamart.HostPayouts
UNION ALL
SELECT 'Payments', COUNT(*) FROM OptiStayDatamart.Payments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM OptiStayDatamart.Reviews
UNION ALL
SELECT 'CustomerSupport', COUNT(*) FROM OptiStayDatamart.CustomerSupport
UNION ALL
SELECT 'UserChats', COUNT(*) FROM OptiStayDatamart.UserChats
UNION ALL
SELECT 'Addresses', COUNT(*) FROM OptiStayDatamart.Addresses
UNION ALL
SELECT 'Amenities', COUNT(*) FROM OptiStayDatamart.Amenities
UNION ALL
SELECT 'ApartmentNeighbourhoods', COUNT(*) FROM OptiStayDatamart.ApartmentNeighbourhoods
UNION ALL
SELECT 'ApartmentStyles', COUNT(*) FROM OptiStayDatamart.ApartmentStyles
UNION ALL
SELECT 'BookingTypes', COUNT(*) FROM OptiStayDatamart.BookingTypes
UNION ALL
SELECT 'FeeTypes', COUNT(*) FROM OptiStayDatamart.FeeTypes
UNION ALL
SELECT 'PaymentMethods', COUNT(*) FROM OptiStayDatamart.PaymentMethods
UNION ALL
SELECT 'Pictures', COUNT(*) FROM OptiStayDatamart.Pictures
UNION ALL
SELECT 'ApartmentAmenities', COUNT(*) FROM OptiStayDatamart.ApartmentAmenities
UNION ALL
SELECT 'CoHostAssignments', COUNT(*) FROM OptiStayDatamart.CoHostAssignments
UNION ALL
SELECT 'FeePayments', COUNT(*) FROM OptiStayDatamart.FeePayments
UNION ALL
SELECT 'Recommendations', COUNT(*) FROM OptiStayDatamart.Recommendations
UNION ALL
SELECT 'Wishlists', COUNT(*) FROM OptiStayDatamart.Wishlists;



