/*
	Simple Monthly Reports
	Author: Jaime M. Shaker
	Email: jaime.m.shaker@gmail.com or jaime@shaker.dev
	Website: https://www.shaker.dev
	LinkedIn: https://www.linkedin.com/in/jaime-shaker/
	
	File Name: monthly_reports.sql
	Description: A simple script to display the flexability of SQL/PL functions.
	
*/

-- Create a table that contains of the monthly sales
DROP TABLE IF EXISTS monthly_sales;
CREATE TABLE monthly_sales (
	sales_id int GENERATED ALWAYS AS IDENTITY,
	product_name varchar(20),
	price int,
	transaction_time timestamp
);
-- Insert monthly sales data
INSERT INTO monthly_sales (
	product_name,
	price,
	transaction_time
)
VALUES
	('shirt', 10, '2021-01-14 06:59:43.206'),
	('pants', 20, '2021-01-20 11:50:22.301'),
	('shirt', 10, '2021-01-05 08:05:10.428'),
	('dress', 30, '2021-02-14 09:39:56.195'),
	('pants', 20, '2021-02-22 07:00:19.667'),
	('dress', 30, '2021-03-13 11:56:23.786'),
	('hat', 15, '2021-03-20 04:36:54.123');

-- Test the new table	
SELECT 
	* 
FROM 
	monthly_sales;
-- Results
/*
sales_id|product_name|price|transaction_time       |
--------+------------+-----+-----------------------+
       1|shirt       |   10|2021-01-14 06:59:43.206|
       2|pants       |   20|2021-01-20 11:50:22.301|
       3|shirt       |   10|2021-01-05 08:05:10.428|
       4|dress       |   30|2021-02-14 09:39:56.195|
       5|pants       |   20|2021-02-22 07:00:19.667|
       6|dress       |   30|2021-03-13 11:56:23.786|
       7|hat         |   15|2021-03-20 04:36:54.123|
*/

-- Select data given a specific month. Using the months number (Jan=1, Feb=2, Mar=3...)
SELECT 
	* 
FROM 
	monthly_sales
WHERE
	EXTRACT('month' FROM transaction_time) = 1;
	
-- Results
/*
sales_id|product_name|price|transaction_time       |
--------+------------+-----+-----------------------+
       1|shirt       |   10|2021-01-14 06:59:43.206|
       2|pants       |   20|2021-01-20 11:50:22.301|
       3|shirt       |   10|2021-01-05 08:05:10.428|
*/       
       
-- Create a function that returns a table with data
-- from a parameter.

DROP FUNCTION get_monthly_sales;
CREATE OR REPLACE FUNCTION get_monthly_sales (
	-- This is the months number
	numerical_month int
)
	-- These are the values returned by our query
	RETURNS TABLE (
		transaction_month TEXT,
		number_of_transactions int,
		total_sales int
	)
-- Specify language used.
LANGUAGE plpgsql
AS
$$
	DECLARE 
		-- Declare a variable that we pass the parameter value to
		num_month int := numerical_month;
	BEGIN
		RETURN query
			-- Start the actual query
			SELECT 
				-- Convert the int into text and pass it to_date(), then pass it
				-- to to_char() to get the actual month name.
				to_char(to_date(num_month::TEXT, 'MM'), 'Month'),
				-- The number of transactions
				count(*)::int,
				-- The total from all sales
				sum(price)::int
			FROM 
				-- Our newly created table above
				monthly_sales
			WHERE
				-- Extract the month from the timestamp and compare it
				-- to our parameter value.
				EXTRACT('month' FROM transaction_time) = num_month;
	END;
$$

-- Pass the numerical Month value to get only that months results.
SELECT
	transaction_month,
	number_of_transactions,
	total_sales
FROM get_monthly_sales(1);

/*

transaction_month|number_of_transactions|total_sales|
-----------------+----------------------+-----------+
January          |                     3|         40|

*/

SELECT
	transaction_month,
	number_of_transactions,
	total_sales
FROM get_monthly_sales(2);

/*

transaction_month|number_of_transactions|total_sales|
-----------------+----------------------+-----------+
February         |                     2|         50|

*/

SELECT
	transaction_month,
	number_of_transactions,
	total_sales
FROM get_monthly_sales(3);

/*

transaction_month|number_of_transactions|total_sales|
-----------------+----------------------+-----------+
March            |                     2|         45|

*/


-- I hope that helps!





