# SuperMarket Analysis SQL Portfolio Project

## Project Overview

**Project Title**: Super Market Analysis  
**Database**: SuperMarket_Analysis
**Tables**: `sales_sma` and `customers_sma`

This project undergoes explore, clean, and analyze supermarket sales data. The project involves setting up a SuperMarket_Analysis sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. The dataset is from Kaggle. I then made two separate datasets from the original dataset: Sales and Customers to further perform advance analysis.

## Steps to follow

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup and table creation

- **Database Creation**: Create database named `SuperMarket_Analysis`.
- **Table Creation**: Two tables namely `sales_sm` and `customers_sm` are created by importing the Sales and Customers csv files for further analysis.
The `sales_sm` table structure includes columns for transaction ID, sale date, sale time, customer type, gender, product category, payment mode, per unit price, quantity sold, cost of goods sold (COGS), tax 5%, and total sale amount.
The `customers_sm` table structure includes columns for transaction ID, branch, city, gender, rating. Later, create two staged tables `sales_sma` and `customers_sma` and same are used in this project for further analysis.


### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Customer Count**: Identify all member/non-member customer types in the dataset.
- **Null Value Check**: Check for any null values in the dataset. Auto populate the null values with the available data and delete those with missing data.

```sql
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
GO

--Null Value Check- Check for any null values in the dataset. 

SELECT * FROM sales_sma
WHERE tid IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_type IS NULL OR gender IS NULL
OR product IS NULL OR payment_mode IS NULL OR payment_mode IS NULL OR unit_price IS NULL OR quantity IS NULL OR cogs IS NULL
OR tax5 IS NULL OR total_sales IS NULL
GO

--Auto populate the null values with the available data and verify

UPDATE sales_sma
SET total_sales = cogs + tax5
WHERE total_sales IS NULL
GO

--Delete rest of the null values with missing data which cannot be calculated any further.

DELETE FROM sales_sma
WHERE total_sales IS NULL
GO
```

### 3. Data analysis and findings to answer specific business related questions:

1. **Retrieve all columns for transactions made on '2019-02-14' where the total sale is greater than 300**:
```sql
SELECT *
FROM sales_sma
WHERE sale_date = '2019-02-14' 
    And 
      total_sales > 300
 GO
```

2. **Find total number of transactions for each product category based on gender**:
```sql
SELECT gender
     , product
     , COUNT(*) total_transcations
FROM sales_sma
GROUP BY gender
       , product
ORDER BY 1, 3 DESC
GO
```

3. **Calculate the total sales and total transactions for each product category**:
```sql
SELECT product
     , SUM(total_sales) as TotalSales
     , count(*) as TotalTransactions
FROM sales_sma
GROUP BY product
GO
```

4. **Retrieve all transactions where the PRODUCT category is 'Electronics' and the quantity sold is more than 6 in the month of March-2019**:
```sql
SELECT * FROM sales_sma
WHERE product LIKE 'ELECT%' 
  AND quantity > 6
  AND sale_date BETWEEN '2019-03-01' AND '2019-03-31'
GO
```

5. **Find the top 5 customers based on the highest total sale**:
```sql
SELECT TOP 5 *
FROM sales_sma
ORDER BY total_sales DESC
GO
```

6. **Find most frequently used payment mode**:
```sql
SELECT payment_mode
     , gender
     , COUNT(*) used_frequency
FROM sales_sma
GROUP BY payment_mode
       , gender
ORDER BY 3 DESC
GO
```

7. **Find highest rated product in each category**:
```sql
SELECT T1.product
     , MAX(T2.rating)
FROM
  sales_sma T1
JOIN
  customers_sma T2
ON    T1.rowid = T2.rowid
GROUP BY T1.product
GO
```

8. **Find average sales wrt branch in each city with highest being at the top**:
```sql
SELECT T1.city
     , T1.branch
     , ROUND(AVG(T2.total_sales),2) avg_sales
FROM 
  customers_sma T1
JOIN
  sales_sma T2
ON T1.rowid = T2.rowid
GROUP BY T1.city
       , T1.branch
ORDER BY 3 DESC
GO
```

9. **Find number of orders during each shift (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sales
AS
(
	SELECT *
             , CASE
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
```

10. **Calculate an average sale for each month along with best selling month at the top**:
```sql
SELECT YEAR(sale_date) sale_year
     , DATENAME(MONTH, sale_date) sale_month
     , AVG(total_sales) avg_sales
FROM sales_sma
GROUP BY YEAR(sale_date)
       , DATENAME(MONTH, sale_date)
ORDER BY AVG(total_sales) DESC	
GO
```

## Findings

- **Customer Demographics**
- **High-Value Transactions**
- **Sales Trends**
- **Customer Insights**

## Reports

- **Sales Summary**
- **Trend Analysis**
- **Customer Insights**

## Conclusion

This project covers database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The project findings can help drive business decisions by understanding sales patterns and trends, customer purchase and spending behavior, and product performance. 

## Data Visualization in Tableau

The cleaned SQL result set was gathered and imported into Tableau; after which the raw data was ready for a visual analysis to produce reports, charts, and interactive dashboards that provided supermarket sales insights.

Link to Tableau Dashboard: https://shorturl.at/z0M63


## Author - Neelam Chaudhari

This project is part of my SQL portfolio.

### Links

- **LinkedIn**: (https://www.linkedin.com/in/neelamrc)
- **Tableau**: (https://public.tableau.com/app/profile/neelamrc)

Thank you!
