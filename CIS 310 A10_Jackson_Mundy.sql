--===========================================================================
--============================= CIS310 ASSIGNMENT 10 =========================
--===========================================================================

/*
STUDENT NAME: JACKSON MUNDY
STUDENT ID: 5422156
SUBMISSION DATE: 12.03.2023


For each of the following business request PROVIDE THE SQL Query that adequtely performs the tasks.
**These queries are based on STAYWELL DB Tables and their data contents**

Grading:
Proper Code Formatting is 20% of homework grade
Executable code can earn up to 100% of the grade
Unexecutable code can only earn up to a max of 50% of the grade
*/


-- 1. Create a Stored Procedure DISPLAY_OWNER_YOURFIRSTNAMELASTNAME (E.G. DISPLAY_OWNER_JIAOWANG), and its corresponding execution/test code.
--This Stored Procedure takes a single parameter/variable named INPUT_PROPERTY_ID to store user input value of a PROPERTY_ID. 
--It should output OFFICE_NUM, ADDRESS, OWNER_NUM and OWNER_NAME (concatenated FirstName LastName in proper format) 
--from the PROPERTY and OWNER tables for the given PROPERTY_ID
EXEC SP_COLUMNS OWNER;
@INPUT_PROPERTY_ID

CREATE PROCEDURE DISPLAY_OWNER_YOURFIRSTNAMELASTNAME @INPUT_PROPERTY_ID SMALLINT
AS
	BEGIN 
		SELECT OFFICE_NUM, O.ADDRESS, O.OWNER_NUM, FIRST_NAME + ' ' + LAST_NAME AS OWNER_NAME
			FROM OWNER O INNER JOIN PROPERTY P ON O.OWNER_NUM = P.OWNER_NUM
	END;

EXEC DISPLAY_OWNER_YOURFIRSTNAMELASTNAME 10;

-- 2. Create a Stored Procedure UPDATE_OWNER_YOURFIRSTNAMELASTNAME (E.G. UPDATE_OWNER_JIAOWANG), and its corresponding execution/test code.
--This Stored Procedure takes 2 parameters/variables:  
--I_OWNER_NUM to store user input value of a OWNER_NUM, and I_LAST_NAME to store user input value of a new LAST_NAME. 
--This stored procedure should update/change the last name to the given value, for the given owner num.	

@I_OWNER_NUM
@I_LAST_NAME

CREATE PROCEDURE UPDATE_OWNER_YOURFIRSTNAMELASTNAME @I_OWNER_NUM CHAR (5),
													@I_LAST_NAME VARCHAR (20)
	AS 
		BEGIN
			UPDATE OWNER
				SET LAST_NAME = @I_LAST_NAME
					WHERE OWNER_NUM = @I_OWNER_NUM
		END;

SELECT * FROM OWNER;
EXEC UPDATE_OWNER_YOURFIRSTNAMELASTNAME 'AK102', 'MUNDY';