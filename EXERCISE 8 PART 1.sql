/*
STUDENT ID: 5422156
NAME: JACKSON MUNDY
QUESTIONS: 1,4,5,6,8,26,19,18,15,16
DATE DUE: 11/28/2023
*/

use BIKE;

--1. List the customers from California who bought red mountain bikes in September 2003. 
--Use order date as date bought. Multi-color bikes with red are considered red bikes.
--CustomerID	LastName	FirstName	ModelType	ColorList	OrderDate	SaleState
-- I WANT TO FIND ANY TABLES IN THE DIAGRAM THAT CONTAIN CUSTOMER AND PAINT DATA FIRST
-- I AM LOOKING THROUGH CUSTOMER, BICYCLE, PAINT,CITY (COULD USE STATE FROM THIS TABLE BUT I AM ASSUMING CUSTOMERS LIVE IN THE SALES STATE), AND CUSTOMERTRANSACTION
-- DATA SPREADS ACROSS MULTIPLE TABLES
-- I WILL BE USING A SERIES OF JOINS & NESTED QUERIES
SELECT B.CustomerID, LastName, FirstName, ModelType, ColorList, OrderDate as DateBought, SaleState
	FROM Bicycle  B INNER JOIN Customer C ON B.CustomerID = C.CustomerID
	INNER JOIN Paint P ON B.PaintID = P.PaintID
		WHERE B.PaintID IN (SELECT PaintID
							FROM Paint 
								WHERE ColorList LIKE '%Red%')
		AND B.CustomerID IN (SELECT CustomerID
							FROM CUSTOMER
								WHERE CustomerID IN (SELECT CustomerID
														FROM CustomerTransaction))
		AND YEAR(OrderDate) = '2003'
		AND MONTH(OrderDate) = '09'
		AND SaleState = 'CA'
		AND ModelType LIKE '%Mountain%';

--4. Who bought the largest (frame size) full suspension mountain bike sold in Georgia in 2004?
--CustomerID	LastName	FirstName	ModelType	SaleState	FrameSize	OrderDate
-- Looking for the appropriate tables to join
-- Thought the table would display only the one customer based on the frame size, math was wrong 
SELECT B.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, MODELTYPE, SALESTATE, FRAMESIZE, ORDERDATE
	FROM Bicycle B INNER JOIN Customer C ON B.CustomerID = C.CustomerID
	INNER JOIN CustomerTransaction CT ON C.CustomerID = CT.CustomerID
		WHERE ModelType = 'Mountain full'
		AND SaleState = 'GA'
		AND OrderDate LIKE '2004%'
		GROUP BY FRAMESIZE, B.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, MODELTYPE, SALESTATE, OrderDate 
		HAVING FrameSize > SUM(FRAMESIZE);
-- realized I needed the max framesize so just switchted functions but more than one record would display in solution with different sizes
SELECT B.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, MODELTYPE, SALESTATE, FRAMESIZE, ORDERDATE
	FROM Bicycle B INNER JOIN CUSTOMER C ON B.CustomerID = C.CustomerID
	INNER JOIN CustomerTransaction CT ON C.CustomerID = CT.CustomerID
		WHERE ModelType = 'Mountain full'
		AND SaleState = 'GA'
		AND YEAR(OrderDate) = '2004'
		GROUP BY B.CUSTOMERID, C.LASTNAME, C.FirstName, MODELTYPE, SALESTATE, FRAMESIZE, ORDERDATE
		HAVING FRAMESIZE = MAX(distinct FrameSize);
-- LOOKED AT THE DIAGRAM AND REALIZED ALL NECESSARY INFORMATION WAS ON THE ONE TABLE
-- CANNOT GET OUTPUT TO DISPLAY ANYTHING BESIDES A NULL TABLE 
-- WENT TO FIND THE MAX VALUE INSTEAD OF USING THE AGGREGATE FUNCTION
Select customerid, FrameSize, CustomName, ModelType, SaleState, OrderDate
	from Bicycle
		WHERE OrderDate LIKE '%2004%'
		AND SaleState = 'GA'
		AND ModelType = 'Moutain full'
		AND FrameSize = 62;

