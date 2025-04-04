-- Exercise 6 Part 1
-- Jackson Mundy 10.28.2023

-- 1.
-- Return the property ID, rent, and owner number where the square ft is over 450 and list them in descending order based on the rent
SELECT PROPERTY_ID, MONTHLY_RENT, OWNER_NUM
	FROM PROPERTY
		WHERE SQR_FT > 450
			ORDER BY MONTHLY_RENT DESC;

-- 2.
-- Return the category number, and the sum of the estimated hours where the status is scheduled or open
-- Make sure you name the computed column 
-- Group the results by the category number

SELECT CATEGORY_NUMBER, SUM(EST_HOURS) AS AVERAGE_EST_HOURS
	FROM SERVICE_REQUEST
		WHERE STATUS = 'Scheduled' 
		OR STATUS = 'Open'
			GROUP BY CATEGORY_NUMBER;
-- Just wanted to view the table
SELECT *
	FROM SERVICE_REQUEST;

-- 3.
-- Return the category number, and the sum of the estimated hours where the status starts with problem
-- Make sure you name the computed column 
-- Group the results by the category number where the  sum of hours is bigger than 1
SELECT CATEGORY_NUMBER, SUM(EST_HOURS) AS AVERAGE_EST_HOURS
	FROM SERVICE_REQUEST
		WHERE STATUS LIKE 'Problem%'
			GROUP BY CATEGORY_NUMBER
				HAVING SUM(EST_HOURS)> 1;
				