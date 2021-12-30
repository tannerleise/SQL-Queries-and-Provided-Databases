-- 1 Show a list of Customer Name, Gender, Sales Person’s Name and Sales Person's City for 
-- all products sold on September 2015, whose Sales Price is more than 20 and Quantity sold is more than 8.

USE HW_5_DW;

SELECT 
    CustomerName, Gender, SalesPersonName, City
FROM
    fact_productsales
        INNER JOIN
    dim_customer ON dim_customer.CustomerID = fact_productsales.CustomerID
        INNER JOIN
    dim_salesperson ON fact_productsales.SalesPersonID = dim_salesperson.SalesPersonID
        INNER JOIN
    dim_date ON (dim_date.DateKey = fact_productsales.SalesDateKey
        AND dim_date.MonthName = 'September'
        AND dim_date.Year = '2015')
WHERE
    SalesPrice > 20 AND Quantity > 8;

-- 2. Show a list of Store Name, Store's City and Product Name for all products sold on March 2017, 
-- whose Product Cost is less than 50 and store located in 'Boulder'.
SELECT 
    StoreName, City, ProductName
FROM
    fact_productsales
        INNER JOIN
    dim_store ON (dim_store.StoreID = fact_productsales.StoreID
        AND dim_store.City = 'Boulder')
        INNER JOIN
    dim_product ON dim_product.ProductKEY = fact_productsales.ProductID
        INNER JOIN
    dim_date ON (dim_date.DateKey = fact_productsales.SalesDateKey
        AND dim_date.MonthName = 'March'
        AND dim_date.Year = '2017')
WHERE
    ProductCost < 50;

-- 3. Show a list of Top 2 Sales Person’s Name by their Total Revenue for 2017, 
-- i.e. Top 2 sales person with HIGHEST Total Revenue.
SELECT 
    SalesPersonName,
    SUM(SalesPrice) - SUM(ProductCost) AS Revenue
FROM
    fact_productsales
        INNER JOIN
    dim_salesperson ON fact_productsales.SalesPersonID = dim_salesperson.SalesPersonID
        INNER JOIN
    dim_date ON (dim_date.DateKey = fact_productsales.SalesDateKey
        AND dim_date.Year = '2017')
GROUP BY fact_productsales.SalesPersonID
ORDER BY SUM(SalesPrice) - SUM(ProductCost) DESC
LIMIT 2;


-- 4. Display a Customer Name and Total Revenue who has LOWEST Total Revenue in 2017.
select CustomerName, sum(SalesPrice) - sum(ProductCost) as Revenue
from fact_productsales
inner join dim_customer on dim_customer.CustomerID = fact_productsales.CustomerID
inner join dim_date on (dim_date.DateKey = fact_productsales.SalesDateKey AND dim_date.Year = '2017')
group by fact_productsales.customerID
order by sum(SalesPrice) - sum(ProductCost) ASC limit 2;

-- 5. Show a list of Store Name (in alphabetical order) and their 'Total Sales Price' for the year between 2010 and 2017.
select StoreName, sum(SalesPrice) as 'Total Sales Price'
from fact_productsales
INNER JOIN dim_store ON dim_store.StoreID = fact_productsales.StoreID
inner join dim_date on (dim_date.DateKey = fact_productsales.SalesDateKey AND dim_date.Year between '2010' and '2017')
group by fact_productsales.storeID
order by StoreName Asc;

-- 6. Display a list of Store Name, Product Name and their Total Profits from product name like 'Jasmine Rice' for 2010.
select StoreName, ProductName, sum(SalesPrice) as 'Total Profits'
from fact_productsales
INNER JOIN dim_store ON dim_store.StoreID = fact_productsales.StoreID
INNER JOIN dim_product  ON (dim_product.ProductKEY = fact_productsales.ProductID AND dim_product.ProductName like 'Jasmine Rice%')
inner join dim_date on (dim_date.DateKey = fact_productsales.SalesDateKey AND dim_date.Year = '2010')
group by StoreName;

