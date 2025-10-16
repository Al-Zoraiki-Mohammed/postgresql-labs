-- 1.  Write an SQL query to calculate the total number of departments within 
-- each group and order the results by the number of departments in descending order.

SELECT 
		dept.groupname, COUNT(*) AS no_depts
	FROM  humanresources.department dept
	GROUP BY dept.groupname
	ORDER BY no_depts desc;
--------------------------------------------------------------
--2. Calculate the highest salary that each employee has received, using 
-- the HumanResources.EmployeePayHistory and HumanResources.Employee tables.

SELECT  
		e.businessentityid, e.jobtitle, 
		MAX(eph.rate ) AS max_salary	
	FROM humanresources.employee e
	JOIN humanresources.employeepayhistory eph
		ON e.businessentityid = eph.businessentityid 
	GROUP BY e.businessentityid
	ORDER BY max_salary desc;
----------------------------------------------------------------
--3. Find the lowest price(UnitPrice) for products within each subcategory.

SELECT
		psc.name  AS subcat_name ,p.name AS product_name,
		min(sod.unitprice) AS min_price
	FROM Sales.SalesOrderDetail sod
	JOIN production.product p 
		ON p.productid =sod.productid 
	JOIN production.productsubcategory psc
		ON psc.productsubcategoryid = p.productsubcategoryid 
	GROUP BY psc.name, p.productid;
------------------------------------------------------------------
-- 4. Determine the number of subcategories under each product category.

SELECT 
		pc.name AS cat_name, 
		COUNT(psc.productsubcategoryid) AS sub_cat_count
	FROM production.productcategory pc 
	JOIN production.productsubcategory psc
		ON psc.productcategoryid = pc.productcategoryid 
	GROUP BY pc.name;
------------------------------------------------------------------
-- 5. Compute the average total order amount by product subcategories.

SELECT 
		psc.name AS product_name,
		AVG(sod.unitprice * (1-sod.unitpricediscount) * sod.orderqty) AS avg_order_total
	FROM sales.salesorderdetail sod
	JOIN production.product p 
		ON p.productid = sod.productid 
	JOIN production.productsubcategory psc
		ON psc.productsubcategoryid = p.productsubcategoryid
	GROUP BY psc.name;
--------------------------------------------------------------------
--6. Identify the employee with the highest pay and the date this rate was
-- first applied, using the HumanResources.EmployeePayHistory table.

SELECT  
		eph.businessentityid, p.firstname,
		eph.ratechangedate, eph.rate 
	FROM humanresources.employeepayhistory eph
	JOIN person.person p
		ON p.businessentityid = eph.businessentityid 
	WHERE  
		eph.rate =  (
				SELECT  max(eph.rate)
				FROM humanresources.employeepayhistory eph
			    );
----------------------------------------------------------------------





