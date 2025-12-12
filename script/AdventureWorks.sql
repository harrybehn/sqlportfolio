/*
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.*/

-- Retrieve a list of all tables in the database
SELECT
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_CATALOG = 'AdventureWorks2022'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- Retrieve all columns for a specific table (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS

WHERE TABLE_NAME = 'Person';

/*
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.*/

-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(e.BirthDate) AS OldestBirthDate,
    DATEDIFF(YEAR, MIN(e.BirthDate), GETDATE()) AS OldestAge,
    MAX(e.BirthDate) AS YoungestBirthDate,
    DATEDIFF(YEAR, MAX(e.BirthDate), GETDATE()) AS YoungestAge
FROM HumanResources.Employee AS e;

-- Determine the first and last order date and the total duration in months
SELECT
    MIN(OrderDate) AS earliest_order_date,
    MAX(OrderDate) AS latest_order_date,
    DATEDIFF(MONTH, MIN(OrderDate), MAX(OrderDate)) AS date_range_months
FROM Sales.SalesOrderHeader;

/*
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.*/

-- Retrieve the list of all Product Categories and SubCategories
SELECT
    pc.Name AS ProductCategory,
    psc.Name AS ProductSubCategory
FROM Production.ProductSubcategory AS psc
LEFT JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID;

-- -- Retrieve the list of unique countries and province from which customers originate
SELECT DISTINCT
    cr.Name AS CountryRegion, st.Name AS State
FROM Sales.Customer AS sc
LEFT JOIN Person.BusinessEntityAddress AS ba 
    ON sc.CustomerID = ba.BusinessEntityID
LEFT JOIN Person.Address AS ad 
    ON ba.AddressID = ad.AddressID
LEFT JOIN Person.StateProvince AS st 
    ON ad.StateProvinceID = st.StateProvinceID
LEFT JOIN Person.CountryRegion AS cr 
    ON st.CountryRegionCode = cr.CountryRegionCode
ORDER BY CountryRegion, State

/*
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.*/

-- Find total customers by country
SELECT 
    cr.Name AS CountryRegion, 
    COUNT(DISTINCT sc.CustomerID) AS total_customers
FROM Sales.Customer AS sc
LEFT JOIN Person.BusinessEntityAddress AS ba 
    ON sc.CustomerID = ba.BusinessEntityID
LEFT JOIN Person.Address AS ad 
    ON ba.AddressID = ad.AddressID
LEFT JOIN Person.StateProvince AS st 
    ON ad.StateProvinceID = st.StateProvinceID
LEFT JOIN Person.CountryRegion AS cr 
    ON st.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY total_customers DESC;

-- Find total products by category
SELECT
    pc.Name AS ProductCategory,
    COUNT(*) AS total_products
FROM Production.Product AS p
LEFT JOIN Production.ProductSubCategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY total_products DESC;

-- Find total sales by category
SELECT
    pc.Name AS ProductCategory,
    SUM(sod.LineTotal) AS total_sales
FROM Sales.SalesOrderDetail AS sod
LEFT JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
LEFT JOIN Production.ProductSubCategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY total_sales DESC;

-- Find total sales by each customer
SELECT 
    p.FirstName, 
    p.LastName, 
    st.Name AS Store, 
    SUM(s.LineTotal) AS total_sales
FROM Sales.SalesOrderDetail AS s
LEFT JOIN Sales.SalesOrderHeader AS sh
    ON s.SalesOrderID = sh.SalesOrderID
LEFT JOIN Sales.Customer AS c
    ON sh.CustomerID = c.CustomerID
LEFT JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store AS st
    ON c.StoreID = st.BusinessEntityID
GROUP BY p.FirstName, p.LastName, st.Name
ORDER BY total_sales DESC;

/* Change Over Time Analysis
===============================================================================
SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================*/
-- Analyse sales performance over time
-- Quick Date Functions

WITH sod2 AS(
    SELECT soh.OrderDate, sod.OrderQty, sod.LineTotal, soh.CustomerID
    FROM Sales.SalesOrderDetail sod
    LEFT JOIN Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
)
SELECT
    YEAR(OrderDate) AS order_year,
    MONTH(OrderDate) AS order_month,
    SUM(LineTotal) AS total_sales,
    COUNT(DISTINCT CustomerID) AS total_customers,
    SUM(OrderQty) AS total_orderquantity
FROM sod2
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate)

