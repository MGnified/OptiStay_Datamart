/* ==================================================
PROJECT: OptiStay Datamart
AUTHOR: Maximilian Gräf
TABLE JOINS AND ANALYSIS
==================================================== */

-- Please note the execution order to ensure frictionless execution
-- 01_table_creation -> 02_alter_table_changes -> 03_dummy_data_inserts -> 
-- 04_trigger_creation -> 05_constraint_tests -> 06_joins_and_analysis

-- Research Question 1 : Which messages were exchanged about a specific booking and between whom? 
-- ternary relationships as join over three tables 
SELECT b.BookingID, u1.FirstName AS SenderFirstName, u1.LastName AS SenderLastName, 
       u2.FirstName AS ReceiverFirstName, u2.LastName AS ReceiverLastName,
       b.BookingDate, b.CheckInDate, c.SentAt, c.MessageText
  FROM UserChats c 
  JOIN Users u1 ON c.SenderID = u1.UserID
  JOIN Users u2 ON c.ReceiverID = u2.UserID
  JOIN Bookings b ON c.BookingID = b.BookingID -- inner join because only booking related should be retrieved
  WHERE b.BookingID = 12
  ORDER BY c.SentAt;

-- Research Question 2: Which Hosts did earn more than 5.000 € net?
SELECT u.FirstName, u.LastName, SUM(p.NetAmount) AS TotalNetPayout
  FROM HostPayouts p 
  JOIN Users u ON p.PayeeID = u.UserID
  WHERE p.PaidTo = 'Host'
  GROUP BY p/PayeeID
    HAVING SUM(p.NetAmount) > 5000
  ORDER BY TotalNetPayout DESC;


-- Research Question 3: What are the worst rated apartments by Guests and to which host belong them?
SELECT a.ApartmentID, a.BasePricePerNight, AVG(r.Rating) AS AvgRating, CONCAT(u.LastName, ', ',u.FirstName) AS HostName 
  FROM Reviews r
  JOIN Bookings b ON r.BookingID = b.BookingID 
  JOIN Apartments a ON b.ApartmentID = a.ApartmentID
  JOIN Hosts h ON a.HostID = h.HostID
  JOIN Users u ON h.UserID = u.UserID
  WHERE r.RatingType = 'Guest'
  GROUP BY a.ApartmentID
    HAVING AVG(r.Rating) < 3
  ORDER BY AvgRating;

-- Research Question 4: What are the most popular Amenities?
SELECT a.Amenity, COUNT(*) AS AmountOfAmenity
  FROM ApartmentAmenities aa 
  JOIN Amenities a ON aa.AmenityID = a.AmenityID
  GROUP BY a.AmenityID
    HAVING COUNT(*) > 10;

-- Research Question 5: Which host receives the payout for a given booking booking and how was it paid?
SELECT  u.LastName, u.FirstName, CONCAT(ad.Street, ' ', ad.HouseNumber, ', ' ,ad.PostalCode, ' ', ad.City, ', ', ad.Country) AS HostAddress,
      b.BookingID, b.CheckInDate, b.CheckOutDate, p.TotalAmount, p.Receipt, pm.Method
  FROM Bookings b 
  JOIN Apartments ap ON b.ApartmentID = ap.ApartmentID
  JOIN Hosts h ON ap.HostID = h.HostID
  JOIN Users u ON h.UserID = u.UserID
  JOIN Addresses ad ON u.AddressID = ad.AddressID
  JOIN Payments p ON b.BookingID = p.BookingID
  JOIN PaymentMethods pm ON p.PaymentMethodID = pm.PaymentMethodID
  ORDER BY u.LastName, b.BookingID;

-- Research Question 6: Which apartments have never been booked?
SELECT *  
  FROM Apartments a
  LEFT JOIN Bookings b ON a.ApartmentID = b.ApartmentID -- left join to show all bookings
  WHERE BookingID IS NULL;
  




