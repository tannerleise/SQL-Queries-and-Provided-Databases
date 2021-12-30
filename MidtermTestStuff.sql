select * from CustomerTbl;
select * from OrderTbl;

-- 1
select FirstName,LastName, C.JobTitle from CustomerTbl C
where Customer_ID NOT IN (select Customer_ID from OrderTbl O where C.Customer_ID = O.Customer_ID);

-- 2
select C.FirstName,C.LastName,O.Shipping_Company,O.Order_Date 
from CustomerTbl C, OrderTbl O
where C.Customer_ID = O.Customer_ID AND
Order_date > '2019-08-31';

-- 3 
select Shipping_company, Order_Date,  
RANK() OVER(Order By Order_Date DESC) as 'Rank'
from OrderTbl O;

-- 4
select C.FirstName,C.LastName,O.Shipping_Company
from CustomerTbl C, OrderTbl O
where FirstName like '%a' AND
	  C.Customer_ID = O.Customer_ID
ORDER BY Order_Date DESC;


-- 5 
select shipping_company, count(*) as count
	from OrderTbl
group by shipping_company
having count(*) > 2;


   
   