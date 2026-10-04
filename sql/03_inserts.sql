/* ==================================================
PROJECT: OptiStay Datamart
AUTHOR: Maximilian Gräf
INSERTION OF DUMMY DATA 
==================================================== */

-- Please note the execution order to ensure frictionless execution
-- 01_table_creation -> 02_alter_table_changes -> 03_dummy_data_inserts -> 
-- 04_trigger_creation -> 05_constraint_tests -> 06_joins_and_analysis

USE OptiStayDatamart;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  LOOKUP VALUES
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
INSERT INTO ApartmentStyles (Style) VALUES 
  ('Modern'), ('Scandivian'), ('Industrial'), ('Bohemian'), ('Farmhouse'),
  ('Traditional'), ('Rustic'), ('Coastal'), ('Contemporary'), ('Alpine Chic');
  
INSERT INTO ApartmentNeighbourhoods (Type) VALUES 
  ('Urban'), ('Financial'), ('Rural'), ('Suburban'), ('Mountain Retreat'), 
  ('University Campus'), ('Industrial Park'), ('City Centre'), ('Lakeside'), ('Sea side');
  
INSERT INTO Amenities (Amenity) VALUES
  ('WiFi'), ('Swimming Pool'), ('Sauna'), ('Hot Tub'), ('Smart TV'),
  ('Washer'), ('Dryer'), ('Parking'), ('Balcony'), ('Garden'),
  ('Elevator'), ('Pet Bowls'), ('Dog bed'), ('Fully Equipped Kitchen'), ('Dedicated Workspace'),
  ('BBQ Grill'), ('Board Games'), ('High Chair'), ('Crib'), ('Air Conditioning'); 

INSERT INTO BookingTypes (Type) VALUES 
  ('Business Travel'), ('Family Trip'), ('Remote Work'), ('Group Holiday'), ('Honeymoon'), 
  ('Solo Travel'), ('Student'), ('Wellness & Spa'), ('Luxury Holiday'), ('Overnight Stopover');

INSERT INTO FeeTypes (Type, Category) VALUES 
  ('Cleaning', 'Host'), ('Pets', 'Host'), ('Extra Guest', 'Host'),
  ('Late Check-out', 'Host'), ('Early Check-in', 'Host'),
  ('Resort', 'Host'), ('Parking', 'Host'), ('Equipment rental', 'Host'),
  ('Event/Party', 'Host'), ('Infant Equipment', 'Host'), 
  ('Linen & Towels', 'Host'), ('Currency Conversion', 'Platform'),
  ('Payment Processing', 'Platform'),  ('Booking Protection', 'Platform'); 

