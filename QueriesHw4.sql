-- 1 Show a list the Company Name and Country for all Suppliers located in Japan or Germany.
USE HW_4_SQL;
SELECT 
    companyName, Country
FROM
    HwSuppliers
WHERE
    country = 'Japan' OR country = 'Germany';

-- 2 Show a list of Product Name, Quantity per Unit and Unit Price for products with a Unit Price less than $7 but more than $ 4.
SELECT 
    ProductName, QuantityPerUnit, UnitPrice
FROM
    HwProducts
WHERE
    UnitPrice < 7 AND UnitPrice > 4;

-- 3 Show a list of Company Name, 
-- City and Country for Customers whose Country is USA and City is Portland OR Country is Canada and City is Vancouver.
SELECT 
    CompanyName, City, Country
FROM
    HwCustomers
WHERE
    Country = 'USA' AND City = 'Portland'
        OR Country = 'Canada'
        AND City = 'Vancouver';

-- 4 Show a list the Contact Name and Contact Title for 
-- all Suppliers with a SupplierID from 5 to 8 (inclusive) and sort in descending order by ContactName.
SELECT 
    ContactName, ContactTitle
FROM
    HwSuppliers
WHERE
    SupplierID BETWEEN 5 AND 8
ORDER BY SupplierID DESC;

-- 5 Show a product name and unit price of the least expensive 
-- product (i.e. lowest unit price)? You MUST use a Sub Query.
SELECT 
    ProductName,
    (SELECT 
            MIN(UnitPrice)
        FROM
            HwOrderDetails
        WHERE
            ProductID = HwProducts.ProductID) AS 'Lowest Unit Price'
FROM
    HwProducts
ORDER BY UnitPrice ASC
LIMIT 1;

-- 6 Display Order Count by their Ship Country for all except 
-- USA for Shipped Date between May 4th and 10th 2015 whose Order Count is greater than 3.

SELECT 
    ShippedDate, ShipCountry, COUNT(*) AS OrderCount
FROM
    HwOrders
WHERE
    NOT ShipCountry = 'USA'
        AND ShippedDate BETWEEN '2015-05-04' AND '2015-05-10'
GROUP BY ShipCountry
HAVING OrderCount > 3;

-- 7 Show a list of all employees with their first name, last name and hiredate 
-- (formated to mm/dd/yyyy) who are NOT living in the USA and have been employed for at least 5 years.

SELECT 
    Country,
    FirstName,
    LastName,
    DATE_FORMAT(HireDate, '%m/%d/%Y') AS DateHire
FROM
    HwEmployees
WHERE
    NOT Country = 'USA'
        AND YEAR(HireDate) < (YEAR(CURRENT_DATE) - 5);-- Possibly check logic so month is looked at as well


-- 8) Show a list of Product Name and their 'Inventory Value' (Inventory Value = units in stock multiplied by their unit price) 
-- for products whose 'Inventory Value' is over 3000 but less than 4000.
SELECT 
    ProductName, UnitsInStock * UnitPrice AS 'Inventory Value'
FROM
    HwProducts
WHERE
    UnitsInStock * UnitPrice BETWEEN 3000 AND 4000;

-- 9) Show a list of Products' product Name, Unit in Stock and ReorderLevel level whose Product Name starts with 'S' 
-- that are currently in stock (i.e. at least one Unit in Stock) and inventory level is at or below the reorder level.

SELECT 
    ProductName, UnitsInStock, ReOrderLevel
FROM
    HwProducts
WHERE
    ProductName LIKE 's%'
        AND UnitsInStock > 0
        AND UnitsInStock <= ReOrderLevel;


-- 10) Show a Product Name, Unit Price for all products, whose Quantity Per Unit
-- has/measure in 'box' that have been discontinued (i.e. discontinued = 1).

SELECT 
    ProductName, UnitPrice
FROM
    HwProducts
WHERE
    QuantityPerUnit LIKE '%box%'
        AND Discontinued = 1;
    
-- 11) Show a list of Product Name and their TOTAL 
-- inventory value (inventory value = UnitsInStock * UnitPrice) for Supplier's Country from Japan.
SELECT 
    ProductName, UnitsInStock * UnitPrice AS 'Inventory Value'
FROM
    hwProducts
WHERE
    SupplierID = (SELECT 
            SupplierID
        FROM
            HwSuppliers
        WHERE
            Country = 'Japan'
                AND hwProducts.SupplierID = hwSuppliers.SupplierID);
-- Note To Self) Subquery Above finds where SupplierID's county is Japan. Then it matches the IDs in the two tables to match them up

-- 12. Show a list country and their customer's count that is greater than 8.
SELECT 
    Country, COUNT(*) AS CustomerCount
FROM
    HwCustomers
GROUP BY Country
HAVING CustomerCount > 8;

-- 13) Show a list of Orders' Ship Country, Ship City and 
-- their Order count for Ship Country 'Austria' and 'Argentina'.

SELECT 
    ShipCountry, ShipCity, COUNT(*) AS OrderCount
FROM
    HwOrders
GROUP BY shipcountry
HAVING ShipCountry = 'Austria'
    OR ShipCountry = 'Argentina';

-- 14. Show a list of Supplier's Company Name and Product's 
-- Product Name for supplier's country from Spain.

SELECT 
    HwProducts.ProductName, HwSuppliers.CompanyName
