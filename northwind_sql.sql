USE northwind;
SHOW tables;

-- Get Order id, Product id, Unit price from Order Details.
SELECT OrderID, ProductID, UnitPrice
FROM orderdetails;

-- Find Title of employee Nancy.
SELECT Title FROM employees
WHERE FirstName = 'Nancy';

-- Get the price of an order (by multiplying unit price by quantity) from Order Details.
SELECT OrderID, ROUND((UnitPrice*Quantity),2) AS `Price` 
FROM orderdetails
ORDER BY `Price` DESC;

-- Display all cities that employees belong to but don’t allow repetition.
SELECT DISTINCT City FROM employees;

-- Find complete name of all employees.
SELECT CONCAT(LastName, ' ', FirstName) AS `FullName`
FROM employees
ORDER BY `FullName`;

-- Display data of all employees those working as Sales Representative.
SELECT * FROM employees
WHERE Title = 'Sales Representative';

-- Display complete name of employees those lives in London.
SELECT CONCAT(LastName, ' ', FirstName)`FullName` 
FROM employees
WHERE City = 'London';

-- Display product name whose unit price are greater than 90$.
SELECT ProductName FROM products
WHERE UnitPrice > 90;

-- List the name of all employees whose first name starts with the letter ‘A’.
SELECT concat(LastName, ' ', FirstName)`FullName`
FROM employees
WHERE FirstName LIKE 'A%';

-- In Customer table, display all cities that ends with the letter ‘a’.
SELECT City FROM customers
WHERE City LIKE '%a';

-- Display names of all employees whose name contain ‘an’.
SELECT concat(LastName, ' ', FirstName)`FullName`
FROM employees
WHERE LastName LIKE '%an%' OR FirstName LIKE '%an%';

-- Display all the orders where unit price lies in the range of 10$ to 40$.
SELECT * FROM orders;
SELECT * FROM orderdetails;

SELECT * FROM orderdetails
WHERE UnitPrice BETWEEN 10 AND 40;

-- Display the company name where Region is NULL in Customer Table.
SELECT CompanyName FROM customers
WHERE Region IS NULL;

-- Write a query to list employees who live in London, Seattle or Redmond
SELECT * FROM employees
WHERE CITY IN ('London', 'Seattle', 'Redmond');

-- Write a query to list employees whose address contains 3 numbers in its start.
SELECT * FROM employees
WHERE address REGEXP '^[0-9]{3}';


-- Write a query to list employees whose address does not contain Rd.
SELECT * FROM employees
WHERE Address NOT LIKE '%Rd%';

-- Write a query to list all those employees whose TitleofCourtesy does not starts with M.
SELECT * FROM employees
WHERE TitleOfCourtesy NOT LIKE 'M%';

-- List order details whose ShipRegion is not Null.
SELECT * FROM orders
WHERE ShipRegion IS NOT NULL;

-- List all products where UnitPrice is between 10 and 15 and QuantityPerUnit contains “bottles”
SELECT * FROM products
WHERE UnitPrice BETWEEN 10 AND 15
AND QuantityPerUnit LIKE '%bottles%';

-- List all products where UnitPrice is not in 10,12,15,17 or 19.
SELECT * FROM products
WHERE UnitPrice NOT IN (10, 12, 15, 17);

-- Select the second to the fourth characters from the last names of the employees
SELECT LastName, substring(LastName,2,4)
FROM employees;

-- How many employees have "sales" in their title
SELECT count(*)`Number` 
FROM employees
WHERE Title LIKE '%Sales%'; 

-- Using the sub query show how you would get the second  to highest salary from the employees table
SELECT max(Salary)
FROM employees
WHERE Salary NOT IN
(SELECT max(Salary) FROM employees);

-- Find the number of customers in each city per country
SELECT Country, City, count(*)`Number` 
FROM customers
GROUP BY Country, City
ORDER BY `Number` DESC;

-- Help find customers that haven't placed an order 
SELECT CustomerID FROM customers
WHERE CustomerID NOT IN
(SELECT CustomerID FROM orders);

