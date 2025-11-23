/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT()
    - GROUP BY, ORDER BY
===============================================================================
*/

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

