/* ==================================================
PROJECT: OptiStay Datamart
AUTHOR: Maximilian Gräf
TRIGGER CREATION
==================================================== */

-- Please note the execution order to ensure frictionless execution
-- 01_table_creation -> 02_alter_table_changes -> 03_dummy_data_inserts -> 
-- 04_trigger_creation -> 05_constraint_tests -> 06_joins_and_analysis

USE OptiStayDatamart;

SHOW TRIGGERS; 

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++
   AFTER UPDATE TRIGGER: delayed & calculated HostPayouts
++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- DELIMITER //
-- commented out for Beekeeper Studio -> required when running via MySQL CLI
CREATE TRIGGER Payments_Trgr_Payout
  AFTER UPDATE ON Payments -- After update, because fee rows don't exist yet when payment is inserted
  FOR EACH ROW 
  BEGIN 
  -- Variables for the values the payout is built from 
  DECLARE t_ApartmentID INTEGER;
  DECLARE t_HostUserID INTEGER;
  DECLARE t_CoHostID INTEGER;
  DECLARE t_HostFees DECIMAL(10,2) DEFAULT 0;
  DECLARE t_Gross DECIMAL(10,2);
  DECLARE t_Commission DECIMAL(10,2);
  DECLARE t_Net DECIMAL(10,2);

  -- trigger fires only when TotalAmount changes, i.e. on finalization of the payment
  IF OLD.TotalAmount != NEW.TotalAmount THEN 
  
    SELECT a.ApartmentID, h.UserID INTO t_ApartmentID, t_HostUserID FROM Bookings b
      JOIN Apartments a ON b.ApartmentID = a.ApartmentID
      JOIN Hosts h ON a.HostID = h.HostID
      WHERE b.BookingID = NEW.BookingID;
  
    SELECT CoHostID INTO t_CoHostID FROM CoHostAssignments 
      WHERE ApartmentID = t_ApartmentID;

    -- Host fees are summed from the Host-category FeePayments of this payment
    SELECT COALESCE(SUM(fp.Price), 0) INTO t_HostFees FROM FeePayments fp
      JOIN FeeTypes ft ON fp.FeeTypeID = ft.FeeTypeID
        WHERE ft.Category = 'Host' AND fp.PaymentID = NEW.PaymentID;
  
    SET t_Gross = NEW.SubTotalAmount + t_HostFees; 
    SET t_Commission = t_Gross * 0.03;
    SET t_Net = t_Gross - t_Commission;
    -- No co-host: one payput row with 100% share
    IF t_CoHostID IS NULL THEN 
      INSERT INTO HostPayouts (PaymentDate, GrossAmount, PlatformCommission, HostFees, NetAmount, HostShare, PaidTo, PaymentID, PayeeID) VALUES
        (DATE_ADD(NEW.Receipt, INTERVAL 24 HOUR), t_Gross, t_Commission, t_HostFees, t_Net, 1.000, 'Host', NEW.PaymentID, t_HostUserID);
    -- with co-host: two rows, all amounts split in 70/30 ratio
    ELSE 
      INSERT INTO HostPayouts (PaymentDate, GrossAmount, PlatformCommission, HostFees, NetAmount, HostShare, PaidTo, PaymentID, PayeeID) VALUES
        (DATE_ADD(NEW.Receipt, INTERVAL 24 HOUR), t_Gross * 0.7, t_Commission * 0.7, t_HostFees * 0.7, t_Net * 0.7, 0.700, 'Host', NEW.PaymentID, t_HostUserID),
        (DATE_ADD(NEW.Receipt, INTERVAL 24 HOUR), t_Gross * 0.3, t_Commission * 0.3, t_HostFees * 0.3, t_Net * 0.3, 0.300, 'CoHost', NEW.PaymentID, t_CoHostID);
    END IF;
  END IF;
END; -- //
-- DELIMITER ;

