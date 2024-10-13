

--SuperMarket Analysis SQL Portfolio Project

/*

Database Setup and table creation.

1) Database Creation: Create database named `SuperMarket_Analysis`.

2) Table Creation: Two tables namely `sales_sm` and `customers_sm` are created by importing the 'Sales' and 'Customers' csv files for further 
analysis.
	The `sales_sm` table structure includes columns for transaction ID, sale date, sale time, customer type, gender, product category, payment mode,
per unit price, quantity sold, cost of goods sold (COGS), tax 5%, and total sale amount.
	The `customers_sm` table structure includes columns for transaction ID, branch, city, gender, rating.
 
3) Later, create two staged tables `sales_sma` and `customers_sma` and same are used in this project for further analysis.

Added new column `rowid` for both the staging tables and set it as a primary key.

**Database**: SuperMarket_Analysis
**Tables Used**: `sales_sma` and 'customers_sma'

*/

-------------------------------------------------------------------------------------
-- Database Creation

CREATE DATABASE SuperMarket_Analysis
GO

--Create 'Sales' staging table:

SELECT *
INTO sales_sma
FROM sales_sm
WHERE 1=2
GO

INSERT INTO sales_sma
SELECT *
FROM sales_sm
GO

SELECT * FROM sales_sma
GO

--Create 'Customers' staging table

SELECT *
INTO customers_sma
FROM customers_sm
GO

SELECT * FROM customers_sma
GO


--Add new column 'rowid' in both the tables and set it as primary key.

ALTER TABLE sales_sma
ADD rowid INT IDENTITY(1,1) PRIMARY KEY NOT NULL
GO

ALTER TABLE customers_sma
ADD rowid INT IDENTITY(1,1) PRIMARY KEY NOT NULL
GO

----------------------------------------------------------------------------
--Data Exploration & Cleaning
--Record Count- Determine the total number of records in the dataset.
SELECT COUNT(*) FROM sales_sma
GO
SELECT COUNT(*) FROM customers_sma
GO

--Category Count- Identify all unique product categories in the dataset.
SELECT DISTINCT product FROM sales_sma
GO

--Customer Count- Identify all member/non-member customer types in the dataset.
SELECT DISTINCT customer_type
     , COUNT(*) total_customer_type
FROM sales_sma
GROUP BY customer_type 

--Null Value Check- Check for any null values in the dataset. 

SELECT * FROM sales_sma
WHERE tid IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_type IS NULL OR gender IS NULL
OR product IS NULL OR payment_mode IS NULL OR payment_mode IS NULL OR unit_price IS NULL OR quantity IS NULL OR cogs IS NULL
OR tax5 IS NULL OR total_sales IS NULL

--Auto populate the null values with the available data and verify

UPDATE sales_sma
SET total_sales = cogs + tax5
WHERE total_sales IS NULL
GO

--Delete rest of the null values with missing data which cannot be calculated any further.

DELETE FROM sales_sma
WHERE total_sales IS NULL
GO

---------------------------------------------------------------------------
--Data analysis and findings to answer specific business related questions:

--Q1) Retrieve all columns for transactions made on '2019-02-14' where the total sale is greater than 300.

SELECT *
 FROM sales_sma
 WHERE sale_date = '2019-02-14' 
    And 
       total_sales > 300
 GO	


--Q2) Find total number of transactions for each product category based on gender.

SELECT gender
	 , product
	 , COUNT(*) total_transcations
from sales_sma
GROUP BY gender
	   , product
ORDER BY 1, 3 DESC
GO


--Q3) Calculate the total sales and total transactions for each product category.

SELECT product
     , SUM(total_sales) as TotalSales
	 , count(*) as TotalTransactions
FROM sales_sma
GROUP BY product
GO

--Q4) Retrieve all transactions where the PRODUCT category is 'Electronics' and the quantity sold is more than 6 in the month of March-2019


SELECT * FROM sales_sma
WHERE product LIKE 'ELECT%' 
	AND quantity > 6
	AND sale_date BETWEEN '2019-03-01' AND '2019-03-31'
GO


--Q5) Find the top 5 customers based on the highest total sale

SELECT TOP 5 *
FROM sales_sma
ORDER BY total_sales DESC
GO

--Q6) Find most frequently used payment mode

SELECT payment_mode
     , gender
	 , COUNT(*) used_frequency
FROM sales_sma
GROUP BY payment_mode
       , gender
ORDER BY 3 DESC
GO


--Q7) Find highest rated product in each category 

SELECT T1.product
     , MAX(T2.rating)
FROM 
	  sales_sma T1
JOIN  customers_sma T2
ON    T1.rowid = T2.rowid
GROUP BY T1.product
GO


--Q8) Find average sales wrt branch in each city with highest being at the top. 

SELECT T1.city
     , T1.branch
	 , ROUND(AVG(T2.total_sales),2) avg_sales
FROM 
	 customers_sma T1
JOIN sales_sma T2
ON   T1.rowid = T2.rowid
GROUP BY T1.city
       , T1.branch
ORDER BY 3 DESC
GO


--Q9) Find number of orders during each shift (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales
AS(
	SELECT *
	  ,	CASE
			WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
			WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
			ELSE 'Evening'
		END shift
	FROM sales_sma 
)
SELECT shift
     , COUNT(*) total_orders
FROM hourly_sales
GROUP BY shift
ORDER BY shift ASC
GO


--Q10) Calculate an average sale for each month along with best selling month at the top.


SELECT sale_month
     , avg_sale
FROM(
		SELECT DATENAME(MONTH, sale_date) sale_month
			 , AVG(total_sales) avg_sale
			 , RANK() OVER(
							PARTITION BY DATENAME(MONTH, sale_date) 
							ORDER BY AVG(total_sales) DESC
						  ) as rank
		FROM sales_sma
		GROUP BY sale_date, total_sales
	) AS T1
WHERE rank = 1 
GO


--Thank You!
--The End--
