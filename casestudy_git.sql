-- CASE STUDY : Sales, Profit & Marketing Analysis
-- Description:
--   This case study analyzes product sales, profits, marketing expenses, 
--   inventory, COGS, and performance by state and market using SQL.
-- Tables Used:
--   - Fact: Contains financial metrics like sales, profit, expenses
--   - Product: Contains product information
--   - Location: Contains geographic and market data



 --- Count the number of unique states
  SELECT count( distinct state) as num_of_states FROM location;


---Count the number of 'regular' type products   
  select count(*) from product where type='regular';
  


----Total marketing spend for Product ID 1
  select sum(marketing) as total_marketing from fact
          where productid=1;


---Minimum sales value
  select min(sales) as min_sales from fact;


---Maximum cost of goods sold (COGS)
  select max(cogs) as max_cogs from fact;

  
---List all products of type 'coffee'
 select* from product where product_type='coffee';


---Records with total expenses greater than 40
  select * from fact where total_expenses>40;


---Average sales in area code 719
 select avg(sales) from fact where area_code=719;



---Total profit in the state of Colorado
   select sum (profit) as total_profit , state from fact as f
          inner join
          location as l
          on f.area_code=l.area_code    
          group by state 
          having state='colorado';
         

---Average inventory by Product ID
select avg(inventory) as avg_inven ,productid from fact
group by productid;

---List all states alphabetically
select state from location
order by state asc;

---Average budgeted profit and margin
select avg (budget_profit) AS AVG_PROFIT, 
AVG(BUDGET_MARGIN) AS AVG_MARGIN,
PRODUCTID from FACT
GROUP BY PRODUCTID
HAVING avg(budget_margin) >100;


---total sales done on a particular day
SELECT SUM(SALES) FROM FACT
WHERE DATE ='2010-01-01';


---average total expense of each product ID on an individual date
SELECT AVG(TOTAL_EXPENSES) AS AVG_EXP,DATE ,PRODUCTID
FROM FACT
GROUP BY DATE,PRODUCTID;


---Display the table using joins
SELECT F.DATE,F.PRODUCTID, F.SALES,F.PROFIT,F.AREA_CODE,
P.PRODUCT_TYPE,P.PRODUCT,L.STATE
FROM FACT F
JOIN PRODUCT P ON F.PRODUCTID=P.PRODUCTID
JOIN LOCATION L ON L.AREA_CODE=F.AREA_CODE;



--Display the rank without any gap to show the sales wise rank
SELECT ProductID, Sales,  
 DENSE_RANK() OVER (ORDER BY Sales DESC) AS Sales_Rank  
FROM Fact;


---Find the state wise profit and sales
select l.state, sum(f.profit) as total_profit,
sum(f.sales) as total_sales from fact f
join location l on f.area_code=l.area_code
group by state;


---Find the state wise profit and sales along with the productname
select sum(f.profit) , sum(f.sales), f.productid,p.product,l.state
from fact f 
join product p 
on f.productid=p.productid
join location l
on f.area_code=l.area_code
group by p.product,l.state,f.productid;


---calculate the increasedsales by 5%
select productid, sales, (sales*1.05) as increased_sales
from fact;


---Find the maximum profit along with the product ID and producttype
SELECT f.ProductID, p.Product_Type, f.Profit
FROM Fact f
JOIN Product p ON f.ProductID = p.ProductID
WHERE f.Profit = (SELECT MAX(Profit) FROM Fact);


---Create a stored procedure to fetch the result according to the product type
create procedure usp_fetchresults
(
@product_type varchar (50),
@productid int 
)
as 
begin
(
select * from product where product_type=@product_type and 
productid=@productid
)
end

execute usp_fetchresults 'coffee',1;


--check profit or loss depending upon the total expenses 
select productid,total_expenses,iif(total_expenses<60,'profit','loss') as profitorloss
from fact;



---weekly sales value using roll-up
    SELECT 
    YEAR(Date) AS Year, 
    DATEPART(WEEK, Date) AS Week, 
    Date, 
    ProductID, 
    SUM(Sales) AS TotalWeeklySales
    FROM Fact
    GROUP BY  
    GROUPING SETS (
    (YEAR(Date), DATEPART(WEEK, Date), Date, ProductID),
    (YEAR(Date), DATEPART(WEEK, Date), ProductID),
    (YEAR(Date), DATEPART(WEEK, Date)),
    (YEAR(Date))
	)
    ORDER BY Year, Week, Date, ProductID;



--Apply union and intersection operator on the tables which consist of attribute area code.
select area_code from fact
union 
select area_code from location;

select area_code from fact
intersect
select area_code from location;



---Change the product type from coffee to tea where product IDis 1 and undo it.
update product
set product_type='tea'
where productid=1;

update product 
set product_type='coffee'
where productid=1;

--Display the date, product ID and sales where total expenses are between 100 to 200
select date,productid,sales from fact
where total_expenses between 100 and 200;


---Delete the records in the Product Table for regular type
delete from product
where type='regular';

---Display the ASCII value of the fifth character from the columnProduct
SELECT Product, 
       ASCII(SUBSTRING(Product, 5, 1)) AS FifthCharASCII
FROM Product
WHERE LEN(Product) >= 5;
