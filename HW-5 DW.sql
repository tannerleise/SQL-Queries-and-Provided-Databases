/* MySql session has the safe-updates option set.
Turn off safe mode
Go to Edit --> Preferences.
Click "SQL Editor" tab and uncheck "Safe Updates" check box.
Query --> Reconnect to Server 
logout and then login.
Now execute your SQL query.
*/

/*DROP DATABASE HW_5_DW;*/


DROP DATABASE IF EXISTS HW_5_DW;
CREATE DATABASE HW_5_DW;

USE HW_5_DW;

DROP TABLE IF EXISTS Dim_Product;
CREATE TABLE Dim_Product
(
ProductKey INT PRIMARY KEY AUTO_INCREMENT,
ProductAltKey VARCHAR(10)NOT NULL,
ProductName VARCHAR(100)
);

INSERT INTO Dim_Product(ProductAltKey,ProductName) VALUES
('ITM-001','Wheat Flour 1kg'),
('ITM-002','Jasmine Rice 5kg'),
('ITM-003','SunFlower Oil 1 ltr'),
('ITM-004','Dawn Dish Soap, case'),
('ITM-005','Tide Laundry Detergent 1kg case');

/* old sql with ProductActualCost and ProductSalesPrice
DROP TABLE IF EXISTS Dim_Product;
CREATE TABLE Dim_Product
(
ProductKey INT PRIMARY KEY AUTO_INCREMENT,
ProductAltKey VARCHAR(10)NOT NULL,
ProductName VARCHAR(100),
ProductActualCost DECIMAL(9,2),
ProductSalesPrice DECIMAL(9,2)
);

INSERT INTO Dim_Product(ProductAltKey,ProductName, ProductActualCost, ProductSalesPrice)VALUES
('ITM-001','Wheat Flour 1kg',5.50,6.50),
('ITM-002','Jasmine Rice 5kg',22.50,24),
('ITM-003','SunFlower Oil 1 ltr',42,43.5),
('ITM-004','Dawn Dish Soap, case',18,20),
('ITM-005','Tide Laundry Detergent 1kg case',135,139);

*/

DROP TABLE IF EXISTS Dim_Store;
CREATE TABLE Dim_Store
(
StoreID INT PRIMARY KEY AUTO_INCREMENT,
StoreAltID VARCHAR(10)NOT NULL,
StoreName VARCHAR(100),
StoreLocation VARCHAR(100),
City VARCHAR(100),
State VARCHAR(100),
Country VARCHAR(100)
);

INSERT INTO Dim_Store(StoreAltID,StoreName,StoreLocation,City,State,Country )VALUES
('LOC-A1','ValueMart Boulder','1234 Ringer Road','Boulder','CO','USA'),
('LOC-A2','ValueMart Lyons','8624 Fenton Park','Lyons','CO','USA'),
('LOC-A3','ValueMart Berthoud','9337 Cherry Lane','Berthoud','CO','USA');

DROP TABLE if exists Dim_Customer;
CREATE TABLE Dim_Customer (
CustomerID INT PRIMARY KEY AUTO_INCREMENT,
CustomerAltID VARCHAR(10) NOT NULL,
CustomerName VARCHAR(50),
Gender VARCHAR(2)
);

INSERT INTO Dim_Customer(CustomerAltID,CustomerName,Gender)VALUES
('IMI-001','Harrison Ford','M'),
('IMI-002','Melinda Gates','F'),
('IMI-003','Elon Musk','M'),
('IMI-004','Aldous Huxley','M'),
('IMI-005','Linda Ronstadt','F');


DROP TABLE IF EXISTS Dim_SalesPerson; 
CREATE TABLE Dim_SalesPerson
(
SalesPersonID INT PRIMARY KEY AUTO_INCREMENT,
SalesPersonAltID VARCHAR(10)NOT NULL,
SalesPersonName VARCHAR(100),
StoreID INT,
City VARCHAR(100),
State VARCHAR(100),
Country VARCHAR(100)
);

