/*
	Common entry level SQL interview questions and answers.
	These questions appear in many interview preperation resources
	found online.
*/

-- 1- How to find duplicates in a table?

/*
	To find the duplicates in a table, let's create a table with some
	duplicate rows.
*/

DROP TABLE IF EXISTS duplicate_names;
CREATE TABLE duplicate_names (
	id serial,
	name text
);

INSERT INTO duplicate_names (name)
VALUES
	('jaime'),
	('robert'),
	('william'),
	('lisa'),
	('robert'),
	('john'),
	('jane'),
	('lisa'),
	('robert'),
	('fred');

-- Run a select * statement to see all of our entries.

SELECT * FROM duplicate_names;

-- Results:

id|name   |
--+-------+
 1|jaime  |
 2|robert |
 3|william|
 4|lisa   |
 5|robert |
 6|john   |
 7|jane   |
 8|lisa   |
 9|robert |
10|fred   |

/*
	We can use the COUNT() function to find all duplicate rows.
*/

SELECT
	-- Get the column.
	name,
	-- Count how many times this name occurs.
	count(*)
FROM
	duplicate_names
GROUP BY 
	-- Using an aggregate function forces us to group all like names together.
	name
HAVING 
	-- Only select values that have a count greater than one (multiple entries).
	count(*) > 1;

-- Results:

/*
	The results show all the names that appear more than once and their count.
*/

name  |count|
------+-----+
lisa  |    2|
robert|    3|


-- 2- How to delete duplicates from a table

/*
 	We can delete duplicate rows by using a delete statement.
 	
	We can use the table created in the previous question to learn how to delete
	those duplicates.
*/

DELETE 
FROM 
	-- Add an alias to the id's we wish to keep
	duplicate_names AS d1
USING 
	-- Add an alias to the duplicate id's
	duplicate_names AS  d2
WHERE 
	-- This statement will remove the greater value id's.
	d1.id > d2.id
AND 
	-- This statement ensures that both values are identical.
	d1.name = d2.name;

/*
 	It is always good practice to run a DELETE USING statement as a SELECT statement FIRST to ensure
 	your query is working correctly.
 	
	Let us run our previous query to check for duplicates.
*/

SELECT
	name,
	count(*)
FROM
	duplicate_names
GROUP BY
	name
HAVING
	count(*) > 1;

-- Results:

name|count|
----+-----+

-- Lets check the original table's content.

SELECT * FROM duplicate_names;

-- Results:

id|name   |
--+-------+
 1|jaime  |
 2|robert |
 3|william|
 4|lisa   |
 6|john   |
 7|jane   |
10|fred   |

/*
 	As we can see all higher value id's have been deleted.
*/


-- 3- Difference between union and union all

/*
 	The union operator combines two or more select statements into one result set.
 	UNION returns only DISTINCT values.  So no duplicate values in the final result set.
 	UNION ALL returns EVERYTHING including duplicates.
 	
 	Please note that To use UNION, each SELECT statement must 
 		1. Have the same number of columns selected.
 		2. Have the same number of column expressions.
 		3. Have the same data type.
 		4. Have them in the same order.
 	
 	Let's create two small tables to illustrate this.
*/

DROP TABLE IF EXISTS coolest_guy_ever;
CREATE TABLE coolest_guy_ever (
	name TEXT,
	year smallint
);

INSERT INTO coolest_guy_ever (name, year)
VALUES
	('jaime shaker', '1998'),
	('jame dean', '1954'),
	('arthur fonzarelli', '1960');

DROP TABLE IF EXISTS sexiest_guy_ever;
CREATE TABLE sexiest_guy_ever (
	name TEXT,
	year smallint
);

INSERT INTO sexiest_guy_ever (name, year)
VALUES
	('brad pitt', '1994'),
	('jaime shaker', '1998'),
	('george clooney', '2001');

-- Lets use a simple UNION

SELECT * FROM coolest_guy_ever
UNION
SELECT * FROM sexiest_guy_ever;

-- Results: (only distinct entries)

name             |year|
-----------------+----+
jame dean        |1954|
george clooney   |2001|
brad pitt        |1994|
arthur fonzarelli|1960|
jaime shaker     |1998|

-- Lets use a simple UNION ALL

SELECT * FROM coolest_guy_ever
UNION ALL
SELECT * FROM sexiest_guy_ever;

-- Results: (returns duplicate entries)

name             |year|
-----------------+----+
jaime shaker     |1998| <---
jame dean        |1954|
arthur fonzarelli|1960|
brad pitt        |1994|
jaime shaker     |1998| <--- 
george clooney   |2001|

4- Difference between rank,row_number and dense_rank
5- Find records in a table which are not present in another table
6- Find second highest salary employees in each department
7- Find employees with salary more than their manager's salary
8- Difference between inner and left join
9- update a table and swap gender values.
10- Number of records in output with different kinds of join.