INSERT INTO PaymentMethods (Method) VALUES 
  ('Credit Card'), ('PayPal'), ('Apple Pay'), ('Google Pay'), ('SEPA Direct Debit'),
  ('Sofortüberweisung'), ('Bank Transfer'), ('Klarna'), ('Gift Card'), ('Corporate Invoice');

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  CORE ENTITIES (platform's inventory)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
INSERT INTO Addresses (Street, HouseNumber, City, PostalCode, Country) VALUES
  ('boulevard Nicolas Olivier', '98', 'Grondin', '60506', 'FRA'),
  ('Marie-Theres-Heuser-Straße', '7-7', 'Fürstenwalde', '25102', 'DEU'),
  ('Elizahof', '049', 'Herwen', '2589TP', 'NLD'),
  ('Flantzgasse', '7/7', 'Querfurt', '09906', 'DEU'),
  ('Tesshof', '4', 'Oostwold', '6205 XI', 'NLD'),
  ('Leibetsederring', '8', 'Attnang-Puchheim', '6069', 'AUT'),
  ('Barkholzstr.', '0', 'Eisenberg', '47499', 'DEU'),
  ('Ella-Moser-Platz', '3', 'Spittal an der Drau', '6261', 'AUT'),
  ('Lennart-Beer-Weg', '59', 'Schwanenstadt', '3451', 'AUT'),
  ('Bättigstrasse', '13', 'Arbon', '8986', 'CHE'),
  ('Mareen-Henschel-Gasse', '8', 'Eilenburg', '69007', 'DEU'),
  ('Janos-Reuter-Straße', '5', 'Gunzenhausen', '31812', 'DEU'),
  ('boulevard de Briand', '8', 'Saint Philippine', '41895', 'FRA'),
  ('Jasonpad', '5', 'Musselkanaal', '6694 QM', 'NLD'),
  ('Schleichweg', '1-7', 'Arnstadt', '57566', 'DEU'),
  ('Kellerstrasse', '8', 'Villars-sur-Glâne', '2861', 'CHE'),
  ('Carmela-Dippel-Allee', '3-1', 'Brandenburg', '10174', 'DEU'),
  ('Roseplatz', '33', 'Jena', '79645', 'DEU'),
  ('Jariweg', '2', 'Hantum', '9177CL', 'NLD'),
  ('Wirthplatz', '0', 'Schärding', '5763', 'AUT');

-- Adding additional addresses getting 1.5 ratio to store users & apartments on different addresses
INSERT INTO Addresses (Street, HouseNumber, City, PostalCode, Country) VALUES
  ('Wolfgang-Ullmann-Gasse', '1-8', 'Grevesmühlen', '31343', 'DEU'),
  ('rue Aubry', '60', 'Robert', '57694', 'FRA'),
  ('Beate-Juncken-Gasse', '2/7', 'Sömmerda', '78418', 'DEU'),
  ('Gitte-Nohlmans-Weg', '30/34', 'Hohenstein-Ernstthal', '57118', 'DEU'),
  ('Ilka-Bohnbach-Gasse', '788', 'Bad Langensalza', '14460', 'DEU'),
  ('Mohrgasse', '49', 'Wieselburg', '2191', 'AUT'),
  ('Catherine-Gieß-Platz', '6/5', 'Siegen', '76658', 'DEU'),
  ('Tamara-Reisner-Straße', '38', 'Sankt Veit an der Glan', '4087', 'AUT'),
  ('boulevard Garnier', '18', 'Barre', '43430', 'FRA'),
  ('Thanelallee', '1751', 'Viechtach', '13267', 'DEU');
  
-- only 5 admins here, since no 20 admins are needed for the size of OptiStay Datamart
INSERT INTO Admins (FirstName, LastName, Email, Password) VALUES 
  ('Valentina', 'Frank', 'v.frank@optistay.com', 'i/-aoSN[|y:j3hhW-d@CFQ3kxi\QP2hQ'), 
  ('Carmelo', 'Kägi', 'c.kaegi@optisay.com', 'W!2,Zk/TBll*!44*I<r2bSP'), 
  ('Egon', 'Davids', 'e.davids@optistay.com', 'AdminPass!2022'), 
  ('Adrian', 'Zehnder', 'a.zehnder@optistay.com', '3aT5p+4\93I'), 
  ('Milica', 'Fitz', 'm.fitz@optistay.com', 'V2cuMUMbTmfsGuFgNn3vJRu');

INSERT INTO Users (FirstName, LastName, Email, PhoneNumber, Password, AddressID) VALUES 
  ('Noël', 'Allain', 'noel.allain@laposte.net', '+33 59791907', 'CestlaVie1', 1),
  ('Evelyne', 'Flantz', 'evelyne.flantz@yahoo.de', '+49 86012904', 'FlaAusFü1', 2),
  ('Lukas', 'van Egisheim', 'lukas.vanegisheim@hotmail.com', NULL, 'zNAWMrLxXf1yxOc7VX7jB3Be', 3),
  ('Evangelia', 'Ruppersberger', 'evangelia.ruppersberger@gmx.de', '+49 41177151', 'EvangRupp123', 4),
  ('Olivia', 'Schokman', 'olivia.schokman@hotmail.com', '+31 30401198', 'rLioosyK', 5),
  ('Lara', 'Luger', 'lara.luger@kabsi.at', NULL , 'Lara&Martin1999', 6),
  ('Pierre', 'Schmiedt', 'pierre.schmiedt@hotmail.de', '+49 20575594','MpZJ##-nQjOq', 7),
  ('Karla', 'Gosch', 'karla.gosch@gmx.at', '+43 59446109', 'xBVmO9DZhtVMTYEvtKV12', 8),
  ('Erina', 'Kammerer', 'erina.kammerer@gmail.com', '+43 72153974', 'G_c_KSlJjheBkLQioDXYGUzuMFB?', 9),
  ('Ronny', 'Leu', 'ronny.leu@yahoo.com', '+41 84756469', 'MyPassword123', 10),
  ('Juliane', 'Meyer', 'juliane.meyer@yahoo.de', '+49 84853194', 'bPGsgYaHZy5Xq', 11),
  ('Almut', 'Jacob', 'almut.jacob@gmail.com', '+49 98860915', 'LWsWGWya', 12),
  ('Susan', 'Rodriguez', 'susan.rodriguez@voila.fr', '+33 79604349', 'RodrFra1706', 13),
  ('Guus', 'Brugman', 'guus.brugman@gmail.com', '+31 41701887', 'vZ+-jaxw', 14),
  ('Stanislaw', 'Ebert', 'stanislaw.ebert@gmail.com', NULL, 'T9WKwCDYve8iy6TXKtFs', 15),
  ('Hans-Ulrich', 'Geiger', 'hans-ulrich.geiger@hotmail.com', '+41 49163620', 'H-UG-CHE1960', 16),
  ('Annika', 'Dobes', 'annika.dobes@yahoo.de', '+49 90723608', 'LCWjgpLfHsfGoZGXhWqHpsvst', 17),
  ('Arnd', 'Wilms', 'arnd.wilms@hotmail.de', '+49 88318180', 'sXf6jCqxb#cN', 18),
  ('Cornelia', 'van Bergen', 'cornelia.vanbergen@gmail.com', NULL , 'sXf6jCqxb#cN', 19),
  ('Lucas', 'Hinterleitner', 'lucas.hinterleitner@gmail.com', NULL, 'endlichUrlaub26', 20);
    
--  not all users are hosts so there are only 6 specified
INSERT INTO `Hosts` (UserID) VALUES 
  (3), (6), (9), (13), (15), (18);

-- apartments divided by host for readability and traceability
INSERT INTO Apartments (NumberOfBedrooms, BasePricePerNight, HostID, AddressID, StyleID, NeighbourhoodID) VALUES 
  -- Host 1: Lukas van Egisheim
  (2, 120.00, 1, 3, 1, 10),
  (1, 85.00, 1, 3, 8, 10),
  (3, 250.00, 1, 30, NULL, NULL),
  
  -- Host 2: Lara Luger
  (1, 95.00, 2, 26, 10, 5),
  (2, 150.00, 2, 26, 10, 5),
  (4, 400.00, 2, 26, 3, 5),
  (1, 75.00, 2, 28, 3, 2),
  (2, 110.00, 2, 28, NULL, 2),

  -- Host 3: Erina Kammerer
  (1, 90.00, 3, 9, NULL, NULL),

  -- Host 4: Susan Rodriguez
  (5, 600.00, 4, 22, 5, 3),
  (3, 300.00, 4, 29, 8, 8),
  (2, 140.00, 5, 29, 1, 8),

  -- Host 5: Stanislaw Ebert
  (2, 180.00, 5, 21, 8, 7),
  (1, 65.00, 5, 23, 7, 5),
  (1, 70.00, 5, 24, 6, 9),
  (2, 130.00, 5, 27, 4, NULL),

  -- Host 6: Arnd Wilms
  (3, 220.00, 6, 25, 1, 2),
  (1, 80.00, 6, 30, 7, 3),
  (4, 500.00, 6, 12, NULL, NULL),
  (2, 160.00, 6, 7, 5, NULL);

-- divide apartment amenities to trace back to apartment
INSERT INTO ApartmentAmenities (ApartmentID, AmenityID) VALUES 
  -- Apartment 1
  (1, 1), (1, 2), (1, 3), (1, 5),
  -- Apartment 2
  (2, 1), (2, 4),
  -- Apartment 3
  (3, 1), (3, 2), (3, 6), (3, 7),
  -- Apartment 4 
  (4, 1), (4, 3), (4, 8),
  -- Apartment 5
  (5, 1), (5, 2), (5, 3), (5, 9), (5, 10),
  -- Apartment 6 
  (6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 11), (6, 12),
  -- Apartment 7
  (7, 1), (7, 4),
  -- Apartment 8
  (8, 1), (8, 2), (8, 5),
  -- Apartment 9
  (9, 1), (9, 3),
  -- Apartment 10 
  (10, 1), (10, 2), (10, 3), (10, 4), (10, 5), (10, 6), (10, 7), (10, 8), (10, 9), (10, 10), (10, 13), (10, 14), (10, 15),
  -- Apartment 11
  (11, 1), (11, 2), (11, 3), (11, 5), (11, 12), (11, 14),
  -- Apartment 12
  (12, 1), (12, 2), (12, 4), (12, 8), (12, 9),
  -- Apartment 13 
  (13, 1), (13, 4),
  -- Apartment 14
  (14, 1), (14, 2),
  -- Apartment 15 
  (15, 1), (15, 3), (15, 6),
  -- Apartment 16
  (16, 1), (16, 2), (16, 3), (16, 10),
  -- Apartment 17
  (17, 1), (17, 2), (17, 5), (17, 7), (17, 11),
  -- Apartment 18
  (18, 1), (18, 4),
  -- Apartment 19 
  (19, 1), (19, 2), (19, 3), (19, 5), (19, 6), (19, 8), (19, 11), (19, 12), (19, 14), (19, 15),
  -- Apartment 20 
  (20, 1), (20, 2), (20, 3), (20, 7), (20, 9);

-- same for Pictures
INSERT INTO Pictures (URL, ApartmentID) VALUES 
    -- Apartment 1
  ('https://cdn.optistay.com/img/apt01_front.jpg', 1), ('https://cdn.optistay.com/img/apt01_liv.jpg', 1),
  ('https://cdn.optistay.com/img/apt01_bed.jpg', 1), ('https://cdn.optistay.com/img/apt01_kit.jpg', 1),
  
  -- Apartment 2
  ('https://cdn.optistay.com/img/apt02_main.jpg', 2),
  
  -- Apartment 3
  ('https://cdn.optistay.com/img/apt03_liv.jpg', 3), ('https://cdn.optistay.com/img/apt03_kit.jpg', 3),
  ('https://cdn.optistay.com/img/apt03_bed.jpg', 3), ('https://cdn.optistay.com/img/apt03_bath.jpg', 3),
  
  -- Apartment 4
  ('https://cdn.optistay.com/img/apt04_main.jpg', 4), ('https://cdn.optistay.com/img/apt04_bed.jpg', 4),
  
  -- Apartment
  ('https://cdn.optistay.com/img/apt05_liv.jpg', 5), ('https://cdn.optistay.com/img/apt05_kit.jpg', 5),
  ('https://cdn.optistay.com/img/apt05_bed.jpg', 5),
  
  -- Apartment 6
  ('https://cdn.optistay.com/img/apt06_main.jpg', 6), ('https://cdn.optistay.com/img/apt06_liv.jpg', 6),
  ('https://cdn.optistay.com/img/apt06_kit.jpg', 6), ('https://cdn.optistay.com/img/apt06_bdr.jpg', 6),
  ('https://cdn.optistay.com/img/apt06_pool.jpg', 6),
  
  -- Apartment 7 
  ('https://cdn.optistay.com/img/apt07_liv.jpg', 7), ('https://cdn.optistay.com/img/apt07_bedroom.jpg', 7),
  
  -- Apartment 8 
  ('https://cdn.optistay.com/img/apt08_liv_rm.jpg', 8), ('https://cdn.optistay.com/img/apt08_kitchen.jpg', 8),
  
  -- Apartment 9
  ('https://cdn.optistay.com/img/apt09_main.jpg', 9),
  
  -- Apartment 10
  ('https://cdn.optistay.com/img/apt10_front.jpg', 10), ('https://cdn.optistay.com/img/apt10_foy.jpg', 10),
  ('https://cdn.optistay.com/img/apt10_liv.jpg', 10), ('https://cdn.optistay.com/img/apt10_kit.jpg', 10),
  ('https://cdn.optistay.com/img/apt10_bed.jpg', 10), ('https://cdn.optistay.com/img/apt10 -bath.jpg', 10),
  
  -- Apartment 11
  ('https://cdn.optistay.com/img/apt11_liv.jpg', 11),  ('https://cdn.optistay.com/img/apt11_din.jpg', 11),
  ('https://cdn.optistay.com/img/apt11_bed.jpg', 11), ('https://cdn.optistay.com/img/apt11_balc.jpg', 11),
  
  -- Apartment 12 
  ('https://cdn.optistay.com/img/apt12_liv.jpg', 12), ('https://cdn.optistay.com/img/apt12_main.jpg', 12),
  
  -- Apartment 13
  ('https://cdn.optistay.com/img/apt13_main.jpg', 13),
  
  -- Apartment 14
  ('https://cdn.optistay.com/img/apt14_main.jpg', 14),
  
  -- Apartment 15 
  ('https://cdn.optistay.com/img/apt15_liv.jpg', 15), ('https://cdn.optistay.com/img/apt15_kitchen.jpg', 15),
  
  -- Apartment 16 
  ('https://cdn.optistay.com/img/apt16_liv.jpg', 16), ('https://cdn.optistay.com/img/apt16_kit.jpg', 16),
  ('https://cdn.optistay.com/img/apt16_bed.jpg', 16),
  
  -- Apartment 17 
  ('https://cdn.optistay.com/img/apt17_liv.jpg', 17), ('https://cdn.optistay.com/img/apt17_kit.jpg', 17),
  ('https://cdn.optistay.com/img/apt17_main.jpg', 17), ('https://cdn.optistay.com/img/apt17_gst_rm.jpg', 17),
  
  -- Apartment 18 
  ('https://cdn.optistay.com/img/apt18_main.jpg', 18), 
  
  -- Apartment 19
  ('https://cdn.optistay.com/img/apt19_liv.jpg', 19), ('https://cdn.optistay.com/img/apt19_din.jpg', 19),
  ('https://cdn.optistay.com/img/apt19_kit.jpg', 19), ('https://cdn.optistay.com/img/apt19_bed.jpg', 19),
  ('https://cdn.optistay.com/img/apt19_terr.jpg', 19),
  
  -- Apartment 20 
  ('https://cdn.optistay.com/img/apt20_liv.jpg', 20), ('https://cdn.optistay.com/img/apt20_kitchen.jpg', 20),
  ('https://cdn.optistay.com/img/apt20_bed_1.jpg', 20);

-- specializing Co-Hosts for Hosts 
INSERT INTO CoHostAssignments (CoHostID, ApartmentID, AssignmentDate) VALUES 
  -- Guus (UserID 14) for Lukas (UserID 3)
  (14, 1, '2026-02-05'), (14, 2, DEFAULT),
  -- Juliane (User ID 11) for Lara (UserID 6)
  (11, 4, '2026-02-10'), (11,5,'2026-02-10'), (11, 6, '2026-05-17'),
    -- Juliane (UserID 11) for Stanislaw (UserID 15)
  (11, 16, '2026-07-01'),
  -- Pierre (UserID 7) for Stanislaw (UserID 15)
  (7, 13, DEFAULT);

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TRANSACTIONS (Accounting)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
INSERT INTO Bookings (BookingDate, CheckInDate, CheckOutDate, NumberOfGuests, PricePerNight, TotalNights, BookingTypeID, UserID, ApartmentID) VALUES 
  ('2026-02-24 08:04:20', '2026-05-13', '2026-05-22', 4, 140.0,  9,  4, 10, 12), 
  ('2026-02-13 00:35:09', '2026-04-26', '2026-05-05', 5, 220.0,  9,  2, 14, 17), 
  ('2026-02-05 09:19:59', '2026-05-28', '2026-06-07', 1,  70.0, 10,  8, 13, 15), 
  ('2026-02-01 00:00:52', '2026-06-22', '2026-06-25', 1,  85.0,  3,  NULL, 19, 2) , 
  ('2026-01-01 18:11:41', '2026-01-03', '2026-01-07', 2, 400.0,  4,  1, 18, 6) , 
  ('2026-01-23 11:21:04', '2026-07-18', '2026-07-28', 3, 120.0, 10, 2,  2, 1) , 
  ('2026-02-19 00:48:12', '2026-04-05', '2026-04-10', 1, 180.0,  5,  9, 10, 13), 
  ('2026-05-04 00:01:51', '2026-05-21', '2026-05-29', 1, 110.0,  8,  3,  9, 8) , 
  ('2026-01-01 13:21:42', '2026-01-03', '2026-01-09', 1, 250.0,  6,  NULL, 17, 3) , 
  ('2026-04-09 12:35:30', '2026-09-13', '2026-09-23', 1,  80.0, 10, NULL, 19, 18), 
  ('2026-02-02 10:44:05', '2026-03-07', '2026-03-09', 2, 220.0,  2,  5, 20, 17), 
  ('2026-07-25 12:07:35', '2026-12-16', '2026-12-24', 5, 300.0,  8, 4, 17, 11), 
  ('2026-03-11 11:02:14', '2026-09-07', '2026-09-15', 2, 600.0,  8,  5,  3, 10), 
  ('2026-02-11 23:21:46', '2026-04-30', '2026-05-04', 2, 150.0,  4,  3, 15, 5) , 
  ('2026-05-07 07:32:38', '2026-09-21', '2026-10-04', 4, 180.0, 13, 2,  6, 13), 
  ('2026-02-26 15:35:11', '2026-03-22', '2026-04-04', 2,  75.0, 13,  1,  1, 7) , 
  ('2026-03-09 15:08:53', '2026-06-14', '2026-06-25', 8, 600.0, 11,  1,  8, 10), 
  ('2026-01-07 16:59:58', '2026-02-01', '2026-02-13', 2,  75.0, 12,  7,  3, 7) , 
  ('2026-01-05 19:39:24', '2026-01-25', '2026-01-29', 1, 300.0,  4,  NULL,  8, 11), 
  ('2026-03-09 06:43:07', '2026-11-03', '2026-11-11', 8, 500.0,  8, 4,  9, 19);

INSERT INTO Payments(Receipt, SubTotalAmount, ServiceFeeGuest, TotalTax, TotalAmount, BookingID, PaymentMethodID, InvoiceAddressID) VALUES
  ('2026-02-24 08:04:20', 1260.0, 32.6, 126.0, 1530.56, 1, 1, 10), 
  ('2026-02-13 00:35:09', 1980.0, 312.45, 138.6, 2543.65, 2, 7, 14), 
  ('2026-02-05 09:19:59', 700.0, 116.49, 49.0, 1177.12, 3, 2, 13), 
  ('2026-02-01 00:00:52', 255.0, 6.22, 53.55, 679.45, 4, 6, 19), 
  ('2026-01-01 18:11:41', 1600.0, 0.0, 160.0, 1824.13, 5, 10, 21), -- invoice Address
  ('2026-01-23 11:21:04', 1200.0, 120.19, 252.0, 1642.52, 6, 5, 2), 
  ('2026-02-19 00:48:12', 900.0, 79.27, 63.0, 1088.38, 7, 9, 10), 
  ('2026-05-04 00:01:51', 880.0, 0.0, 88.0, 1080.29, 8, 10, 28), -- invoice address
  ('2026-01-01 13:21:42', 1500.0, 22.18, 105.0, 2082.23, 9, 7, 17), 
  ('2026-04-09 12:35:30', 800.0, 112.1, 56.0, 1253.5, 10, 9, 19), 
  ('2026-02-02 10:44:05', 440.0, 49.14, 30.8, 593.46, 11, 4, 20), 
  ('2026-07-25 12:07:35', 2400.0, 40.22, 240.0, 2768.63, 12, 8, 17), 
  ('2026-03-11 11:02:14', 4800.0, 0.0, 480.0, 5687.16, 13, 10, 3), 
  ('2026-02-11 23:21:46', 600.0, 0.0, 60.0, 754.63, 14, 10, 15), 
  ('2026-05-07 07:32:38', 2340.0, 318.79, 163.8, 2867.35, 15, 6, 6), 
  ('2026-02-26 15:35:11', 975.0, 27.54, 97.5, 1117.43, 16, 8, 1), 
  ('2026-03-09 15:08:53', 6600.0, 806.74, 660.0, 8291.56, 17, 9, 8), 
  ('2026-01-07 16:59:58', 900.0, 122.59, 90.0, 1131.67, 18, 8, 3), 
  ('2026-01-05 19:39:24', 1200.0, 176.15, 120.0, 1614.77, 19, 7, 8), 
  ('2026-03-09 06:43:07', 4000.0, 45.45, 280.0, 4522.18, 20, 3, 9);

INSERT INTO FeePayments(FeeTypeID, PaymentID, Price) VALUES 
  (1, 1, 11.76), (11, 1, 7.25), (7, 1, 9.92), (6, 1, 55.54), (3, 1, 27.49),
  (13, 1, 32.6), (1, 2, 12.42), (11, 2, 7.24), (6, 2, 57.31), (3, 2, 35.63), 
  (14, 2, 270.99), (13, 2, 41.46), (1, 3, 14.07), (11, 3, 8.93), (10, 3, 9.91),
  (9, 3, 194.72), (8, 3, 28.25), (5, 3, 28.29), (4, 3, 27.46), (14, 3, 96.77), 
  (13, 3, 19.72), (1, 4, 11.33), (11, 4, 5.82), (5, 4, 29.77), (9, 4, 292.07),
  (8, 4, 25.69), (13, 4, 6.22), (1, 5, 10.83), (11, 5, 5.9), (6, 5, 47.4), 
  (1, 6, 14.1), (11, 6, 6.48), (6, 6, 49.75), (14, 6, 106.21), (13, 6, 13.98),
  (1, 7, 10.24), (11, 7, 6.91), (4, 7, 28.96), (14, 7, 79.27), (1, 8, 13.38), 
  (11, 8, 8.85), (4, 8, 29.75), (10, 8, 8.32), (6, 8, 51.99), (1, 9, 11.18),
  (11, 9, 7.65), (10, 9, 9.16), (9, 9, 290.19), (4, 9, 28.33), (5, 9, 27.73), 
  (8, 9, 25.93), (6, 9, 54.88), (13, 9, 22.18), (1, 10, 14.41), (11, 10, 7.39),
  (4, 10, 26.52), (5, 10, 26.2), (8, 10, 26.9), (9, 10, 174.28), (10, 10, 9.7), 
  (14, 10, 112.1), (1, 11, 10.12), (11, 11, 8.97), (10, 11, 6.93), (6, 11, 47.5),
  (14, 11, 37.53), (13, 11, 11.61), (1, 12, 14.1), (11, 12, 9.94), (6, 12, 41.06), 
  (3, 12, 23.31), (13, 12, 40.22), (1, 13, 14.01), (11, 13, 9.03), (5, 13, 25.02),
  (8, 13, 25.11), (9, 13, 274.86), (10, 13, 7.34), (7, 13, 5.53), (6, 13, 46.26), 
  (1, 14, 10.94), (11, 14, 7.89), (4, 14, 28.77), (6, 14, 47.03), (1, 15, 12.48),
  (11, 15, 7.9), (3, 15, 24.38), (14, 15, 249.18), (13, 15, 69.61), (1, 16, 11.9), 
  (11, 16, 5.49), (13, 16, 27.54), (1, 17, 13.7), (11, 17, 9.39), (8, 17, 28.86),
  (4, 17, 25.44), (5, 17, 29.39), (7, 17, 5.22), (6, 17, 50.5), (2, 17, 6.09), 
  (3, 17, 56.23), (14, 17, 806.74), (1, 18, 13.01), (11, 18, 6.07), (14, 18, 98.65),
  (13, 18, 23.94), (1, 19, 14.87), (11, 19, 6.11), (4, 19, 29.69), (6, 19, 59.2), 
  (2, 19, 8.75), (14, 19, 149.0), (13, 19, 27.15), (1, 20, 12.59),  (11, 20, 6.93),
  (4, 20, 27.34), (7, 20, 6.4), (6, 20, 52.59), (2, 20, 8.99), (3, 20, 81.89), (13, 20, 45.45);
   
INSERT INTO HostPayouts(PaymentDate, GrossAmount, PlatformCommission, HostFees, NetAmount, HostShare, PaidTo, PaymentID, PayeeID) VALUES 
  ('2026-02-25 08:04:20', 1371.96, 37.8, 111.96, 1334.16, 1.0, 'Host', 1, 15), 
  ('2026-02-14 00:35:09', 2092.6, 59.4, 112.6, 2033.2, 1.0, 'Host', 2, 18), 
  ('2026-02-06 09:19:59', 1011.63, 21.0, 311.63, 990.63, 1.0, 'Host', 3, 15), 
  ('2026-02-02 00:00:52', 433.78, 5.35, 255.28, 428.42, 0.7, 'Host', 4, 3), 
  ('2026-02-02 00:00:52', 185.9, 2.29, 109.4, 183.61, 0.3, 'CoHost', 4, 14), 
  ('2026-01-02 18:11:41', 1164.89, 33.6, 44.89, 1131.29, 0.7, 'Host', 5, 6), 
  ('2026-01-02 18:11:41', 499.24, 14.4, 19.24, 484.84, 0.3, 'CoHost', 5, 11), 
  ('2026-01-24 11:21:04', 889.23, 25.2, 49.23, 864.03, 0.7, 'Host', 6, 3), 
  ('2026-01-24 11:21:04', 381.1, 10.8, 21.1, 370.3, 0.3, 'CoHost', 6, 14), 
  ('2026-02-20 00:48:12', 662.28, 18.9, 32.28, 643.38, 0.7, 'Host', 7, 15), 
  ('2026-02-20 00:48:12', 283.83, 8.1, 13.83, 275.73, 0.3, 'CoHost', 7, 7), 
  ('2026-05-05 00:01:51', 992.29, 26.4, 112.29, 965.89, 1.0, 'Host', 8, 6), 
  ('2026-01-02 13:21:42', 1955.05, 45.0, 455.05, 1910.05, 1.0, 'Host', 9, 3), 
  ('2026-04-10 12:35:30', 1085.4, 24.0, 285.4, 1061.4, 1.0, 'Host', 10, 18), 
  ('2026-02-03 10:44:05', 513.52, 13.2, 73.52, 500.32, 1.0, 'Host', 11, 18), 
  ('2026-07-26 12:07:35', 2488.41, 72.0, 88.41, 2416.41, 1.0, 'Host', 12, 13), 
  ('2026-03-12 11:02:14', 5207.16, 144.0, 407.16, 5063.16, 1.0, 'Host', 13, 13), 
  ('2026-02-12 23:21:46', 486.24, 12.6, 66.24, 473.64, 0.7, 'Host', 14, 6), 
  ('2026-02-12 23:21:46', 208.39, 5.4, 28.39, 202.99, 0.3, 'CoHost', 14, 11), 
  ('2026-05-08 07:32:38', 1669.33, 49.14, 31.33, 1620.19, 0.7, 'Host', 15, 15), 
  ('2026-05-08 07:32:38', 715.43, 21.06, 13.43, 694.37, 0.3, 'CoHost', 15, 7), 
  ('2026-02-27 15:35:11', 992.39, 29.25, 17.39, 963.14, 1.0, 'Host', 16, 6), 
  ('2026-03-10 15:08:53', 6824.82, 198.0, 224.82, 6626.82, 1.0, 'Host', 17, 13), 
  ('2026-01-08 16:59:58', 919.08, 27.0, 19.08, 892.08, 1.0, 'Host', 18, 6), 
  ('2026-01-06 19:39:24', 1318.62, 36.0, 118.62, 1282.62, 1.0, 'Host', 19, 13), 
  ('2026-03-10 06:43:07', 4196.73, 120.0, 196.73, 4076.73, 1.0, 'Host', 20, 18);

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    COMMUNICATION & USER ACTIVITY
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
INSERT INTO UserChats(MessageText, SentAt, SenderID, ReceiverID, BookingID) VALUES 
  ('Will relate buy many rock. Million eight should sister put. Reality move officer build. His audience fact back federal happen win any. Deal still account become cell Democrat article. Push wrong nor thank. Us religious kind fill ready eat.','2026-03-05 22:56:01',3,2,6),
  ('Throw that word shoulder. Through energy carry capital our way shoulder. Check despite western build goal this economic. Their trip from forward manage. Along between what. Image skin big conference full at. Value talk anything tonight they yet. Next food two call make wish source. Mr safe seem in. Appear increase action condition also. Edge attorney of process. Community knowledge agree sing.','2026-08-22 07:31:15',13,17,12),
  ('Leg enough follow west that. International bank later industry suggest. Drive Mr leg business. Result degree sign already.','2026-12-31 21:30:32',17,3,NULL),
  ('Institution adult turn read agent movement vote. Tax most one language show southern note. Executive in pull camera ok blue do. Study state idea race know people song. Onto red collection wear.','2026-03-06 18:37:08',15,10,1),
  ('Happy deal drop space. Pattern base leg analysis. Scene born miss also. Deal southern involve middle boy society test minute. National evening also on turn officer. Close thought show piece specific affect. At month fear hard. Hear American approach break huge hotel. Plan parent attorney environment travel tax do. Out program each fish also especially. Lawyer much produce.','2026-05-27 03:04:43',15,13,3),
  ('Magazine try could want spend direction drive base. Set who time involve rise rule other. Plan last doctor success country.','2026-06-16 11:28:43',6,15,15),
  ('Move right worker number.','2026-04-07 12:33:22',10,15,7),
  ('Result since I manager. Yes environment lose ask. Loss discussion west blood. Process dream every under usually. Ok short run least. Know political and mission film in reason. Budget threat study visit return memory. Point head quality. Lot high south brother sound game. Allow crime on process south. Short travel himself become best training whatever. Total coach never could positive activity on.','2026-05-26 05:37:04',6,9,8),
  ('Energy cell figure walk look. Movie create second purpose local size. Late place perhaps score.','2026-02-07 22:48:44',6,3,18),
  ('Source instead most house sport daughter. East still control TV security. Quality like individual specific remain national. Building can maybe artist know all building. Evening his kid teacher. Off understand Congress quality set student fly. Establish physical week foot.','2026-05-16 07:23:54',3,2,6),
  ('Meeting future travel employee for field point. Loss attorney air. Take still really. Put wall late often. Game manager goal blood protect occur attorney themselves. Address country account however. Author person financial either along. Anything traditional tonight remember a wear. Pm marriage source option.','2026-03-11 09:24:34',19,3,4),
  ('Crime receive team word. Trial around religious team space parent. Memory career employee become. Movement determine total mean debate finally. Race town with cup. Democratic watch quality office Republican spring. Tend without exist order clear full memory. Lay read cause crime answer.','2026-03-03 21:00:06',15,10,7),
  ('Their yard knowledge wear. Not buy rest experience your. Kind watch indeed foreign herself will cultural. Somebody fear pressure finish capital season article. Ok throw piece vote. Control friend next hospital performance minute.','2026-05-05 02:29:13',9,6,8),
  ('Leg my beyond seem American. Include treat hair present.','2026-08-21 05:55:44',17,13,12),
  ('Issue lawyer represent box. Side future kid president development. Fire where assume song see minute. Wish tough officer quite seek group old available. Star simple mention child. Color crime your gun.','2026-07-28 09:26:49',13,17,12),
  ('Class hair trade system teach detail finish.','2026-02-04 03:26:31',3,6,18),
  ('Paper offer citizen forget detail marriage. Smile easy evidence pull less. Machine no material clear discuss seek. Be try once college company. Hold own give yard.','2026-04-29 03:29:01',13,3,13),
  ('Body computer Congress from.','2026-03-15 15:51:41',18,19,NULL),
  ('Condition week probably life box.','2026-01-08 14:11:52',17,3,9),
  ('Task response read move bank its news history. General area act because sport provide set people. Difference important environment government try child area. Sell draw expert point. Argue guy decade such him experience event. Easy service if little per. Hour investment glass week. Theory what white standard budget. Toward meeting early every various than bed anyone. Be strategy no dream however increase. Well garden sing.','2026-01-22 19:47:11',8,13,19);
     
INSERT INTO CustomerSupport(MessageText, SentAt, AssigneeID, OpenerID, BookingID) VALUES
  ('Seek operation worry Mr table available. Others view small because. View seem yet white.','2026-03-02 23:44:22',3,10,7),
  ('Partner sit former. Western sea trip consider drop often approach. Admit throw speech hot project assume. Impact sit third boy south result candidate property. Hold cell respond win another Congress. Area just agent turn wait what. Contain sea imagine. Outside yet door next left study paper. Meet challenge travel their. Break enough order. Fire garden carry significant describe. Civil first other meeting eye act say. Foreign agree bring join. Forward power into.','2026-07-11 03:43:14',4,9,20),
  ('Audience start benefit resource see summer appear teach. Find task itself from. Create eat consider memory. Try record hospital kid popular seven. Fish go hour Republican form suffer edge. Expert administration tree collection price fast.','2026-03-12 00:05:38',4,14,2),
  ('Tree total range beat. Offer body people large body decision trip. Sound prepare as return matter same. Their lot feel commercial institution. Order color safe.','2026-01-27 15:56:03',3,3,18),
  ('Treatment final front meeting check while. Street game crime mind group democratic chance. Enter if drug almost never. Perform serve eight.','2026-08-17 00:25:33',1,17,12),
  ('Late contain wide serve. Child clearly send beautiful student. Rise wish kitchen. Scene prevent series month. Difference job might suggest look sell. Present front chance born training strategy. Air ready reduce whatever. Investment ten finally each including. Business police poor approach think. Year none attorney. Bad investment ask join that crime father. Simple need already sound tree.','2026-02-17 12:12:49',1,20,11),
  ('Tend door specific social. Fire agree all image hit series. Language tonight official score. Later happen commercial analysis air government class. Unit race edge street institution nice discover. Right environmental writer appear letter talk.','2026-03-01 16:58:56',1,10,7),
  ('Speak relationship edge future back level drop read. Up visit list. Concern start quite describe involve color. Voice sure total by politics discuss boy. Debate both hospital together Mrs. Range late say young. Send window simple world test determine this official. War above always generation memory. Book compare people fish during surface put Mr. Prepare anything couple.','2026-05-01 21:09:29',5,19,10),
  ('Blue shoulder community research. Program develop Republican off leader. Wind want themselves contain anything. Claim direction hand condition example. If food garden low.','2026-05-12 17:21:27',2,9,8),
  ('Billion site.','2026-01-09 19:55:03',1,3,NULL),
  ('Paper another campaign party bag million recently. Positive friend mouth south same over box.','2026-04-01 06:38:35',4,10,7),
  ('Value forget good financial. Bad term green meeting. Somebody indicate idea natural marriage per describe. Environment machine deep report. Painting evening speak type indeed thought.','2026-02-25 21:37:33',3,10,7),
  ('Address voice doctor common realize. Science treatment analysis husband over list not. Here another understand wish. Picture bed could. Seem all college group marriage provide. Sometimes hundred interview indicate. There firm big nothing later.','2026-03-26 14:22:42',1,9,NULL),
  ('Business girl food each free let us. Main size miss. Discover than concern for line. Successful whole site lot even around technology fast. Resource bag risk side everyone few. Stand body area even imagine.','2026-04-22 12:58:05',4,10,1),
  ('Color contain house become. Move dark word those court carry. For finish live. Land night rise special peace.','2026-04-18 20:59:49',4,10,1),
  ('Free authority election herself spend. Republican moment price ask wrong level. With return world which recognize real drop. Health authority three last. Community whatever popular this wide research low. Story ago blood big spend. Even top stock affect. Design realize environmental language strong society only.','2026-07-27 15:38:32',1,6,15),
  ('Local machine cultural look chance. Including tough front of five. Put next involve success certainly. Effort less they election feel science television. High friend price throughout though. Speak realize top turn they. Turn major remain trial. Business with around again environment. Information Mr compare fly line message my event. Order seem character carry true.','2026-04-19 11:28:54',4,9,20),
  ('Sense single last economic pretty believe. Consider energy as name. Something arrive ask recently. Fact ask data cold commercial open. Bad often he.','2026-05-18 23:44:31',1,9,NULL),
  ('Lawyer brother eye store. Thing notice poor clear happen major. Medical thought him blue wife have behind. Least certainly responsibility financial car. Story maybe daughter pass beautiful entire national. Enough rock pick mind. Through ok sport senior imagine. Local operation possible.','2026-01-05 19:23:42',2,18,5),
  ('Identify cause see determine night conference. Kid purpose behavior. Take together dinner book first. Stock despite offer recently entire artist record. Official time forget control better. Amount myself popular place soldier fact skill. Position bring likely air program machine.','2026-01-27 09:55:52',5,8,19);
 
INSERT INTO Reviews(Rating, Comment, RatingType, ReviewDate, UserID, BookingID) VALUES 
  (3, NULL, 'Guest', '2026-06-25 21:12:21', 8, 17),
  (5, 'Very polite and reliable', 'Host', '2026-03-09 09:19:06', 18, 11),
  (3, NULL, 'Guest', '2026-05-04 11:58:36', 15, 14),
  (2, 'Left a mess in the apartment!', 'Host', '2026-05-22 17:17:04', 15, 1),
  (2, 'Horrible apartment! Never again!', 'Guest', '2026-01-09 01:34:26', 17, 9),
  (1, 'Left a mess in the apartment!', 'Host', '2026-04-05 20:04:16', 6, 16),
  (1, 'Dirty and bad service', 'Guest', '2026-04-11 19:32:41', 10, 7),
  (3, NULL, 'Host', '2026-05-04 01:19:03', 6, 14),
  (2, 'Horrible apartment! Never again!', 'Guest', '2026-06-07 02:46:03', 13, 3),
  (3, 'Stay was okay.', 'Guest', '2026-03-09 10:48:21', 20, 11),
  (4, 'Very polite and reliable', 'Host', '2026-07-28 09:12:00', 3, 6), 
  (1, NULL, 'Guest', '2026-04-04 11:17:46', 1, 16),
  (4, NULL, 'Host', '2026-06-07 10:38:22', 15, 3), 
  (5, 'Definitely coming again!', 'Guest', '2026-01-30 04:04:20', 8, 19),
  (4, 'Definitely coming again!', 'Guest', '2026-06-26 08:31:58', 19, 4), 
  (4, NULL, 'Guest', '2026-01-08 13:09:14', 18, 5),
  (1, 'Dirty and bad service', 'Guest', '2026-05-05 11:35:37', 14, 2),
  (1, NULL, 'Host', '2026-05-29 21:07:07', 6, 8),
  (1, 'Horrible apartment! Never again!', 'Guest', '2026-02-13 13:08:41', 3, 18),
  (2, 'Left a mess in the apartment!', 'Host', '2026-01-07 11:34:35', 6, 5);

INSERT INTO Recommendations (RecommendedBy, RecommendedTo, ApartmentID) VALUES 
  (11, 16, 2), (5, 3, 10), (11, 4, 18), (10, 16, 15), (17, 9, 11), 
  (4, 19, 9), (14, 12, 18), (7, 1, 15), (14, 11, 2), (20, 14, 19),
  (12, 13, 19), (16, 11, 20), (16, 10, 9), (10, 1, 11), (12, 6, 10),
  (20, 8, 16), (16, 3, 6), (10, 6, 12), (19, 12, 10), (9, 17, 11);

INSERT INTO Wishlists (ApartmentID, UserID, AddingDate) VALUES 
  (3, 4, '2026-01-30'), (1, 6, '2026-08-22'), (2, 18, '2026-05-18'), (2, 20, '2026-07-03'),
  (2, 16, '2026-01-13'), (10, 12, '2026-05-30'), (7, 1, DEFAULT), (5, 4, '2026-08-20'),
  (8, 13, '2026-05-22'), (16, 5, '2026-06-18'), (20, 10, '2026-03-18'), (11, 3, '2026-05-15'),
  (6, 10, DEFAULT), (12, 8, '2026-01-09'), (14, 17, '2026-02-01'), (9, 3, '2026-07-29'),
  (13, 16, '2026-02-06'), (6, 5, DEFAULT), (14, 10, '2026-04-15'), (10, 8, '2026-06-27');