INSERT INTO Dim_SalesPerson(SalesPersonAltID,SalesPersonName,StoreID,City,State,Country )VALUES
('SP-DMSPR1','Tom Petty',1,'Boulder','CO','USA'),
('SP-DMSPR2','John Paul Jones',1,'Longmont','CO','USA'),
('SP-DMNGR1','Danny Weller',2,'Berthoud','CO','USA'),
('SP-DMNGR2','Julian Brand',2,'Lyons','CO','USA'),
('SP-DMSVR1','Jasmin Farah',3,'Louisville','CO','USA'),
('SP-DMSVR2','Jacob Leis',3,'Lafayette','CO','USA');


-- #### Start dim_date using old script ####

DROP TABLE IF EXISTS dim_date;
CREATE TABLE Dim_Date
	(	DateKey INT PRIMARY KEY AUTO_INCREMENT, 
		DATE DATE, -- DATETIME,
		DAYOFMONTH VARCHAR(2), -- Field will hold day number of Month
		DAYNAME VARCHAR(9), -- Contains name of the day, Sunday, Monday 
		-- DayOfWeekInMonth VARCHAR(2), -- 1st Monday or 2nd Monday in Month
		-- DayOfWeekInYear VARCHAR(2),
		-- DayOfQuarter VARCHAR(3),
		DAYOFYEAR VARCHAR(3),
		-- WeekOfMonth VARCHAR(1), -- Week Number of Month 
		-- WeekOfQuarter VARCHAR(2), -- Week Number of the Quarter
		WEEKOFYEAR VARCHAR(2), -- Week Number of the Year
		MONTH VARCHAR(2), -- Number of the Month 1 to 12
		MONTHNAME VARCHAR(9), -- January, February etc
		QUARTER CHAR(1),
		-- QuarterName VARCHAR(9), -- First,Second..
		YEAR CHAR(4) -- Year value of Date stored in Row
	);
	
	-- Adapted from Tom Cunningham's 'Data Warehousing with MySql' (www.meansandends.com/mysql-data-warehouse) 
 
 ###### small-numbers table 
 DROP TABLE IF EXISTS numbers_small; 
 CREATE TABLE numbers_small (number INT); 
 INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9); 
 
 
 ###### main numbers table 
 DROP TABLE IF EXISTS numbers; 
 CREATE TABLE numbers (number BIGINT); 
 INSERT INTO numbers 
 SELECT thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number 
   FROM numbers_small thousands, numbers_small hundreds, numbers_small tens, numbers_small ones 
 LIMIT 1000000; 
 

 ###### date table 
 DROP TABLE IF EXISTS dates; 
 CREATE TABLE dates ( 
   date_id          BIGINT PRIMARY KEY,  
   DATE             DATE NOT NULL, 
   TIMESTAMP        BIGINT ,  
   weekend          CHAR(10) NOT NULL DEFAULT "Weekday", 
   day_of_week      CHAR(10) , 
   MONTH            CHAR(10) , 
   month_day        INT ,  
   YEAR             INT , 
   week_starting_monday CHAR(2) , 
   UNIQUE KEY `date` (`date`), 
   KEY `year_week` (`year`,`week_starting_monday`) 
 ); 
 

 ###### populate it with days 
 INSERT INTO dates (date_id, DATE) 
 SELECT number, DATE_ADD( '2010-01-01', INTERVAL number DAY ) 
   FROM numbers 
   WHERE DATE_ADD( '2010-01-01', INTERVAL number DAY ) BETWEEN '2010-01-01' AND '2020-01-01' 
   ORDER BY number; 
 

 ###### fill in other rows 
 UPDATE dates SET 
   TIMESTAMP =   UNIX_TIMESTAMP(DATE), 
   day_of_week = DATE_FORMAT( DATE, "%W" ), 
   weekend =     IF( DATE_FORMAT( DATE, "%W" ) IN ('Saturday','Sunday'), 'Weekend', 'Weekday'), 
   MONTH =       DATE_FORMAT( DATE, "%M"), 
   YEAR =        DATE_FORMAT( DATE, "%Y" ), 
   month_day =   DATE_FORMAT( DATE, "%d" ); 
 

UPDATE dates SET week_starting_monday = DATE_FORMAT(DATE,'%v'); 
 