SELECT TOP 1 B.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, MODELTYPE, SALESTATE, FRAMESIZE, ORDERDATE
	FROM Bicycle B INNER JOIN CUSTOMER C ON B.CustomerID = C.CustomerID
	INNER JOIN CustomerTransaction CT ON C.CustomerID = CT.CustomerID
		WHERE SaleState = 'GA'
		AND ModelType = 'Mountain full'
		AND YEAR(OrderDate) = '2004'
		AND FrameSize IN (SELECT MAX(FRAMESIZE) FROM Bicycle
							WHERE ModelType = 'Mountain full');

--5. Which manufacturer gave us the largest discount on an order in 2003?
--ManufacturerID	ManufacturerName
-- NEED BOTH THE MANUFACTURER TABLE PURCHASE ORDER TABLE
-- ONLY ONE DISCOUNT NUMBER SHOULD BE RETURNED SO AND IT NEEDS TO BE THE MAX
SELECT M.ManufacturerID, M.ManufacturerName
	FROM PurchaseOrder PO INNER JOIN Manufacturer M ON PO.ManufacturerID = M.ManufacturerID
		WHERE 
		PO.Discount = (SELECT MAX(DISCOUNT) FROM PurchaseOrder
						WHERE YEAR(ORDERDATE) = '2003');
-- THE FIRST QUERY YIELDED AN VOID SOLUTION
-- ATTEMPTING A NESTED QUERY TO SEE WHY THERE IS A POPULATED TABLE RETURNED
-- SOMETHING WAS WRONG WITH THE WAY I SEARCHED FOR THE DATE
-- WANT TO VIEW META DATA FOR THE PURCHASEORDER TABLE
EXEC sp_columns PURCHASEORDER;
SELECT MANUFACTURERID, MANUFACTURERNAME
	FROM Manufacturer
		WHERE MANUFACTURERID = (SELECT ManufacturerID
									FROM PurchaseOrder
										WHERE Discount = (SELECT MAX(DISCOUNT) FROM PurchaseOrder));

--6. What is the most expensive road bike component we stock that has a quantity on hand greater than 200 units?
--ComponentID	ManufacturerName	ProductNumber	Road	Category	ListPrice	QuantityOnHand
-- WILL NEED THE MANUFACTURER TABLE AND COMPONENT TABLE
-- THINKING ABOUT USING A JOIN
-- TO GET MOST EXPENSIVE YOU NEED THE MAX RECORD IN THE LISTPRICE COLUMN
-- USING A NESTED QUERY TO GET THE MAX PRICE FOR THE COMPONENT HAS MORE THAN 200
SELECT C.ComponentID, MANUFACTURERNAME, PRODUCTNUMBER, ROAD, CATEGORY, ListPrice, QUANTITYONHAND
	FROM Component C INNER JOIN Manufacturer M ON C.ManufacturerID = M.ManufacturerID
		WHERE ListPrice = (SELECT MAX(LISTPRICE) 
								FROM Component
									WHERE QuantityOnHand > 200);
			

--8. What is the greatest number of components ever installed in one day by one employee?
--EmployeeID	LastName	DateInstalled	CountOfComponentID
--The link is bewtween Employee and BikeParts
--will need an aggregate function count
--a join
SELECT E.EMPLOYEEID, LASTNAME, DATEINSTALLED, COUNT(COMPONENTID) AS COUNTOFCOMPONENTID
	FROM EMPLOYEE E INNER JOIN BIKEPARTS BP ON E.EMPLOYEEID = BP.EMPLOYEEID
		GROUP BY E.EMPLOYEEID, LASTNAME, DATEINSTALLED;

--SHOULD ONLY ONE RECORD RETURN?? IF SO HOW TO GET MAX OF THE COUNT

--26. List all of the employees who report to Venetiaan.
--EmployeeID	LastName	FirstName	Title
--QUERY THAT I JUST USED THE EMPLOYEE TABLE FOR 
--FOUND OUT VENETIANS ID AS THE CURRENTMANGER USES THE EMPLOYEEID TO EASILY IDENTIFY THE MANAGERS INFORMATION
 SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE
	FROM Employee
		WHERE CurrentManager = '15293';

--19. What is the average top tube length for a 54 cm (frame size) road bike built in 1999?
--AvgOfTopTube
--FOUND OUT WHERE THE INFORMATION IS (BICYCLE TABLE)
--NEW I NEEDED THE START DATE TO BE IN 1999, THE MODEL TYPE TO BE ROAD, AND FRAME SIZE 54
SELECT AVG(TOPTUBE) AS AvgOfTopTube
	FROM Bicycle
		WHERE MODELTYPE = 'Road'
		AND FRAMESIZE = 54
		AND StartDate LIKE '%1999%';

