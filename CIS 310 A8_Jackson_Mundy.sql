--===========================================================================
--============================= CIS310 ASSIGNMENT 8 =========================
--===========================================================================

/*
STUDENT NAME: Jackson Mundy
STUDENT ID: 5422156
SUBMISSION DATE: 11/12/2023


--** YOU MUST USE THE PROPER JOIN KEYWORD FOR TABLE JOINS. Or the query will be considered unexecutable**

For each of the following business question, PROVIDE THE SQL Query that adequtely output the requested information
**These queries are based on STAYWELL DB Tables and their data contents**
**The Expected Output Tables are at the end of file, to help you check your queries**

Grading:
Proper Code Formatting is 20% of homework grade
Executable code can earn up to 100% of the grade
Unexecutable code can only earn up to a max of 50% of the grade
*/


--1.	For every property, list the management office number, property address, monthly rent, 
--owner number, owner’s first name, and owner’s last name.
SELECT O.OFFICE_NUM, P.ADDRESS, MONTHLY_RENT, OW.OWNER_NUM, OW.FIRST_NAME, OW.LAST_NAME
	FROM OFFICE O INNER JOIN PROPERTY P ON O.OFFICE_NUM = P.OFFICE_NUM
	INNER JOIN OWNER OW ON P.OWNER_NUM = OW.OWNER_NUM;

--2.	For every open or service scheduled service requests, list the property ID, description, and status. 
--HINT: Check table contents to write the most appropriate query.
SELECT P.PROPERTY_ID, SR.DESCRIPTION, SR.STATUS
	FROM PROPERTY P INNER JOIN SERVICE_REQUEST SR ON P.PROPERTY_ID = SR.PROPERTY_ID
		WHERE SR.STATUS = 'Open' 
		OR SR.STATUS = 'Scheduled';

--3.	For every service request for furniture replacement, list the property ID, 
--management office number, address, estimated hours, spent hours, owner number, 
--and owner’s last name.
--HINT: similar to last homework, be sure to use the specified keyword phrases in your querying (nested query)
SELECT P.PROPERTY_ID, O.OFFICE_NUM, P.ADDRESS, EST_HOURS, SPENT_HOURS, OW.OWNER_NUM, OW.LAST_NAME
	FROM SERVICE_REQUEST SR INNER JOIN PROPERTY P ON SR.PROPERTY_ID = P.PROPERTY_ID
	INNER JOIN OFFICE O ON O.OFFICE_NUM = P.OFFICE_NUM 
	INNER JOIN OWNER OW ON OW.OWNER_NUM = P.OWNER_NUM
		WHERE SR.DESCRIPTION LIKE '%Sofa%';

		SELECT * FROM SERVICE_REQUEST;
		SELECT * FROM PROPERTY;
--4.	List the first and last names of all owners who own a two-bedroom property. 
--Use the IN operator in your query.
SELECT OW.OWNER_NUM, OW.LAST_NAME
	FROM OWNER OW 
		WHERE OW.OWNER_NUM IN (SELECT OWNER_NUM
									FROM PROPERTY
										WHERE BDRMS = 2);

--5.    Repeat Exercise 4, but this time use the EXISTS operator in your query.
SELECT OW.OWNER_NUM, OW.LAST_NAME
	FROM OWNER OW 
		WHERE EXISTS (SELECT OWNER_NUM
								FROM PROPERTY
									WHERE BDRMS = 2
									AND OW.OWNER_NUM = OWNER_NUM);


--6.	List the property IDs of any pair of properties that have the same number of bedrooms. 
--For example, one pair would be property ID 2 and property ID 6, because they both have four bedrooms. 
--The first property ID listed should be the major sort key and the second property ID should be the minor sort key.
SELECT P.PROPERTY_ID, PR.PROPERTY_ID, P.BDRMS
	FROM PROPERTY P INNER JOIN PROPERTY PR ON P.BDRMS = PR.BDRMS
		WHERE P.PROPERTY_ID < PR.PROPERTY_ID
			ORDER BY P.PROPERTY_ID ASC, PR.PROPERTY_ID ASC;