/* +++++++++++++++++++++++++++++++++++++++++++++++++
  SIGNAL TRIGGERS for CoHostAssignments, Wishlists, 
    Recommendations and Reviews
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- BEFORE INSERT only, guarded columns are primary keys, 
-- so a change is performed as a delete followed by a new insert

-- a co-host must not be the host of the same apartment
-- DELIMITER //
CREATE TRIGGER CoHostAssignments_Trgr_HostConflict
  BEFORE INSERT ON CoHostAssignments
  FOR EACH ROW 
  BEGIN

  DECLARE t_HostUserID INTEGER;
  
  SELECT h.UserID INTO t_HostUserID 
    FROM Hosts h 
    JOIN Apartments a ON h.HostID = a.HostID
    WHERE a.ApartmentID = NEW.ApartmentID;
  
    IF t_HostUserID = NEW.CoHostID THEN 
      SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = 'Co-host cannot be the host of this apartment';
    END IF;
END; -- //
-- DELIMITER ;


-- A host must not add their own apartment to a wishlist
-- DELIMITER //
CREATE TRIGGER Wishlists_Trgr_NoSelfWish
  BEFORE INSERT ON Wishlists 
  FOR EACH ROW 
  BEGIN 
    DECLARE t_HostUserID INTEGER; 

    SELECT h.UserID INTO t_HostUserID FROM Hosts h 
      JOIN Apartments a ON h.HostID = a.HostID
        WHERE a.ApartmentID = NEW.ApartmentID;

    IF t_HostUserID = NEW.UserID THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot add your own apartment to a Wishlist';
  END IF;
END; -- //
-- DELIMITER ;

-- An apartment must not be recommended to its own host
-- DELIMITER //
CREATE TRIGGER Recommendations_Trgr_NoRecommendedToHost
  BEFORE INSERT ON Recommendations
  FOR EACH ROW
  BEGIN 
    DECLARE t_HostUserID INTEGER;

    SELECT h.UserID INTO t_HostUserID FROM Hosts h 
      JOIN Apartments a ON h.HostID = a.HostID
        WHERE a.ApartmentID = NEW.ApartmentID;

  IF t_HostUserID = NEW.RecommendedTo THEN 
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot recommend an apartment to its own Host';
  END IF;
END; -- //
-- DELIMITER ;

-- A review must not be written before the checkout date
-- DELIMITER //
CREATE TRIGGER Reviews_Trgr_OnlyAfterCheckOut
  BEFORE INSERT ON Reviews
  FOR EACH ROW 
  BEGIN 
    DECLARE t_CheckOutDate DATE;

    SELECT CheckOutDate INTO t_CheckOutDate FROM Bookings
      WHERE BookingID = NEW.BookingID;

  IF t_CheckOutDate >= NEW.ReviewDate THEN 
    SIGNAL SQLSTATE '45000'
    -- ReviewDate is a TIMESTAMP compared against a DATE at 00:00,
    -- so a review is on the checkout day itself is allowed and intended
    SET MESSAGE_TEXT = 'Cannot review a booking before check out';
  END IF;
END; -- //
-- DELIMITER ;

/* +++++++++++++++++++++++++++++++++++++++++++++++++
  DELETION TRIGGER for Pictures
 ANNOTATION: MySQL does not trigger on ON DELETE CASCADE 
    for foreign keys -> Apartment Deletion deletes all Pictures
+++++++++++++++++++++++++++++++++++++++++++++++++ */

-- An apartment must keep at least one picture: the last remaining picture cannot be deleted
-- DELIMITER //
CREATE TRIGGER Pictures_Trgr_AtLeastOnePicPerApt
  BEFORE DELETE ON Pictures
  FOR EACH ROW 
  BEGIN 
  
    DECLARE t_PictureCount INTEGER;
  
    SELECT COUNT(*) INTO t_PictureCount FROM Pictures
    WHERE ApartmentID = OLD.ApartmentID;

    -- Counted before the delete, so 1 means this row is the last one
  IF t_PictureCount = 1 THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Every apartment needs at least one picture.';
  END IF;
END; -- //
-- DELIMITER ;