FROM
    HwProducts,
    HwSuppliers
WHERE
    hwProducts.SupplierID = hwSuppliers.SupplierID
        AND HwSuppliers.Country = 'Spain';
    
-- 15. What is the 'Average Unit Price' (rounded to two decimal places) of all 
-- the products whose ProductName ends with 'T'?

SELECT 
    ProductName, ROUND(AVG(UnitPrice), 2) as AverageUnitPrice
FROM
    HwProducts
WHERE
    ProductName LIKE '%T';
    
-- 16. Show a list of employee's full name (i.e. firstname, lastname), title and their 
-- Order count for employees who has more than 120 orders.


SELECT 
    COUNT(HwOrders.OrderID) AS OrderCount,
    HwEmployees.FirstName,
    HwEmployees.LastName,
    HwEmployees.title
FROM
    HwOrders,
    HwEmployees
WHERE
    HwEmployees.EmployeeID = HwOrders.EmployeeID
GROUP BY HwEmployees.EmployeeID
HAVING OrderCount > 120;
    
-- 17)Show a list customer's company Name and their country who 
-- has NO Orders on file (i.e. NULL Orders).
SELECT 
    CompanyName, Country
FROM
    HwCustomers
WHERE
    CustomerID NOT IN (SELECT 
            CustomerID
        FROM
            HwOrders);
 -- select Distinct CustomerID from HwCustomers;
 
 -- 18. Show a list of Category Name and Product Name for all products that are currently out of stock (i.e. UnitsInStock = 0).
SELECT 
    ProductName,
    (SELECT 
            CategoryName
        FROM
            HwCategories
        WHERE
            HwCategories.CategoryID = HwProducts.CategoryID) AS CategoryName
FROM
    HwProducts
WHERE
    UnitsInStock = 0;

-- 19) Show a list of products' Product Name and Quantity Per Unit, which are measured in 'pkg' or 
-- 'pkgs' or 'jars' for a supplier’s country from Japan.
SELECT 
    ProductName, QuantityPerUnit
FROM
    HwProducts
WHERE
    QuantityPerUnit LIKE '%pkg%'
        OR QuantityPerUnit LIKE '%jars%'
        OR QuantityPerUnit LIKE '%pkgs%'
HAVING (SELECT 
        Country
    FROM
        HwSuppliers
    WHERE
        Country = 'Japan'
            AND HwSuppliers.SupplierID = HwProducts.SupplierID) IS NOT NULL;
-- 20) Show a list of customer's company name, their Order’s ship name and total value of all their orders 
-- (rounded to 2 decimal places) for customer's from Mexico. (value of order = (UnitPrice multiplied by Quantity) less discount).

SELECT
    CompanyName,
    Country,
    ShipName,
    ROUND(SUM((UnitPrice * quantity) - discount), 2) AS TotalValue
FROM
    HwCustomers
        INNER JOIN
    HwOrders ON HwCustomers.CustomerID = HwOrders.CustomerID
        INNER JOIN
    HwOrderDetails ON HwOrders.OrderID = HwOrderDetails.OrderID
GROUP BY CompanyName
HAVING Country = 'Mexico';

-- 21) Show a list of products' Product Name and suppliers' Region whose product 
-- name starts with 'L' and Region is NOT blank/empty.

SELECT 
    ProductName, Region
FROM
    HwProducts
        INNER JOIN
    HwSuppliers ON HwProducts.SupplierID = HwSuppliers.SupplierID
WHERE
    ProductName LIKE 'L%' AND Region != '';
   
    -- 22) Show a list of Order's Ship Country, Ship Name and Order Date (formatted as MonthName and Year, e.g. March 2015) 
SELECT 
    ShipCountry,
    ShipName,
    DATE_FORMAT(OrderDate, '%M %Y') AS OrderDate
FROM
    HwOrders
WHERE
    ShipCity = 'Versailles'
        AND CustomerID NOT IN (SELECT 
            CustomerID
        FROM
            HwCustomers);
          
-- 23) Show a list of products' Product Name and Units In Stock whose Product Name starts with 'F' and Rank them based on 
-- UnitsInStock from highest to lowest (i.e. highest UnitsInStock rank = 1, and so on). Display rank number as well.

select ProductName, UnitsInStock, 
Rank() over(Order By UnitsInStock DESC) as 'Rank'
from HwProducts
where ProductName like 'F%';

-- 24) Show a list of products' Product Name and Unit Price for ProductID from 1 to 5 (inclusive)
-- and Rank them based on UnitPrice from lowest to highest. Display rank number as well.
select ProductName, UnitPrice, 
Rank() OVER(ORDER BY UnitPrice ASC) as 'Rank'
from HwProducts
where ProductID between 1 and 5;

-- 25) Show a list of employees' first name, last name, country and date of birth (formatted to mm/dd/yyyy) 
-- who were born after 1984 and Rank them by date of birth (oldest employee rank 1st, and so on) for EACH country, 
-- i.e. Rank number should reset/restart for EACH country.

select FirstName, LastName, Country, DATE_FORMAT(BirthDate,'%m/%d/%Y') as Birthdate,
Rank() Over(PARTITION BY Country
			ORDER BY YEAR(BirthDate) ASC) as 'Rank'
from HwEmployees
where YEAR(BirthDate) > 1984;






