--===========================================================================
--============================= CIS310 ASSIGNMENT 9 =========================
--===========================================================================

/*
STUDENT NAME: Jackson Mundy
STUDENT ID: 5422156
SUBMISSION DATE: 11/20/2023


For each of the following business request PROVIDE THE SQL Query that adequtely performs the tasks.
**These queries are based on STAYWELL DB Tables and their data contents**

Grading:
Proper Code Formatting is 20% of homework grade
Executable code can earn up to 100% of the grade
Unexecutable code can only earn up to a max of 50% of the grade
*/


--1.Create a LARGE_PROPERTY table and insert into the LARGE_PROPERTY table the office number, address, bedrooms, baths, 
--monthly rent, and owner number for those properties whose square footage is greater than 1,500 square feet.
--There are multiple ways you can accomplish this, submit the easiest method.
SELECT OFFICE_NUM, ADDRESS, BDRMS, MONTHLY_RENT, OWNER_NUM, FLOORS
	INTO LARGE_PROPERTY
		FROM PROPERTY
			WHERE SQR_FT > 1500;
SELECT * FROM LARGE_PROPERTY;
--2.StayWell has increased the monthly rent of each large property by $250. 
--Update the monthly rents in the LARGE_PROPERTY table accordingly.
UPDATE LARGE_PROPERTY
	SET MONTHLY_RENT = MONTHLY_RENT + 250;

SELECT * FROM LARGE_PROPERTY;
--3.After increasing the monthly rent of each large property by $250 (in exercise 2), 
--StayWell decides to decrease the monthly rent of any property 
--whose monthly fee is more than $1750 by 3 percent. 
--Update the monthly rents in the LARGE_PROPERTY table accordingly.
UPDATE LARGE_PROPERTY
	SET MONTHLY_RENT = (MONTHLY_RENT - (MONTHLY_RENT * .03))
		WHERE MONTHLY_RENT > 1750;

SELECT * FROM LARGE_PROPERTY;
--4.Insert a row into the LARGE_PROPERTY table for a new property. The office number is 1, 
--the address is 2643 Lugsi Dr, the number of bedrooms is 3, the number of floors is 2, 
--the monthly rent is $775, and the owner number is MA111.
INSERT INTO LARGE_PROPERTY (OFFICE_NUM, ADDRESS, BDRMS, FLOORS, MONTHLY_RENT, OWNER_NUM)
	VALUES ('1','2643 Lugsi Dr',3,2,775,'MA111');
SELECT * FROM LARGE_PROPERTY;
--5.Delete all properties in the LARGE_PROPERTY table for which the owner number is BI109.
DELETE FROM LARGE_PROPERTY
	WHERE OWNER_NUM = 'BI109';
-- I DONT KNOW IF ANY ROWS SHOULD HAVE BEEN AFFECTED
--6.The property in managed by Columbia City with the address 105 North Illinois Rd is 
--in the process of being remodeled and not rentable and should not have a rent amount listed. 
--Change the monthly rent value in the LARGE_PROPERTY table to null.
UPDATE LARGE_PROPERTY
	SET MONTHLY_RENT = NULL
		WHERE ADDRESS = '105 North Illinois Rd';
-- I DONT KNOW IF ANY ROWS SHOULD HAVE BEEN AFFECTED
--7. Delete the LARGE_PROPERTY table from the database.
DROP TABLE LARGE_PROPERTY;
