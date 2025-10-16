--1.Find the sum of sales for the month by each product, sold in Jan-2013.
-- The output should have the list of products without the 10% from the top and 10% from the bottom.
SELECT 
    x.name, x.sum_total
FROM (
    SELECT 
        p.name AS name,
        SUM(UnitPrice * (1 - UnitPriceDiscount) * OrderQty) AS sum_total,
        NTILE(10) over(order by SUM(UnitPrice * (1 - UnitPriceDiscount) * OrderQty)) n_tile
    FROM 
        sales.SalesOrderDetail sod
    JOIN 
        production.Product p ON p.ProductID = sod.ProductID
    JOIN 
        sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID 
    WHERE 
        soh.OrderDate >= '2013-01-01' AND soh.OrderDate < '2013-02-01'
    GROUP BY 
        p.name
) AS x
WHERE 
    x.n_tile not in (1,10);
---------------------------------------------------------------------------
--2.Get the cheapest products in each subcategory using the Production.Product table.
SELECT x.name, x.listprice from
	(SELECT 
	    p.name name, 
	    listprice,
	    DENSE_RANK()  OVER (PARTITION BY psc.productsubcategoryid ORDER BY listprice ASC) d_rank
	FROM
	    production.product p
	JOIN
	    production.productsubcategory psc ON p.productsubcategoryid = psc.productsubcategoryid)x
WHERE x.d_rank =1;
----------------------------------------------------------------------------
--3.Find the second by-value price for mountain bikes using Production.Product table.
SELECT
    x.listprice
FROM
    (SELECT
         name, listprice,
         DENSE_RANK() OVER (ORDER BY listprice DESC) AS d_rank
     FROM
         production.product
     WHERE
         name LIKE 'Mountain%') x
WHERE
    x.d_rank = 2
GROUP BY
    x.listprice;
---------------------------------------------------------------------------
--4. Count sales for 2013 year in slices of categories (“YoY metric”).
WITH Sales2013 AS (
    SELECT 
        pc.Name AS Category,
        EXTRACT(YEAR FROM soh.OrderDate) AS OrderYear,
        SUM(sod.UnitPrice * (1 - sod.UnitPriceDiscount) * OrderQty) AS TotalSales,
        LAG(SUM(sod.OrderQty * sod.UnitPrice), 1) OVER (PARTITION BY pc.Name ORDER BY EXTRACT(YEAR FROM soh.OrderDate)) AS PrevYearTotalSales
    FROM 
        Sales.SalesOrderHeader soh
    JOIN 
        Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN 
        Production.Product p ON sod.ProductID = p.ProductID
    JOIN 
        Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN 
        Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    WHERE 
        EXTRACT(YEAR FROM soh.OrderDate) IN (2013, 2012)
    GROUP BY 
        pc.Name, EXTRACT(YEAR FROM soh.OrderDate)
)
SELECT 
    Category AS "catname",
    TotalSales AS "sales",
    (TotalSales - PrevYearTotalSales)/PrevYearTotalSales AS "yoy"
FROM 
    Sales2013
WHERE 
    OrderYear = 2013;
-----------------------------------------------------------------------------
--5. Find the max sum of order for each day of Jan-2013 using the following tables:
SELECT 
    order_date,
    MAX(daily_sum) AS maxorder
FROM (
    SELECT 
        DATE(soh.OrderDate) AS order_date,
        SUM(sod.UnitPrice * sod.OrderQty) AS daily_sum
    FROM 
        Sales.SalesOrderHeader soh
    JOIN 
        Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    WHERE 
        DATE(soh.OrderDate) >= '2013-01-01' AND DATE(soh.OrderDate) < '2013-02-01'
    GROUP BY 
        DATE(soh.OrderDate), soh.SalesOrderID
) AS daily_orders
GROUP BY 
    order_date;
------------------------------------------------------------------------------
--6. Find the most salable product for each subcategory in Jan-2013.
SELECT 
    xx.pscname, xx.mostfreq
FROM 
    (
        SELECT 
            x.pscname AS pscname,
            ROW_NUMBER() OVER (PARTITION BY x.pscname ORDER BY x.sum_product DESC) AS row_no,
            FIRST_VALUE(x.pname) OVER (PARTITION BY x.pscname ORDER BY x.sum_product DESC) AS mostfreq
        FROM 
            (
                SELECT 
                    psc.name AS pscname,
                    p.name AS pname,
                    SUM(sod.orderqty) AS sum_product
                FROM 
                    Production.Product p
                JOIN 
                    Production.ProductSubcategory psc ON psc.productsubcategoryid = p.productsubcategoryid 
                JOIN 
                    sales.salesorderdetail sod ON sod.productid = p.productid 
                JOIN 
                    sales.salesorderheader soh ON soh.salesorderid = sod.salesorderid 
                WHERE 
                    soh.orderdate <= '2013-01-31' AND soh.orderdate >= '2013-01-01'
                GROUP BY 
                    psc.name, p.name
            ) x
    ) xx
WHERE 
    xx.row_no = 1;
-----------------------------------------------------------------------------
--Done :) 





