INSERT INTO dim_date (DATE, DAYOFMONTH, YEAR, DAYNAME, MONTHNAME)
	SELECT DATE, month_day, YEAR, day_of_week, MONTH FROM dates;
	
UPDATE dim_date SET 
   MONTH = MONTH(DATE),
   QUARTER = QUARTER(DATE),
   DAYOFYEAR = DAYOFYEAR(DATE),
   WEEKOFYEAR = WEEKOFYEAR(DATE);
   
-- #### End dim_date using old script ####

/*
#### Start dim_date using new script ####

DROP TABLE IF EXISTS dim_date;        
CREATE TABLE dim_date
	(	DateKey INT PRIMARY KEY AUTO_INCREMENT,
		DATE DATE,
		DAYNAME VARCHAR(9), -- Contains name of the day, Sunday, Monday 
		DAYOFYEAR VARCHAR(3),
		WEEKOFYEAR VARCHAR(2), -- Week Number of the Year
		MONTH VARCHAR(2), -- Number of the Month 1 to 12
		MONTHNAME VARCHAR(9), -- January, February etc
		QUARTER CHAR(1),
		YEAR CHAR(4) -- Year value of Date stored in Row
	);

DROP PROCEDURE IF EXISTS fill_Date_Dim;
DELIMITER //
CREATE PROCEDURE fill_Date_Dim (p_start_date DATE, p_end_date DATE)
BEGIN
	DECLARE vdate DATE;
    SET vdate = p_start_date;
    WHILE vdate < p_end_date DO
    INSERT INTO dim_date VALUES 
					(
					 	default,
                        -- YEAR(vdate)*10000+MONTH(vdate)*100 + DAY(vdate),
                        vdate,
                        DATE_FORMAT(vdate,'%W'),
                        DAY(vdate),
                        WEEKOFYEAR(vdate),
                        MONTH(vdate),
                        DATE_FORMAT(vdate,'%M'),
                        QUARTER(vdate),
                        YEAR(vdate)
                    );
        SET vdate = DATE_ADD(vdate, INTERVAL 1 DAY);
    END WHILE;
END
//
DELIMITER ;

TRUNCATE TABLE dim_date;

CALL fill_Date_Dim ('2010-01-01','2020-01-01');
-- OPTIMIZE TABLE dim_date;

DROP PROCEDURE IF EXISTS fill_Date_Dim;

#### End dim_date using new script ####
*/

DROP TABLE IF EXISTS fact_productsales;
CREATE TABLE Fact_ProductSales
(
TransactionId BIGINT PRIMARY KEY AUTO_INCREMENT,
SalesInvoiceNumber INT NOT NULL,
SalesDateKey INT,
StoreID INT NOT NULL,
CustomerID INT NOT NULL,
ProductID INT NOT NULL,
SalesPersonID INT NOT NULL,
ProductCost DECIMAL(9,2),
SalesPrice DECIMAL(9,2),
Quantity INTEGER
);

