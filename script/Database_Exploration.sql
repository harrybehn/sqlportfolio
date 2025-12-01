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