-- 7. Display Total Revenue from 'ValueMart Boulder' Store for each Quarter during 2016,
--  sort your result by Quarter in chronological order.
select sum(SalesPrice) - sum(ProductCost) as 'total revenue', Quarter
from fact_productsales
INNER JOIN dim_store ON (dim_store.StoreID = fact_productsales.StoreID AND dim_store.StoreName = 'ValueMart Boulder')
inner join dim_date on (dim_date.DateKey = fact_productsales.SalesDateKey AND dim_date.Year = '2016')
group by quarter
order by quarter ASC;

-- 8. Display Customer Name and Total Sales Price for all items purchased by customers Melinda Gates and Harrison Ford.
select CustomerName, sum(SalesPrice) as 'Total Sales Price'
from fact_productsales
inner join dim_customer on (dim_customer.CustomerID = fact_productsales.CustomerID AND dim_customer.CustomerName = 'Melinda Gates' OR 
dim_customer.CustomerName = 'Harrison Ford')
group by dim_customer.CustomerID;

-- 9. Display Store Name, Sales Price and Quantity for all items sold in March 12th 2017.
select StoreName, SalesPrice, Quantity
from fact_productsales
inner join dim_date on (dim_date.DateKey = fact_productsales.SalesDateKey AND dim_date.date = '2017-03-12')
INNER JOIN dim_store ON dim_store.StoreID = fact_productsales.StoreID;


-- 10. Display Sales Person’s Name and Total Revenue for the best performing Sales Person, i.e., the Sales Person 
-- with the HIGHEST Total Revenue.
select SalesPersonName, sum(SalesPrice) - sum(ProductCost) as 'Total Revenue'
from fact_productsales 
inner join dim_salesperson on fact_productsales.SalesPersonID = dim_salesperson.SalesPersonID
inner join dim_date on dim_date.DateKey = fact_productsales.SalesDateKey
group by fact_productsales.SalesPersonID
order by sum(SalesPrice) - sum(ProductCost) DESC limit 1;

-- 11. Display the Top 3 Product Name by their HIGHEST Total Profit.
select ProductName, sum(SalesPrice)- sum(ProductCost) as 'Total Profit'
from fact_productsales 
INNER JOIN dim_product  ON (dim_product.ProductKEY = fact_productsales.ProductID)
group by ProductID
order by sum(SalesPrice) - sum(ProductCost) DESC limit 3;

-- 12. Display Year, MonthName and Total Revenue for the 1st 3 months (i.e. January, February and March) of 2017.
SELECT 
    year,
    MonthName,
    SUM(SalesPrice) - SUM(ProductCost) AS 'Total Revenue'
FROM
    fact_productsales
        INNER JOIN
    dim_date ON (dim_date.DateKey = fact_productsales.SalesDateKey
        AND (dim_date.monthname = 'January'
        OR dim_date.monthname = 'February'
        OR dim_date.monthname = 'March')
        AND dim_date.year = '2017')
GROUP BY year , monthname;

-- 13. Display Product Name, average product cost and 
-- average sales price for the products sold in 2017. Show averages rounded to 2 decimal places.

select ProductName, Round(AVG(ProductCost),2) as 'Average Product Cost', Round(AVG(SalesPrice),2) as 'Average Sales Price'
FROM fact_productsales
inner join dim_date on (dim_date.DateKey = fact_productsales.SalesDateKey AND dim_date.year = '2017')
INNER JOIN dim_product  ON (dim_product.ProductKEY = fact_productsales.ProductID)
group by ProductID;

-- 14. Display Customer Name, average sales price and average quantity for 
-- all items purchased by customer Melinda Gates. Show averages rounded to 2 decimal places.
select CustomerName, Round(AVG(SalesPrice)) as 'Average Sales Price', Round(AVG(Quantity)) as 'Average Quantity'
FROM fact_productsales
inner join dim_customer on (dim_customer.CustomerID = fact_productsales.CustomerID AND dim_customer.CustomerName = 'Melinda Gates')
group by fact_productsales.CustomerID;

-- 15. Display Store Name, Maximum sales price and Minimum sales
--  price for store located in 'Boulder' city. Show MIN / MAX rounded to 2 decimal places.
select StoreName, Round(Max(SalesPrice),2) as "Max Sales Price", Round(Min(SalesPrice),2) as "Min Sales Price"
FROM fact_productsales
INNER JOIN dim_store ON (dim_store.StoreID = fact_productsales.StoreID AND dim_store.city = 'Boulder');