INSERT INTO Fact_ProductSales VALUES 
(1,1,11,1,1,1,1,11.00,13.00,2),
(2,1,11,1,1,2,1,22.50,24.00,1),
(3,1,11,1,1,3,1,42.00,43.50,1),
(4,2,11,1,2,3,1,42.00,43.50,1),
(5,2,11,1,2,4,1,54.00,60.00,3),
(6,3,11,1,3,2,2,11.00,13.00,2),
(7,3,11,1,3,3,2,42.00,43.50,1),
(8,3,11,1,3,4,2,54.00,60.00,3),
(9,3,11,1,3,5,2,135.00,139.00,1),
(10,4,35,1,1,1,1,11.00,13.00,2),
(11,4,35,1,1,2,1,22.50,24.00,1),
(12,5,35,1,2,3,1,42.00,43.00,1),
(13,5,35,1,2,4,1,54.00,60.00,3),
(14,6,35,1,3,2,2,11.00,13.00,2),
(15,6,35,1,3,5,2,135.00,139.00,1),
(16,7,35,2,1,4,3,54.00,60.00,3),
(17,7,35,2,1,5,3,135.00,139.00,1),
(18,8,77,1,1,3,1,84.00,87.00,2),
(19,8,77,1,1,4,1,54.00,60.00,3),
(20,9,77,1,2,1,1,5.50,6.50,1),
(21,9,77,1,2,2,1,22.50,24.00,1),
(22,10,77,1,3,1,2,11.00,13.00,2),
(23,10,77,1,3,4,2,54.00,60.00,3),
(24,11,77,2,1,2,3,5.50,6.50,1),
(25,12,168,1,1,1,1,5.50,6.50,2),
(26,12,168,1,1,2,1,22.50,24.00,6),
(27,12,168,1,1,3,1,42.00,43.50,7),
(28,13,182,2,2,1,2,5.50,6.50,4),
(29,13,182,2,2,2,2,22.50,24.00,10),
(30,13,182,2,2,3,2,42.00,43.50,7),
(31,14,196,3,3,1,3,5.50,6.50,6),
(32,14,196,3,3,2,3,22.50,24.00,7),
(33,14,196,3,3,3,3,42.00,43.50,8),
(34,15,210,1,4,2,4,22.50,24.00,9),
(35,15,210,1,4,3,4,42.00,43.50,3),
(36,15,210,1,4,4,4,18.00,20.00,7),
(37,15,210,1,4,5,4,135.00,139.00,5),
(38,16,224,1,5,1,1,5.50,6.50,6),
(39,16,224,1,5,2,1,22.50,24.00,4),
(40,16,224,1,5,3,1,42.00,43.50,4),
(41,17,238,2,2,1,2,5.50,6.50,4),
(42,17,238,2,2,2,2,22.50,24.00,2),
(43,17,238,2,2,3,2,42.00,43.50,6),
(44,18,252,3,3,1,3,5.50,6.50,2),
(45,18,252,3,3,2,3,22.50,24.00,5),
(46,18,252,3,3,3,3,42.00,43.50,10),
(47,19,266,1,4,2,4,22.50,24.00,3),
(48,19,266,1,4,3,4,42.00,43.50,5),
(49,19,266,1,4,4,4,18.00,20.00,6),
(50,19,266,1,4,5,4,135.00,139.00,6),
(51,26,364,1,1,2,1,22.50,24.00,3),
(52,26,364,1,1,4,1,18.00,20.00,7),
(53,26,364,1,1,5,1,135.00,139.00,6),
(54,27,378,2,5,1,2,5.50,6.50,7),
(55,27,378,2,5,2,2,22.50,24.00,8),
(56,27,378,2,5,3,2,42.00,43.50,9),
(57,28,392,3,3,1,3,5.50,6.50,1),
(58,28,392,3,3,2,3,22.50,24.00,6),
(59,28,392,3,3,3,3,42.00,43.50,1),
(60,29,406,1,4,1,4,5.50,6.50,1),
(61,29,406,1,4,2,4,22.50,24.00,7),
(62,29,406,1,4,3,4,42.00,43.50,9),
(63,29,406,1,4,5,4,135.00,139.00,4),
(64,42,462,1,1,1,1,5.50,6.50,4),
(65,42,462,1,1,2,1,22.50,24.00,7),
(66,42,462,1,1,3,1,42.00,43.50,5),
(67,43,473,2,2,1,2,5.50,6.50,2),
(68,43,473,2,2,2,2,22.50,24.00,4),
(69,43,473,2,2,3,2,42.00,43.50,7),
(70,44,484,3,5,1,3,5.50,6.50,1),
(71,44,484,3,5,2,3,22.50,24.00,4),
(72,44,484,3,5,3,3,42.00,43.50,8),
(73,45,495,1,4,2,4,22.50,24.00,9),
(74,45,495,1,4,3,4,42.00,43.50,10),
(75,45,495,1,4,4,4,18.00,20.00,1),
(76,45,495,1,4,5,4,135.00,139.00,6),
(77,46,506,1,1,1,1,5.50,6.50,8),
(78,46,506,1,1,2,1,22.50,24.00,2),
(79,46,506,1,1,3,1,42.00,43.50,4),
(80,47,517,2,2,1,2,5.50,6.50,6),
(81,47,517,2,2,2,2,22.50,24.00,7),
(82,47,517,2,2,3,2,42.00,43.50,7),
(83,48,528,3,3,1,3,5.50,6.50,4),
(84,48,528,3,3,2,3,22.50,24.00,8),
(85,48,528,3,3,3,3,42.00,43.50,10),
(86,49,539,1,4,2,4,22.50,24.00,4),
(87,49,539,1,4,3,4,42.00,43.50,2),
(88,49,539,1,4,4,4,18.00,20.00,9),
(89,49,539,1,4,5,4,135.00,139.00,8),
(90,56,616,1,1,2,1,22.50,24.00,2),
(91,56,616,1,1,4,1,18.00,20.00,7),
(92,56,616,1,1,5,1,135.00,139.00,9),
(93,57,627,2,2,1,2,5.50,6.50,3),
(94,57,627,2,2,2,2,22.50,24.00,8),
(95,57,627,2,2,3,2,42.00,43.50,1),
(96,58,638,3,3,1,3,5.50,6.50,1),
(97,58,638,3,3,2,3,22.50,24.00,9),
(98,58,638,3,3,3,3,42.00,43.50,5),
(99,59,649,1,4,1,4,5.50,6.50,8),
(100,59,649,1,4,2,4,22.50,24.00,7),
(101,59,649,1,4,3,4,42.00,43.50,8),
(102,59,649,1,4,5,4,135.00,139.00,1),
(103,72,720,1,1,1,4,5.50,6.50,1),
(104,72,720,1,1,2,4,22.50,24.00,2),
(105,72,720,1,1,3,4,42.00,43.50,8),
(106,73,730,2,2,1,2,5.50,6.50,4),
(107,73,730,2,2,2,2,22.50,24.00,3),
(108,73,730,2,2,3,2,42.00,43.50,6),
(109,74,740,3,3,1,3,5.50,6.50,1),
(110,74,740,3,3,2,3,22.50,24.00,7),
(111,74,740,3,3,3,3,42.00,43.50,1),
(112,75,750,1,4,2,5,22.50,24.00,2),
(113,75,750,1,4,3,5,42.00,43.50,7),
(114,75,750,1,4,4,5,18.00,20.00,1),
(115,75,750,1,4,5,5,135.00,139.00,6),
(116,76,760,1,1,1,1,5.50,6.50,3),
(117,76,760,1,1,2,1,22.50,24.00,9),
(118,76,760,1,1,3,1,42.00,43.50,6),
(119,77,770,2,2,1,2,5.50,6.50,1),
(120,77,770,2,2,2,2,22.50,24.00,8),
(121,77,770,2,2,3,2,42.00,43.50,6),
(122,78,780,3,3,1,3,5.50,6.50,7),
(123,78,780,3,3,2,3,22.50,24.00,5),
(124,78,780,3,3,3,3,42.00,43.50,5),
(125,79,790,1,4,2,5,22.50,24.00,2),
(126,79,790,1,4,3,5,42.00,43.50,4),
(127,79,790,1,4,4,5,18.00,20.00,5),
(128,79,790,1,4,5,5,135.00,139.00,4),
(129,86,860,1,5,2,1,22.50,24.00,4),
(130,86,860,1,5,4,1,18.00,20.00,7),
(131,86,860,1,5,5,1,135.00,139.00,4),
(132,87,870,2,2,1,2,5.50,6.50,10),
(133,87,870,2,2,2,2,22.50,24.00,7),
(134,87,870,2,2,3,2,42.00,43.50,4),
(135,88,880,3,3,1,6,5.50,6.50,1),
(136,88,880,3,3,2,6,22.50,24.00,10),
(137,88,880,3,3,3,3,42.00,43.50,7),
(138,89,890,1,4,1,4,5.50,6.50,7),
(139,89,890,1,4,2,4,22.50,24.00,3),
(140,89,890,1,4,3,4,42.00,43.50,3),
(141,89,890,1,4,5,4,135.00,139.00,5),
(142,102,1020,1,1,1,1,5.50,6.50,9),
(143,102,1020,1,1,2,1,22.50,24.00,9),
(144,102,1020,1,1,3,1,42.00,43.50,9),
(145,103,1030,2,2,1,2,5.50,6.50,6),
(146,103,1030,2,2,2,2,22.50,24.00,5),
(147,103,1030,2,2,3,2,42.00,43.50,8),
(148,104,1040,3,3,1,3,5.50,6.50,3),
(149,104,1040,3,3,2,3,22.50,24.00,1),
(150,104,1040,3,3,3,3,42.00,43.50,3),
(151,105,1050,1,4,2,4,22.50,24.00,3),
(152,105,1050,1,4,3,4,42.00,43.50,7),
(153,105,1050,1,4,4,4,18.00,20.00,7),
(154,105,1050,1,4,5,4,135.00,139.00,3),
(155,106,1060,1,5,1,1,5.50,6.50,3),
(156,106,1060,1,5,2,1,22.50,24.00,7),
(157,106,1060,1,5,3,1,42.00,43.50,4),
(158,107,1070,2,2,1,2,5.50,6.50,2),
(159,107,1070,2,2,2,2,22.50,24.00,5),
(160,107,1070,2,2,3,2,42.00,43.50,9),
(161,108,1080,3,3,1,6,5.50,6.50,2),
(162,108,1080,3,3,2,6,22.50,24.00,4),
(163,108,1080,3,3,3,6,42.00,43.50,3),
(164,109,1090,1,4,2,4,22.50,24.00,2),
(165,109,1090,1,4,3,4,42.00,43.50,2),
(166,109,1090,1,4,4,4,18.00,20.00,2),
(167,109,1090,1,4,5,4,135.00,139.00,6),
(168,116,1160,1,1,2,5,22.50,24.00,3),
(169,116,1160,1,1,4,5,18.00,20.00,5),
(170,116,1160,1,1,5,5,135.00,139.00,9),
(171,117,1170,2,2,1,2,5.50,6.50,8),
(172,117,1170,2,2,2,2,22.50,24.00,2),
(173,117,1170,2,2,3,2,42.00,43.50,6),
(174,118,1180,3,3,1,6,5.50,6.50,3),
(175,118,1180,3,3,2,6,22.50,24.00,8),
(176,118,1180,3,3,3,6,42.00,43.50,3),
(177,119,1190,1,4,1,4,5.50,6.50,1),
(178,119,1190,1,4,2,4,22.50,24.00,3),
(179,119,1190,1,4,3,4,42.00,43.50,5),
(180,120,1200,1,4,5,4,135.00,139.00,4),
(181,202,2222,1,1,1,1,5.50,6.50,6),
(182,202,2222,1,1,2,1,22.50,24.00,9),
(183,202,2222,1,1,3,1,42.00,43.50,8),
(184,203,2233,2,2,1,2,5.50,6.50,1),
(185,203,2233,2,2,2,2,22.50,24.00,2),
(186,203,2233,2,2,3,2,42.00,43.50,8),
(187,204,2244,3,3,1,3,5.50,6.50,5),
(188,204,2244,3,3,2,3,22.50,24.00,8),
(189,204,2244,3,3,3,3,42.00,43.50,5),
(190,205,2255,1,4,2,4,22.50,24.00,2),
(191,205,2255,1,4,3,4,42.00,43.50,6),
(192,205,2255,1,4,4,4,18.00,20.00,4),
(193,205,2255,1,4,5,4,135.00,139.00,3),
(194,206,2266,1,5,1,1,5.50,6.50,1),
(195,206,2266,1,5,2,1,22.50,24.00,5),
(196,206,2266,1,5,3,1,42.00,43.50,2),
(197,207,2277,2,2,1,2,5.50,6.50,7),
(198,207,2277,2,2,2,2,22.50,24.00,8),
(199,207,2277,2,2,3,2,42.00,43.50,8),
(200,208,2288,3,3,1,6,5.50,6.50,6),
(201,208,2288,3,3,2,6,22.50,24.00,6),
(202,208,2288,3,3,3,6,42.00,43.50,1),
(203,209,2299,1,4,2,4,22.50,24.00,8),
(204,209,2299,1,4,3,4,42.00,43.50,5),
(205,209,2299,1,4,4,4,18.00,20.00,2),
(206,209,2299,1,4,5,4,135.00,139.00,5),
(207,216,2376,1,1,2,5,22.50,24.00,1),
(208,216,2376,1,1,4,5,18.00,20.00,8),
(209,216,2376,1,1,5,5,135.00,139.00,6),
(210,217,2387,2,2,1,2,5.50,6.50,6),
(211,217,2387,2,2,2,2,22.50,24.00,1),
(212,217,2387,2,2,3,2,42.00,43.50,7),
(213,218,2398,3,3,1,6,5.50,6.50,3),
(214,218,2398,3,3,2,6,22.50,24.00,3),
(215,218,2398,3,3,3,6,42.00,43.50,6),
(216,219,2409,1,4,1,4,5.50,6.50,1),
(217,219,2409,1,4,2,4,22.50,24.00,8),
(218,219,2409,1,4,3,4,42.00,43.50,8),
(219,220,2420,1,4,5,4,135.00,139.00,5),
(220,342,2052,1,1,1,1,5.50,6.50,9),
(221,342,2052,1,1,2,1,22.50,24.00,1),
(222,342,2052,1,1,3,1,42.00,43.50,9),
(223,343,2058,2,2,1,2,5.50,6.50,10),
(224,343,2058,2,2,2,2,22.50,24.00,3),
(225,343,2058,2,2,3,2,42.00,43.50,5),
(226,344,2064,3,3,1,3,5.50,6.50,5),
(227,344,2064,3,3,2,3,22.50,24.00,9),
(228,344,2064,3,3,3,3,42.00,43.50,2),
(229,345,2070,1,4,2,4,22.50,24.00,4),
(230,345,2070,1,4,3,4,42.00,43.50,3),
(231,345,2070,1,4,4,4,18.00,20.00,2),
(232,345,2070,1,4,5,4,135.00,139.00,3),
(233,346,2076,1,5,1,1,5.50,6.50,10),
(234,346,2076,1,5,2,1,22.50,24.00,9),
(235,346,2076,1,5,3,1,42.00,43.50,4),
(236,347,2082,2,2,1,2,5.50,6.50,5),
(237,347,2082,2,2,2,2,22.50,24.00,4),
(238,347,2082,2,2,3,2,42.00,43.50,2),
(239,348,2088,3,3,1,6,5.50,6.50,1),
(240,348,2088,3,3,2,6,22.50,24.00,6),
(241,348,2088,3,3,3,6,42.00,43.50,9),
(242,349,2094,1,4,2,4,22.50,24.00,8),
(243,349,2094,1,4,3,4,42.00,43.50,1),
(244,349,2094,1,4,4,4,18.00,20.00,1),
(245,349,2094,1,4,5,4,135.00,139.00,4),
(246,356,2136,1,1,2,5,22.50,24.00,7),
(247,356,2136,1,1,4,5,18.00,20.00,3),
(248,356,2136,1,1,5,5,135.00,139.00,2),
(249,357,2142,2,2,1,2,5.50,6.50,3),
(250,357,2142,2,2,2,2,22.50,24.00,7),
(251,357,2142,2,2,3,2,42.00,43.50,7),
(252,358,2148,3,3,1,6,5.50,6.50,2),
(253,358,2148,3,3,2,6,22.50,24.00,2),
(254,358,2148,3,3,3,6,42.00,43.50,4),
(255,359,2154,1,4,1,4,5.50,6.50,4),
(256,359,2154,1,4,2,4,22.50,24.00,8),
(257,359,2154,1,4,3,4,42.00,43.50,8),
(258,360,2160,1,4,5,4,135.00,139.00,8),
(259,421,2526,1,1,1,1,5.50,6.50,3),
(260,421,2526,1,1,2,1,22.50,24.00,2),
(261,421,2526,1,1,3,1,42.00,43.50,2),
(262,422,2532,2,2,1,2,5.50,6.50,3),
(263,422,2532,2,2,2,2,22.50,24.00,7),
(264,422,2532,2,2,3,2,42.00,43.50,10),
(265,423,2538,3,3,1,3,5.50,6.50,6),
(266,423,2538,3,3,2,3,22.50,24.00,9),
(267,423,2538,3,3,3,3,42.00,43.50,10),
(268,424,2544,1,4,2,4,22.50,24.00,1),
(269,424,2544,1,4,3,4,42.00,43.50,5),
(270,424,2544,1,4,4,4,18.00,20.00,2),
(271,424,2544,1,4,5,4,135.00,139.00,4),
(272,425,2550,1,5,1,1,5.50,6.50,5),
(273,425,2550,1,5,2,1,22.50,24.00,5),
(274,425,2550,1,5,3,1,42.00,43.50,8),
(275,426,2556,2,2,1,2,5.50,6.50,5),
(276,426,2556,2,2,2,2,22.50,24.00,1),
(277,426,2556,2,2,3,2,42.00,43.50,7),
(278,427,2562,3,3,1,6,5.50,6.50,3),
(279,427,2562,3,3,2,6,22.50,24.00,7),
(280,427,2562,3,3,3,6,42.00,43.50,3),
(281,428,2568,1,4,2,4,22.50,24.00,3),
(282,428,2568,1,4,3,4,42.00,43.50,9),
(283,428,2568,1,4,4,4,18.00,20.00,4),
(284,428,2568,1,4,5,4,135.00,139.00,4),
(285,435,2610,1,1,2,5,22.50,24.00,6),
(286,435,2610,1,1,4,5,18.00,20.00,9),
(287,435,2610,1,1,5,5,135.00,139.00,6),
(288,436,2616,2,2,1,2,5.50,6.50,2),
(289,436,2616,2,2,2,2,22.50,24.00,5),
(290,436,2616,2,2,3,2,42.00,43.50,7),
(291,437,2622,3,3,1,6,5.50,6.50,1),
(292,437,2622,3,3,2,6,22.50,24.00,1),
(293,437,2622,3,3,3,6,42.00,43.50,10),
(294,438,2628,1,4,1,4,5.50,6.50,8),
(295,438,2628,1,4,2,4,22.50,24.00,3),
(296,438,2628,1,4,3,4,42.00,43.50,9),
(297,439,2634,1,4,5,4,135.00,139.00,7);


