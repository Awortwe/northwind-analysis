-- Create a report showing FirstName, LastName, Country from the employees not from United States.
SELECT FirstName, LastName, Country 
FROM employees
WHERE Country <> 'USA';

-- Create a report that shows the EmployeeID, OrderID, CustomerID, RequiredDate, ShippedDate from all orders shipped later than the required date.
SELECT EmployeeID, OrderID,
CustomerID, RequiredDate, ShippedDate
FROM orders 
WHERE RequiredDate < ShippedDate;

-- Create a report that shows the City, CompanyName, ContactName of customers from cities starting with A or B.
SELECT City,
CompanyName, ContactName
FROM customers
WHERE City LIKE 'A%' OR City LIKE 'B%';

-- Create a report showing all the even numbers of OrderID from the orders table.
SELECT * FROM orders
WHERE OrderID%2 = 0;
-- OR ----
SELECT * FROM orders
WHERE MOD(OrderID,2) = 0;

-- Create a report that shows all the orders where the freight cost more than $500.
SELECT * FROM orders
WHERE Freight > 500;

-- Create a report that shows the ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel of all products that are up for reorder.
SELECT ProductName,
UnitsInStock, UnitsOnOrder,
ReorderLevel
FROM products
WHERE ReorderLevel < 1;

-- Create a report that shows the CompanyName, ContactName number of all customer that have no fax number.
SELECT CompanyName, 
ContactName, Phone
FROM customers
WHERE Fax IS NULL;

-- Create a report that shows the FirstName, LastName of all employees that do not report to anybody.
SELECT FirstName,
LastName
FROM employees
WHERE ReportsTo IS NULL;

-- Create a report showing all the odd numbers of OrderID from the orders table.
SELECT * FROM orders
WHERE MOD(OrderID,2) = 1;

-- Create a report that shows the CompanyName, ContactName, Fax of all customers that do not have Fax number and sorted by ContactName.
SELECT CompanyName,
ContactName
FROM customers
WHERE Fax IS NULL
ORDER BY ContactName;

-- Create a report that shows the City, CompanyName, ContactName of customers from cities that has letter L in the name sorted by ContactName.
SELECT City, CompanyName,
ContactName
FROM customers
WHERE City LIKE '%L%'
ORDER BY ContactName;

-- Create a report that shows the FirstName, LastName, BirthDate of employees born in the 1950s.
SELECT FirstName, LastName,
BirthDate 
FROM employees
WHERE YEAR(BirthDate) BETWEEN 1950 AND 1959;

-- Create a report that shows the FirstName, LastName, the year of Birthdate as birth year from the employees table.
SELECT FirstName,
LastName, YEAR(BirthDate) AS BirthYear
FROM employees;

-- Create a report showing OrderID, total number of Order ID as NumberofOrders from 
-- the orderdetails table grouped by OrderID and sorted by NumberofOrders in descending order.
SELECT OrderID, 
count(OrderID) AS `Number Of Orders` 
FROM orderdetails
GROUP BY OrderID
ORDER BY `Number Of Orders` DESC;

-- Create a report that shows the SupplierID, ProductName, CompanyName from all product Supplied by 
-- Exotic Liquids, Specialty Biscuits, Ltd., Escargots Nouveaux sorted by the supplier ID
SELECT * FROM suppliers;
SELECT * FROM products;

SELECT SupplierID, ProductName, CompanyName
FROM suppliers INNER JOIN products
USING (SupplierID)
WHERE CompanyName IN ('Exotic Liquids', 'Specialty Biscuits, Ltd.', 'Escargots Nouveaux')
ORDER BY SupplierID;

-- Create a report that shows the ShipPostalCode, OrderID, OrderDate, RequiredDate, ShippedDate, ShipAddress 
-- of all orders with ShipPostalCode beginning with "98124".
SELECT ShipPostalCode, OrderID, OrderDate, RequiredDate, ShippedDate, ShipAddress 
FROM orders
WHERE ShipPostalCode LIKE '98124%';

-- Create a report that shows the ContactName, ContactTitle, CompanyName of customers that the has no "Sales" in their ContactTitle.
SELECT ContactName,
ContactTitle, CompanyName
FROM customers
WHERE ContactTitle NOT LIKE '%Sales%';

-- Create a report that shows the LastName, FirstName, City of employees in cities other than "Seattle";
SELECT LastName,
FirstName, City
FROM employees
WHERE City <> 'Seattle';

/*Create a report that shows the CompanyName, ContactTitle, City, Country of all customers in 
any city in Mexico or other cities in Spain other than Madrid.*/
SELECT CompanyName, ContactTitle,
City, Country 
FROM customers
WHERE Country IN ('Mexico','Spain')
AND City <> 'Madrid';

-- Query 30
SELECT 
concat(FirstName,' ', LastName, ' can be reached at x', extension)Contactinfo 
FROM employees;

-- Create a report that shows the ContactName of all customers that do not have letter A as the second alphabet in their Contactname.
SELECT ContactName 
FROM customers
WHERE ContactName NOT LIKE '_a%';

/*Create a report that shows the average UnitPrice rounded to the next whole number, total price of UnitsInStock and maximum number of 
orders from the products table. All saved as AveragePrice, TotalStock and MaxOrder respectively.*/
SELECT round(avg(UnitPrice))AveragePrice,
sum(UnitsInStock)TotalStock,
max(UnitsOnOrder)MaxOrder
FROM products;