--18. What is the average price paid for the 2001 Shimano XTR rear derailleurs?
--AvgOfPricePaid
--THIS HAS MULTIPLE COMPONENTS THAT NEED TO BE NOTED 
--I THINK COMPONENTNAME IS NAMED CATEGORY ON THE COMPONENT TABLE
--WILL NEED THE PURCHASEITEM TABLE TO GET THE PRICE PAID ALONG WITH COMPONTENT, AND COMPONENT NAME
--I DONT THINK YOU NEED TO USE THE COMPONENT NAME TABLE IN THE QUERY JUST USE IT AS A REFERENCE POINT FOR SETTING UP THE QUERY
--LOOKING THROUGH TABLE TO GAIN SOME KNOWLEDGE ON ITS CONTENTS BY DOING BASIC FILTERING
--YEAR OR ENDYEAR CAN BE 2001 I THINK
--EXPECTING NULL BASED ON THE TABLE RECORDS VIEWED PRIOR TO QUERING 
SELECT * FROM ComponentName
SELECT * FROM Component
	WHERE Category = 'Rear derailleur'

SELECT AVG(PRICEPAID) AS AvgOfPricePaid
	FROM PurchaseItem PI INNER JOIN Component C
	ON PI.ComponentID = C.ComponentID
		WHERE (C.Year = 2001
		OR C.EndYear = 2001)
		AND Category = 'Rear derailleur'
		AND C.Description LIKE '%Shimano%'
		AND C.Description LIKE '%XTR%';

--LOOKED AT GROUPO AND SAW NEW INFORMATION
--USE A SERIES OF JOINS TO CONNECT GROUPCOMPONENTS TO PURCHASE ITEM
--SET THE CONDITION OF THE QUERY TO WHERE THE GROUP ID CORRESPONDS TO THE COMPONENTGROUPID FROM GROUPO
--THIS IS THE CORRECT ' 2001 SHIMANO XTR ' WITH THE REAR DERAILLEURS
SELECT * FROM GroupComponents

SELECT AVG(PRICEPAID) AS AvgOfPricePaid
	FROM PurchaseItem PI INNER JOIN Component C
	ON PI.ComponentID = C.ComponentID
	INNER JOIN GroupComponents GC ON GC.ComponentID = C.ComponentID
		WHERE GC.GroupID = 34
		AND C.Category = 'Rear derailleur';

--15. What is the total weight of the components on bicycle 11356?
 --TotalWeight
 --HAD TO FIND A LINK TO A COMPONENT WEIGHT AND THE BICYCLE SERIAL NUMBER (BIKEPART & COMPONENT)
 --TOTALWEIGHT WILL BE THE SUM OF THE WEIGHT CATEGORY WHERE THE COMPONENT IS APART OF BICYCLE 11356 
 --SO THAT WILL BE THE CONDITION 
 --JOIN THE TABLES CONNECT 
 /*
 SELECT * FROM BikeParts
	WHERE SerialNumber = 11356
 SELECT * FROM Bicycle
 */
 SELECT SUM(Weight) AS TotalWeight
	FROM Component C INNER JOIN BikeParts BP 
	ON C.ComponentID = BP.ComponentID
		WHERE BP.SerialNumber = 11356;

--16. What is the total list price of all items in the 2002 Campy Record groupo?
--WILL NEED TO JOIN THE TABLES FROM GROUPO TO GROUPCOMPONENTS TO COMPONENTS
--HAVE TO FILTER THE RESULTS ON THE CONDITION THAT THE GROUPNAME MUST BE THE 2002 CAMPY RECORD
--WILL HAVE TO GROUP THE RESULTS BY GROUP NAME AS WELL
--GroupName	SumOfListPrice
SELECT GROUPNAME, SUM(LISTPRICE) AS SumOfListPrice
	FROM GROUPO INNER JOIN GroupComponents GC
	ON ComponentGroupID = GroupID 
	INNER JOIN Component C ON C.ComponentID = GC.ComponentID
		WHERE GroupName = 'Campy Record 2002'
			GROUP BY GroupName;