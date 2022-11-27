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
3- Difference between union and union all
4- Difference between rank,row_number and dense_rank
5- Find records in a table which are not present in another table
6- Find second highest salary employees in each department
7- Find employees with salary more than their manager's salary
8- Difference between inner and left join
9- update a table and swap gender values.
10- Number of records in output with different kinds of join.












