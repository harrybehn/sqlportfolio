/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the total sales
SELECT SUM(LineTotal) AS total_sales
FROM Sales.SalesOrderDetail;

-- Find how many units were sold
SELECT SUM(OrderQty) AS total_quantity
FROM Sales.SalesOrderDetail;

-- Find the average selling price
SELECT AVG(UnitPrice) AS avg_price
FROM Sales.SalesOrderDetail;

-- Find the total number of orders
SELECT COUNT(DISTINCT SalesOrderID) AS total_orders
FROM Sales.SalesOrderDetail;

-- Find the total number of unique products
SELECT COUNT(DISTINCT Name) AS total_unique_products
FROM Production.Product;

-- Find the total number of customers
SELECT COUNT(DISTINCT CustomerID) AS total_customers
FROM Sales.Customer;

-- Find the total number of customers who have placed an order
SELECT COUNT(DISTINCT CustomerID) AS customers_with_orders
FROM Sales.SalesOrderHeader;

-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(LineTotal) AS measure_value
FROM Sales.SalesOrderDetail
UNION ALL
SELECT 'Total Quantity Ordered', SUM(OrderQty)
FROM Sales.SalesOrderDetail
UNION ALL
SELECT 'Average Price', AVG(UnitPrice)
FROM Sales.SalesOrderDetail
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT SalesOrderID)
FROM Sales.SalesOrderDetail
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT Name)
FROM Production.Product
UNION ALL
SELECT 'Total Customers', COUNT(DISTINCT CustomerID)
FROM Sales.Customer