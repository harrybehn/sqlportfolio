/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

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