--Alternative is to use:
    
--1.DATETRUNC() - output is Date
SELECT
    DATETRUNC(month, OrderDate) AS order_date,
    SUM(LineTotal) AS total_sales,
    COUNT(DISTINCT CustomerID) AS total_customers,
    SUM(OrderQty) AS total_orderquantity
GROUP BY DATETRUNC(month, OrderDate)
ORDER BY DATETRUNC(month, OrderDate)
--2.FORMAT() - output is String
SELECT
    FORMAT(OrderDate, 'yyyy-MMM') AS order_date,
    SUM(LineTotal) AS total_sales,
    COUNT(DISTINCT CustomerID) AS total_customers,
    SUM(OrderQty) AS total_orderquantity
GROUP BY FORMAT(OrderDate, 'yyyy-MMM')
ORDER BY FORMAT(OrderDate, 'yyyy-MMM')

/*Cumulative Analysis

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
-- Calculate the total sales per month 
-- and the running total of sales over time 
    
WITH sod2 AS(
    SELECT soh.OrderDate, sod.LineTotal, sod.UnitPrice
    FROM Sales.SalesOrderDetail sod
    LEFT JOIN Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
), Monthly m AS(
SELECT
    DATETRUNC(month ,OrderDate) AS order_date,
    SUM(LineTotal) AS total_sales
    AVG(UnitPrice) AS avg_price
FROM sod2
GROUP BY DATETRUNC(month ,OrderDate)
ORDER BY DATETRUNC(month ,OrderDate)
)
SELECT order_date,
       total_sales,
       SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
       AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM m

/*Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
 SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.   
=============================================================================== 
Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
    
-- JOIN Sales.SalesOrderDetail, Sales.SalesOrderHeader & ProductN.Product to get add OrderDate & Product name to SalesOrderDetails table
WITH sod2 AS(
    SELECT soh.OrderDate, sod.LineTotal, p.Name AS product_name
    FROM Sales.SalesOrderDetail sod
    LEFT JOIN Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
    LEFT JOIN Productn.Product p
    ON sod.ProductID = p.ProductID
), YearlySales ys AS(
-- Aggregate for Yearly Sales 
SELECT 
    YEAR(OrderDate) AS order_year,
    product_name,
    SUM(LineTotal) AS total_sales
FROM sod2
GROUP BY YEAR(OrderDate), product_name
), AverageSales avs AS(
-- Get the Average sales and previous sales using window function AVG() OVER() & LAG()
SELECT
    order_year,
    product_name,
    total_sales,
    AVG(total_sales) OVER (PARTITION BY product_name) AS avg_sales
    LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales 
FROM ys
)
-- compare the total sales vs the average sales and previous sales
SELECT 
    order_year,
    product_name,
    total_sales,
    CASE
        WHEN total_sales - avg_sales > 0 THEN 'Above Avg'
        WHEN total_sales - avg_sales < 0 THEN 'Below Avg' ELSE 'Avg'
    END AS vs_Avg,

    CASE
        WHEN total_sales - py_sales > 0 THEN 'Increased'
        WHEN total_sales - py_sales < 0 THEN 'Decreased' ELSE 'No change'
    END AS vs_py
FROM avs
ORDER BY product_name

/*
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
===============================================================================
Segment products into price ranges and 
count how many products fall into each segment*/
    
WITH ps AS(
SELECT
    ProductID AS product_id, Name AS product_name, ListPrice AS price,
    CASE
        WHEN price > 3000 THEN 'Above 3000'
        WHEN price >= 2000 THEN '2000 to 3000' 
        WHEN price >= 1000 THEN '1000 to 2000' ELSE 'Below 1000'
    END AS price_range
FROM Productn.Product 
)
SELECT price_range, COUNT(product_id) AS product_qty
FROM ps
GROUP BY price_category
ORDER BY COUNT(product_id) DESC