-- Create a report that shows the SupplierID, CompanyName, CategoryName, ProductName and UnitPrice from the products, suppliers and categories table.
SELECT SupplierID, CompanyName,
CategoryName, ProductName, UnitPrice
FROM categories INNER JOIN products
USING (CategoryID)
INNER JOIN suppliers
USING (SupplierID)
ORDER BY SupplierID;

/*Create a report that shows the CustomerID, sum of Freight, from the orders table with sum of freight greater $200, grouped by CustomerID. 
HINT: you will need to use a Groupby and a Having statement.*/
SELECT CustomerID,
round(sum(Freight),2)`Sum of Freight` 
FROM orders
GROUP BY CustomerID
HAVING sum(Freight) > 200
ORDER BY `Sum of Freight`;

/*
Create a report that shows the OrderID ContactName, UnitPrice, Quantity, 
Discount from the order details, orders and customers table with discount given on every purchase.
*/
SELECT OrderID, ContactName, 
UnitPrice, Quantity, Discount
FROM customers INNER JOIN orders
USING (CustomerID)
INNER JOIN orderdetails
USING (OrderID)
WHERE Discount <> 0;

/*
Create a report that shows the EmployeeID, the LastName and FirstName as employee, and 
the LastName and FirstName of who they report to as manager from the employees table sorted by Employee
*/
SELECT e1.EmployeeID, e1.LastName,
e1.FirstName, e2.LastName, e2.FirstName
FROM employees e1 INNER JOIN employees e2
ON e1.EmployeeID = e2.ReportsTo;

-- Create a report that shows the average, minimum and maximum UnitPrice of all products as AveragePrice, MinimumPrice and MaximumPrice respectively.
SELECT round(avg(UnitPrice),2)AveragePrice, 
round(min(UnitPrice),2)MinimumPrice,
round(max(UnitPrice),2)MaximumPrice
FROM products;

/*Create a view named CustomerInfo that shows the CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Country, Phone, OrderDate, 
RequiredDate, ShippedDate from the customers and orders table.*/
CREATE VIEW CustomerInfo
AS
SELECT CustomerID, CompanyName, 
ContactName, ContactTitle,
Address, City, Country,
Phone,OrderDate, RequiredDate, ShippedDate
FROM customers INNER JOIN orders
USING(CustomerID);

SELECT * FROM CustomerDetails;

-- Change the name of the view you created from customerinfo to customer details.
RENAME TABLE CustomerInfo TO CustomerDetails;

/*
Create a view named ProductDetails that shows the ProductID, CompanyName, ProductName, CategoryName, 
Description, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, 
Discontinued from the supplier, products and categories tables. HINT: Create a View
*/
CREATE OR REPLACE VIEW ProductDetails
AS
SELECT ProductID, CompanyName,
ProductName, CategoryName,
Description, QuantityPerUnit, UnitPrice, 
UnitsOnOrder, ReorderLevel
FROM products INNER JOIN categories
USING(CategoryID)
INNER JOIN suppliers
USING(SupplierID);

SELECT * FROM ProductDetails;

-- Drop the customer details view.
DROP VIEW IF EXISTS CustomerDetails;

-- Create a report that fetch the first 5 character of categoryName from the category tables and renamed as ShortInfo
SELECT left(CategoryName,5)ShortInfo 
FROM categories;

/*Create a copy of the shipper table as shippers_duplicate. Then insert a copy of shippers data into the new table HINT: 
Create a Table, use the LIKE Statement and INSERT INTO statement.*/
CREATE TABLE shippers_duplicate LIKE shippers;

INSERT INTO shippers_duplicate
SELECT * FROM shippers;

SELECT ShipperID, CompanyName, Phone
FROM shippers_duplicate
WHERE ShipperID < 4;


-- Create a report that shows the CompanyName and ProductName from all product in the Seafood category.
WITH product_category AS 
(SELECT CategoryID, CategoryName
FROM categories)
SELECT CompanyName, ProductName
FROM suppliers INNER JOIN products
USING(SupplierID)
INNER JOIN product_category 
USING(CategoryID)
WHERE CategoryID = 8;

-- Create a report that shows the CategoryID, CompanyName and ProductName from all product in the categoryID 5.
SELECT CategoryID,
CompanyName, ProductName
FROM products INNER JOIN categories
USING(CategoryID)
INNER JOIN suppliers
USING(SupplierID)
WHERE CategoryID = 5;

-- Delete the shippers_duplicate table.
DROP TABLE IF EXISTS shippers_duplicate;

-- Create a select statement that ouputs the following from the employees table.
SELECT LastName, FirstName, 
Title, concat(YEAR(now())-YEAR(Birthdate), ' years')Age
FROM employees;

/*Create a report that the CompanyName and total number of orders by customer renamed as number of orders since
December 31, 1994. Show number of Orders greater than 10.*/
SELECT * FROM orders;
SELECT * FROM customers;

SELECT CompanyName,
count(OrderID)NumberOfOrders
FROM orders INNER JOIN customers
USING(CustomerID)
WHERE OrderDate >= '1994-12-31' 
GROUP BY CustomerID
HAVING NumberOfOrders > 10;

SELECT 
concat(ProductName,' weighs/is ',QuantityPerUnit,' and cost $',round(UnitPrice))ProductInfo 
FROM products;

 