DROP TABLES dates, numbers, numbers_small;
DELETE FROM HW_5_DW.dim_date
WHERE DateKey NOT IN 
	(SELECT DISTINCT SalesDatekey
	FROM HW_5_DW.Fact_ProductSales 
	)
;

ALTER TABLE Fact_ProductSales ADD CONSTRAINT 
FK_StoreID FOREIGN KEY (StoreID)REFERENCES Dim_Store(StoreID);

ALTER TABLE Fact_ProductSales ADD CONSTRAINT 
FK_CustomerID FOREIGN KEY (CustomerID)REFERENCES Dim_customer(CustomerID);

ALTER TABLE Fact_ProductSales ADD CONSTRAINT 
FK_ProductKey FOREIGN KEY (ProductID)REFERENCES Dim_product(ProductKey);

ALTER TABLE Fact_ProductSales ADD CONSTRAINT 
FK_SalesPersonID FOREIGN KEY (SalesPersonID)REFERENCES Dim_salesperson(SalesPersonID);

ALTER TABLE Fact_ProductSales ADD CONSTRAINT 
FK_SalesDateKey FOREIGN KEY (SalesDateKey)REFERENCES Dim_Date(DateKey);


--  Verify row counts
SELECT 'Table', 'Rows' FROM dim_customer
UNION
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION
SELECT 'dim_date', COUNT(*) FROM dim_date
UNION
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION
SELECT 'dim_salesperson', COUNT(*) FROM dim_salesperson
UNION
SELECT 'dim_store', COUNT(*) FROM dim_store
UNION
SELECT 'fact_productsales', COUNT(*) FROM fact_productsales
;

/*

--  Verify row counts
USE HW_5_DW;

SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_ROWS
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'HW_5_DW'
;

*/