--7.	List the office number, address, and monthly rent for properties 
--whose owners live in Washington State or own two-bedroom properties.
SELECT P.OFFICE_NUM, P.ADDRESS, P.MONTHLY_RENT
	FROM PROPERTY P INNER JOIN OWNER O ON P.OWNER_NUM = O.OWNER_NUM
		WHERE O.STATE = 'WA' 
		OR P.BDRMS = 2;


--8.	List the office number, address, and monthly rent for properties 
--whose owners live in Washington State and own a two-bedroom property.
SELECT P.OFFICE_NUM, P.ADDRESS, P.MONTHLY_RENT
	FROM PROPERTY P INNER JOIN OWNER O ON P.OWNER_NUM = O.OWNER_NUM
		WHERE O.STATE = 'WA' 
		AND P.BDRMS = 2;

--9.	List the office number, address, and monthly rent for properties 
--whose owners live in Washington State but do not own two-bedroom properties.
SELECT P.OFFICE_NUM, P.ADDRESS, MONTHLY_RENT, P.BDRMS, O.STATE
	FROM PROPERTY P INNER JOIN OWNER O ON P.OWNER_NUM = O.OWNER_NUM
		WHERE O.STATE = 'WA' 
		AND NOT P.BDRMS = 2;
--10.	Find the service ID and property ID for each service request 
--whose estimated hours is greater than the number of estimated hours of at least 
--one service request on which the category number is 5.
--MUST USE ANY/ALL OPERATOR
SELECT SERVICE_ID, PROPERTY_ID
	FROM SERVICE_REQUEST
		WHERE EST_HOURS > ANY (SELECT EST_HOURS
									FROM SERVICE_REQUEST
										WHERE CATEGORY_NUMBER = 5);


--11.	List the address, square footage, owner number, service ID, number of estimated hours, 
--and number of spent hours for each service request on which the category number is 4.
SELECT ADDRESS, SQR_FT, OWNER_NUM, SERVICE_ID, EST_HOURS, SPENT_HOURS, CATEGORY_NUMBER
	FROM PROPERTY P INNER JOIN SERVICE_REQUEST SR ON P.PROPERTY_ID = SR.PROPERTY_ID
		WHERE SR.CATEGORY_NUMBER = 4;


--12.	Output the same information Exercise 11, but this time be sure each property is included 
--regardless of whether the property currently has any service requests.
--*Hint: Consider a different join type.
SELECT ADDRESS, SQR_FT, OWNER_NUM, SERVICE_ID, EST_HOURS, SPENT_HOURS, CATEGORY_NUMBER
	FROM PROPERTY P LEFT JOIN SERVICE_REQUEST SR ON P.PROPERTY_ID = SR.PROPERTY_ID;





--===========================================================================
--========================== Expected Output Tables =========================
--============Best used *AFTER* you've come up with your queries ============
--===========================================================================



