/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
    - JOIN
===============================================================================
*/

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