-- Help find customers that haven't placed an order with their names
SELECT * FROM customers;
SELECT CustomerID, 
CompanyName
FROM customers
WHERE CustomerID NOT IN
(SELECT CustomerID FROM orders);

/*Some customers' orders are delayed. To investigate this, find the order IDs, the names of 
customers whose orders are delayed, and the destination countries*/
SELECT * FROM customers;
SELECT * FROM orders;

SELECT o.OrderID, 
c.CompanyName, 
o.ShipCountry,
DATEDIFF(o.ShippedDate, o.OrderDate)`OrderDate_to_ShippedDate`,
DATEDIFF(o.ShippedDate, o.RequiredDate)`RequiredDate_to_ShippedDate`
FROM customers c INNER JOIN orders o
ON c.CustomerID = o.CustomerID
WHERE o.ShippedDate >= o.RequiredDate
ORDER BY `RequiredDate_to_ShippedDate` DESC;

-- We want to know the quantity of each product purchased per customer in 1996
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM orderdetails;

SELECT c.CompanyName, 
p.ProductName,
sum(od.Quantity)`Quantity`
FROM products p INNER JOIN orderdetails od
ON p.ProductID = od.ProductID
INNER JOIN orders o 
ON od.OrderID = o.OrderID
INNER JOIN customers c 
ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY od.ProductID, o.CustomerID
ORDER BY c.CompanyName;

/*
We want to have the names of customers who placed orders in 1996 along with their total order and the following comments:
Order below $1,000 should read 'Very Low Order'
Order between $1,000 and $5,000 should read 'Low order'
Order between $5,001 and $10,000 should read 'Medium order'
Order between $10,001 and $15,000 should read 'High Order'
Order above $15,000 should read 'Very High Order'
*/
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM orderdetails;

SELECT c.CompanyName,
concat('$ ', format(sum(od.UnitPrice*od.Quantity),2))`TotalOrders`,
CASE
WHEN sum(od.UnitPrice*od.Quantity) < 1000 THEN 'Very Low Order'
WHEN sum(od.UnitPrice*od.Quantity) BETWEEN 1000 AND 5000 THEN 'Low Order'
WHEN sum(od.UnitPrice*od.Quantity)BETWEEN 5001 AND 10000 THEN 'Medium Order'
WHEN sum(od.UnitPrice*od.Quantity) BETWEEN 10001 AND 15000 THEN 'High Order'
WHEN sum(od.UnitPrice*od.Quantity) > 15000 THEN 'Very High Order'
END `Comments`
FROM orderdetails od INNER JOIN orders o
ON od.OrderID = o.OrderID
INNER JOIN customers c
ON o.CustomerID = c.CustomerID
WHERE YEAR(OrderDate) = 1996
GROUP BY o.CustomerID
ORDER BY sum(od.UnitPrice*od.Quantity) DESC;

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM orderdetails;

With 1996Orders AS(SELECT c.CustomerID,
c.CompanyName,
sum(od.UnitPrice*od.Quantity) AS TotalOrders
FROM orderdetails od INNER JOIN orders o
ON od.OrderID = o.OrderID
INNER JOIN customers c
ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY o.CustomerID)
SELECT c.CompanyName,
concat('$ ',format(kk.TotalOrders,2))"Total Orders Placed",
CASE
WHEN kk.TotalOrders < 1000 THEN 'Very Low Order'
WHEN kk.TotalOrders BETWEEN 1000 AND 5000 THEN 'Low Order'
WHEN kk.TotalOrders BETWEEN 5001 AND 10000 THEN 'Medium Order'
WHEN kk.TotalOrders BETWEEN 10001 AND 15000 THEN 'High Order'
WHEN kk.TotalOrders > 15000 THEN 'Very High Order'
END Comment
FROM customers c INNER JOIN 1996Orders kk
ON c.CustomerID = kk.CustomerID
ORDER BY kk.TotalOrders DESC;

-- Get all the countries in employees, customers and suppliers table
SELECT Country FROM 
employees
UNION 
SELECT Country FROM
customers
UNION 
SELECT Country
FROM suppliers;