/* 
Q1:
OFFICE_NUM	ADDRESS			MONTHLY_RENT	OWNER_NUM	FIRST_NAME	LAST_NAME
1		30 West Thomas Rd.	1400		BU106		Ernest		Burke
1		782 Queen Ln.		1900		AK102		Ceyda		Aksoy
1		9800 Sunbeam Ave.	1200		BI109		Nicole		Bianchi
1		105 North Illinois Rd.	1650		KO104		Jakub		Kowalczyk
1		887 Vine Rd.		1160		SI105		Haydon		Sims
1		8 Laurel Dr.		2050		MO100		Elle-May	Moore
2		447 Goldfield St.	1700		CO103		Meerab		Cole
2		594 Leatherwood Dr.	2750		KO104		Jakub		Kowalczyk
2		504 Windsor Ave.	1050		PA101		Makesh		Patel
2		891 Alton Dr.		1600		LO108		Janine		Lopez
2		9531 Sherwood Rd.	1100		JO110		Ammarah		Jones
2		2 Bow Ridge Ave.	1700		RE107		Seth		Redman

Q2:
PROPERTY_ID	DESCRIPTION												STATUS
1		A new strip light is needed for the kitchen.								Scheduled
2		New outlet has been requested for the first upstairs bedroom. (There is currently no outlet).		Scheduled
8		New paint job requested for the common area (lounge). 							Open
12		New sofa requested.											Open

Q3:
PROPERTY_ID	OFFICE_NUM	ADDRESS			EST_HOURS	SPENT_HOURS	OWNER_NUM	LAST_NAME
12		2		2 Bow Ridge Ave.	2		0		RE107		Redman

Q4:
OWNER_NUM	LAST_NAME
BI109		Bianchi
JO110		Jones
PA101		Patel
SI105		Sims

Q5:
OWNER_NUM	LAST_NAME
BI109		Bianchi
JO110		Jones
PA101		Patel
SI105		Sims


Q6:
PROPERTY_ID	PROPERTY_ID	BDRMS
1		4		3
1		7		3
1		10		3
1		12		3
2		6		4
3		5		2
3		9		2
3		11		2
4		7		3
4		10		3
4		12		3
5		9		2
5		11		2
7		10		3
7		12		3
9		11		2
10		12		3

Q7:
OFFICE_NUM	ADDRESS			MONTHLY_RENT
1		105 North Illinois Rd.	1650
1		782 Queen Ln.		1900
1		887 Vine Rd.		1160
1		9800 Sunbeam Ave.	1200
2		2 Bow Ridge Ave.	1700
2		447 Goldfield St.	1700
2		504 Windsor Ave.	1050
2		594 Leatherwood Dr.	2750
2		891 Alton Dr.		1600
2		9531 Sherwood Rd.	1100

Q8:
OFFICE_NUM	ADDRESS			MONTHLY_RENT
2		504 Windsor Ave.	1050
2		9531 Sherwood Rd.	1100

Q9:
OFFICE_NUM	ADDRESS			MONTHLY_RENT	BDRMS	STATE
1		105 North Illinois Rd.	1650		3	WA
1		782 Queen Ln.		1900		4	WA
2		2 Bow Ridge Ave.	1700		3	WA
2		447 Goldfield St.	1700		3	WA
2		594 Leatherwood Dr.	2750		5	WA
2		891 Alton Dr.		1600		3	WA

Q10:
SERVICE_ID	PROPERTY_ID
5		8
6		4
8		9

Q11:
ADDRESS			SQR_FT	OWNER_NUM	SERVICE_ID	EST_HOURS	SPENT_HOURS	CATEGORY_NUMBER
30 West Thomas Rd.	1600	BU106		2		1		0		4
782 Queen Ln.		2100	AK102		4		1		0		4


Q12:
ADDRESS			SQR_FT	OWNER_NUM	SERVICE_ID	EST_HOURS	SPENT_HOURS	CATEGORY_NUMBER
30 West Thomas Rd.	1600	BU106		2		1		0		4
782 Queen Ln.		2100	AK102		4		1		0		4
782 Queen Ln.		2100	AK102		7		1		0		2
9800 Sunbeam Ave.	1005	BI109		NULL		NULL		NULL		NULL
105 North Illinois Rd.	1750	KO104		6		4		2		1
887 Vine Rd.		1125	SI105		NULL		NULL		NULL		NULL
8 Laurel Dr.		2125	MO100		3		3		1		5
447 Goldfield St.	1675	CO103		NULL		NULL		NULL		NULL
594 Leatherwood Dr.	2700	KO104		5		10		0		3
504 Windsor Ave.	700	PA101		8		6		2		1
891 Alton Dr.		1300	LO108		NULL		NULL		NULL		NULL
9531 Sherwood Rd.	1075	JO110		1		2		1		2
2 Bow Ridge Ave.	1400	RE107		9		2		0		6


*/