-- Show all the employees with the percentage of late/delayed orders more than 5% of the total number of orders taken by the employee
SELECT * FROM employees;
SELECT * FROM orders;

with TotalOrdersPerEmployee AS(
SELECT EmployeeID, 
count(EmployeeID)NumberOfOrdersTaken
FROM orders
GROUP BY EmployeeID),
TotalNumberOfLateOrderPerEmployee AS(
SELECT EmployeeID,
count(EmployeeID)NumberOfLateOrders
FROM orders
WHERE RequiredDate <= ShippedDate
GROUP BY EmployeeID
)
SELECT 
concat(e.LastName,space(2), e.FirstName)`EmployeeName`,
toe.NumberOfOrdersTaken"Number of Orders",
tlo.NumberOfLateOrders"NUmber of Late Orders",
concat(format(((tlo.NumberOfLateOrders/toe.NumberOfOrdersTaken)*100),2),'%')"Percentage Of Late Orders"
FROM TotalNumberOfLateOrderPerEmployee tlo
INNER JOIN employees e
ON tlo.EmployeeID = e.EmployeeID
INNER JOIN TotalOrdersPerEmployee toe
ON e.EmployeeID = toe.EmployeeID
WHERE ((tlo.NumberOfLateOrders/toe.NumberOfOrdersTaken)*100) > 5
ORDER BY ((tlo.NumberOfLateOrders/toe.NumberOfOrdersTaken)*100) DESC;

-- Get the names of employees that were employed the same period: same month and same week day
SELECT * FROM employees;

SELECT concat(t1.FirstName, ' and ', t2.FirstName, ' hired the same weekday and month')`FullName`
FROM employees t1,employees t2
WHERE MONTH(t1.HireDate) = MONTH(t2.HireDate)
AND DAYNAME(t1.HireDate) = DAYNAME(t2.HireDate)
AND t1.EmployeeID < t2.EmployeeID;


-- Create a report that shows the CategoryName and Description from the categories table sorted by CategoryName.
SELECT CategoryName, Description
FROM categories
ORDER BY CategoryName ASC;

-- Create a report that shows the ContactName, CompanyName, ContactTitle and Phone number from the customers table sorted by Phone.
SELECT ContactName, CompanyName,
ContactTitle, Phone
FROM customers
ORDER BY Phone ASC;

/*Create a report that shows the capitalized FirstName and capitalized LastName renamed as FirstName and Lastname respectively and HireDate 
from the employees table sorted from the newest to the oldest employee.*/
SELECT upper(FirstName)FirstName, upper(LastName)LastName,
HireDate
FROM employees
ORDER BY HireDate DESC;

/*Create a report that shows the top 10 OrderID, OrderDate, ShippedDate, CustomerID, Freight from the orders 
table sorted by Freight in descending order.*/
SELECT OrderID, ShippedDate, CustomerID, Freight
FROM orders
ORDER BY Freight DESC
LIMIT 10;

-- Create a report that shows all the CustomerID in lowercase letter and renamed as ID from the customers table.
SELECT lower(CustomerID)ID FROM customers;

/*
Create a report that shows the CompanyName, Fax, Phone, Country, HomePage from the suppliers 
table sorted by the Country in descending order then by CompanyName in ascending order.
*/
SELECT CompanyName, Fax, Phone, 
Country, Homepage 
FROM suppliers
ORDER BY Country ASC;

-- Create a report that shows CompanyName, ContactName of all customers from ‘Buenos Aires' only.
SELECT CompanyName, ContactName 
FROM customers
WHERE City= 'Buenos Aires'; 

-- Create a report showing ProductName, UnitPrice, QuantityPerUnit of products that are out of stock.
SELECT ProductName, UnitPrice, QuantityPerUnit 
FROM products
WHERE UnitsInStock = 0;

-- Create a report showing all the ContactName, Address, City of all customers not from Germany, Mexico, Spain.
SELECT ContactName, Address, City 
FROM customers
WHERE Country NOT IN ('Germany','Mexico','Spain');

-- Create a report showing OrderDate, ShippedDate, CustomerID, Freight of all orders placed on 21 May 1996.