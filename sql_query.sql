/*
	Common entry level SQL interview questions and answers.
	These questions appear in many interview preperation resources
	found online.
*/

-- 1. How do you find duplicates in a table?

/*
	To find the duplicates in a table, let's first create a table with some
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


-- 2. How do you delete duplicates from a table?

/*
 	We can delete duplicate rows by using a DELETE USING statement.
 	
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


-- 3. What is the difference between union and union all?

/*
 	The union operator combines two or more select statements into one result set.
 	UNION returns only DISTINCT values.  So no duplicate values in the final result set.
 	UNION ALL returns EVERYTHING including duplicates.
 	
 	Please note that to use UNION, each SELECT statement must 
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

-- 4. Difference between rank,row_number and dense_rank?

/*
 	RANK, DENSE_RANK and ROW_NUMBER are all analytical window functions.
 	RANK: Will rank a column but will skip a value if there are ties.
 	DENSE_RANK: Will rank a column bbut will NOT skip a value for ties.
 	ROW_NUMBER: Assigns a unique row number to each row.
 	
 	Let's display these functions with a simple table of users and salaries.
*/

DROP TABLE IF EXISTS user_salary;
CREATE TABLE user_salary (
	user_name TEXT,
	salary int
);

INSERT INTO user_salary (user_name, salary)
VALUES 
	('jaime', 100000),
	('robert', 105000),
	('elizabeth', 150000),
	('josh', 80000),
	('mary', 105000),
	('heather', 80000),
	('jennifer', 75000),
	('ken', 80000);

-- Lets use the window functions to show how they work.

SELECT
	user_name,
	salary,
	RANK() OVER (ORDER BY salary desc),
	DENSE_RANK() OVER (ORDER BY salary desc),
	ROW_NUMBER() OVER ()
FROM
	user_salary;

/*
 	The results are ordered by salary in descending order.
 	RANK: Shows that some user salaries tied, but then skips that amount until the next rank.
 	DENSE_RANK: Shows that some user salaries tied, but but does NOT skip anything and goes immediately to the next rank. 
 	ROW_NUMBER: Gives a unique row number to every row.
*/

-- Results:

user_name|salary|rank|dense_rank|row_number|
---------+------+----+----------+----------+
elizabeth|150000|   1|         1|         1|
mary     |105000|   2|         2|         2|
robert   |105000|   2|         2|         3|
jaime    |100000|   4|         3|         4|
josh     | 80000|   5|         4|         5|
heather  | 80000|   5|         4|         6|
ken      | 80000|   5|         4|         7|
jennifer | 75000|   8|         5|         8|


-- 5. Find records in a table which are not present in another table.

/*
 	This type of a join is called an anti-join.  An anti join does not have it's own syntax.
 	It is basically a left join (or right join) with a WHERE clause.
 	
 	Let's display this by performing a LEFT ANTI-JOIN.
 	
 	Let's create 2 different tables for this query.
*/

-- Create first table and add values
DROP TABLE IF EXISTS left_table;
CREATE TABLE left_table (
	id int
);

INSERT INTO left_table (id)
VALUES 
	(1),
	(2),
	(3),
	(4),
	(5),
	(6);

-- Create second table and add values
DROP TABLE IF EXISTS right_table;
CREATE TABLE right_table (
	id int
);

INSERT INTO right_table (id)
VALUES 
	(2),
	(2),
	(3),
	(6),
	(6),
	(6);

-- Let's perform our LEFT ANTI-JOIN

SELECT
	lt.id
FROM left_table AS lt
LEFT JOIN right_table AS rt
ON lt.id = rt.id
WHERE rt.id IS null;

/*
 	This query returns the values in the LEFT TABLE that are NOT
 	in the RIGHT TABLE.
*/

-- Results:

id|
--+
 1|
 4|
 5|

-- 6. Find second highest salary employees in each department.

/*
 	This question will require us to rank salaries and partition that ranking
 	by the department of each individual employee.
 	
 	I will also add a manager id column so as to use this table in the next question also.
*/
 
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
	emp_id int,
	emp_name TEXT,
	manager_id int,
	department TEXT,
	salary int
);

INSERT INTO employee (emp_id, emp_name, manager_id, department, salary)
VALUES
	(1, 'jaime', 0, 'IT', 85000),
	(2, 'robert', 1, 'IT', 75000),
	(3, 'lisa', 1, 'IT', 65000),
	(4, 'chris', 1, 'IT', 55000),
	(5, 'mary', 7, 'SALES', 55000),
	(6, 'richard', 7, 'SALES', 85000),
	(7, 'jane', 0, 'SALES', 80000),
	(8, 'trevor', 7, 'SALES', 65000),
	(9, 'joan', 12, 'HR', 55000),
	(10, 'jennifer', 12, 'HR', 71000),
	(11, 'trish', 12, 'HR', 58000),
	(12, 'marge', 0, 'HR', 70000);

-- Let's create a CTE (Common Table Expression) that assigns a rank value to each row by partition.
WITH get_salary_rank AS (
	SELECT
		emp_name,
		department,
		salary,
		DENSE_RANK() OVER (PARTITION BY department ORDER BY salary desc) AS rnk
	FROM
		employee
)

-- Select name, department and salary where the rank = 2 from the CTE result set.

SELECT
	emp_name,
	department,
	salary,
	rnk
FROM
	get_salary_rank
WHERE
	rnk = 2;

-- Results:

emp_name|department|salary|rnk|
--------+----------+------+---+
marge   |HR        | 70000|  2|
robert  |IT        | 75000|  2|
jane    |SALES     | 80000|  2|
 

-- 7. Find employees with greater salaries than their manager's salary.

/*
 	Using the employee salary from the previous question, we can 
 	find this answer using a sub-query in the where clause. I added
 	a sub-query to the select statement to show the manager salary also.
 	
*/

SELECT
	e1.emp_name,
	e1.department,
	e1.salary AS employee_salary,
	(SELECT salary from employee WHERE emp_id = e1.manager_id) AS manager_salary
FROM
	employee AS e1
WHERE
	e1.salary > (SELECT salary from employee WHERE emp_id = e1.manager_id);

-- Results:

emp_name|department|employee_salary|manager_salary|
--------+----------+---------------+--------------+
richard |SALES     |          85000|         80000|
jennifer|HR        |          71000|         70000|

-- 8. What is the difference between an inner and left join?

/*
 	An inner join will return only join matching rows between tables.
 	A left join will return all items in the left table and matching rows from the
 	right table.
 	
 	Using the left_table and right_table from question #5, we can see how they work.
 	
*/

-- Inner Join

SELECT
	lt.id
FROM
	left_table AS lt
INNER JOIN 
	right_table AS rt
ON
	lt.id = rt.id;

-- Results:


/*
 	These results exclude id #1 and #5 from the left_table because they do not exist in
 	the right_table.  It will also return a result for EVERY match that occurs in both
 	tables.
 	
*/
 

id|
--+
 2|
 2|
 3|
 6|
 6|
 6|
 
 -- Left Join

SELECT
	lt.id
FROM
	left_table AS lt
LEFT JOIN 
	right_table AS rt
ON
	lt.id = rt.id;

-- Results:

/*
 	These results include ALL rows from the left_table and only those that
 	match from the right table.
 	
*/

id|
--+
 1|
 2|
 2|
 3|
 4|
 5|
 6|
 6|
 6|


-- 9. Update a table and swap gender values.

/*
 	This question can be answered using a simple CASE statement in an update query.
 	
 	First, lets create a simple table where (M)ales have odd id numbers and (F)emales
 	have even id numbers.
 	
*/
 
DROP TABLE IF EXISTS people;
CREATE TABLE people (
	id serial,
	name TEXT,
	gender varchar(1)
);

INSERT INTO people (name, gender)
VALUES
	('mike', 'M'),
	('sarah', 'F'),
	('john', 'M'),
	('lisa', 'F'),
	('jacob', 'M'),
	('ellen', 'F'),
	('christopher', 'M'),
	('maria', 'F');

-- Let's take a look at the table.

SELECT * FROM people;

-- Results:

id|name       |gender|
--+-----------+------+
 1|mike       |M     |
 2|sarah      |F     |
 3|john       |M     |
 4|lisa       |F     |
 5|jacob      |M     |
 6|ellen      |F     |
 7|christopher|M     |
 8|maria      |F     |
 
-- Now lets UPDATE the table and swap the gender values.
 
UPDATE people
SET gender = 
	CASE
		WHEN gender = 'M' THEN 'F'
		ELSE 'M'
	END
WHERE
	gender IS NOT NULL;

-- Let's take a look at the UPDATED table

SELECT * FROM people;

-- Results:

id|name       |gender|
--+-----------+------+
 1|mike       |F     |
 2|sarah      |M     |
 3|john       |F     |
 4|lisa       |M     |
 5|jacob      |F     |
 6|ellen      |M     |
 7|christopher|F     |
 8|maria      |M     |


-- 10. Number of records in output with different kinds of join.

/*
 	Let's create two new tables to display the different types of joins.
 	
 	INNER JOIN
 	LEFT JOIN
 	RIGHT JOIN
 	FULL OUTER JOIN
 	CROSS JOIN 	
*/
 
DROP TABLE IF EXISTS left_names;
CREATE TABLE left_names (
	id text
);

INSERT INTO left_names
VALUES 
	('jaime'),
	('melissa'),
	('samuel'),
	('aaron'),
	('norma'),
	(NULL),
	('christopher');

DROP TABLE IF EXISTS right_names;
CREATE TABLE right_names (
	id text
);

INSERT INTO right_names
VALUES 
	('jaime'),
	('janet'),
	(NULL),
	('sonia'),
	('melissa'),
	('melissa'),
	('chris'),
	('jaime');

-- INNER JOIN
 
SELECT
	count(*) result_count
from
	(SELECT
		l.id
	FROM
		left_names AS l
	INNER JOIN 
		right_names AS r
	ON
		l.id = r.id) AS tmp

-- Inner-Query Results:
		
id     |
-------+
jaime  |
jaime  |
melissa|
melissa|
 
-- Outer-Query Results:
		
result_count|
------------+
           4|
           
-- LEFT JOIN
 
SELECT
	count(*) result_count
from
	(SELECT
		l.id
	FROM
		left_names AS l
	LEFT JOIN 
		right_names AS r
	ON
		l.id = r.id) AS tmp

-- Inner-Query Results:
		
id         |
-----------+
aaron      |
christopher|
jaime      |
jaime      |
melissa    |
melissa    |
norma      |
samuel     |
           | <-- NULL VALUE
 
-- Outer-Query Results:
		
result_count|
------------+
           9|
           
-- RIGHT JOIN
 
SELECT
	count(*) result_count
from
	(SELECT
		r.id
	FROM
		left_names AS l
	RIGHT JOIN 
		right_names AS r
	ON
		l.id = r.id) AS tmp

-- Results:
		
-- Inner-Query Results:
		
id     |
-------+
chris  |
jaime  |
jaime  |
janet  |
melissa|
melissa|
sonia  |
       | <-- NULL VALUE
 
-- Outer-Query Results:
		
result_count|
------------+
           8|
           
-- FULL OUTER JOIN
 
SELECT
	count(*) result_count
from
	(SELECT
		l.id AS left_table,
		r.id AS right_table
	FROM
		left_names AS l
	FULL OUTER JOIN 
		right_names AS r
	ON
		l.id = r.id) AS tmp

-- Results:
		
left_table |right_table|
-----------+-----------+
aaron      |           |
           |chris      |
christopher|           |
jaime      |jaime      |
jaime      |jaime      |
           |janet      |
melissa    |melissa    |
melissa    |melissa    |
norma      |           |
samuel     |           |
           |           | <-- Left NULL VALUE
           |sonia      |
           |           | <-- Right NULL VALUE
		
result_count|
------------+
          13|
           
-- CROSS JOIN
 
SELECT
	count(*) result_count
from
	(SELECT
		l.id
	FROM
		left_names AS l
	CROSS JOIN 
		right_names AS r) AS tmp

-- Results:

/*
 	Every row in the left table will be joined to every row in the right table. 	
*/


result_count|
------------+
          36|
          
-- 11. What is the difference between DELETE, TRUNCATE and DROP statements?

/*
 	DELETE is a DML (Data Manipulation Language) command that is used to delete rows from a table.
	TRUNCATE is a DDL (Data Definition Language) command that is used to empty/delete  **ALL** rows from a table but maintains the tables structure.
	DROP is a DDL (Data Definition Language) command that is used to completly delete the table and its structure from the schema/database. 	
*/
          
DROP TABLE IF EXISTS generic_table;
CREATE TABLE generic_table (
	id int
);

INSERT INTO generic_table
VALUES 
	(1),
	(2),
	(3),
	(4),
	(5),
	(6);
          
--  Let's take a look at our new table.         
          
SELECT * FROM generic_table; 

-- Results:

id|
--+
 1|
 2|
 3|
 4|
 5|
 6|
 
-- Let's delete all rows with even number ID's.
          
DELETE FROM generic_table
WHERE (id % 2) = 0;
          
--  Let's take a look at our table after the DELETE statement.         
          
SELECT * FROM generic_table;

-- Results:

id|
--+
 1|
 3|
 5|
 
 -- Let's use the truncate statement.
 
TRUNCATE TABLE generic_table;

--  Let's take a look at our table after the TRUNCATE statement.         
          
SELECT * FROM generic_table;
 
-- Results:

id|
--+

 -- Let's use the drop statement.
 
DROP TABLE generic_table;

--  Let's take a look at our table after the DROP statement.         
          
SELECT * FROM generic_table;

-- This results in an error. 
-- **SQL Error [42P01]: ERROR: relation "generic_table" does not exist**

-- 12. What is the difference between the NOW() and CURRENT_DATE functions?

/*
 	NOW() returns the timestamp (YYYY-MM-DD HH:MM:SS) of when the function was executed.
	CURRENT_DATE returns the date of the current day (YYYY-MM-DD).	
*/

SELECT 
	now(),
	current_date;

-- Results:

now                          |current_date|
-----------------------------+------------+
2022-12-04 07:19:52.891 -0600|  2022-12-04|

-- 13. What is the difference between the �IN� and �BETWEEN� condition operators?

/*
 	IN is used to check for values contained in a specific set of values.
	BETWEEN is used to return rows within a range of values.	
*/

-- Let's create a table

DROP TABLE IF EXISTS student_grades;
CREATE TABLE student_grades (
	student_name TEXT,
	score int
);

INSERT INTO student_grades (student_name, score)
VALUES
	('john', 95),
	('mary', 80),
	('jacob', 79),
	('calvin', 98),
	('jennifer', 100),
	('chris', 89),
	('brenda', 90),
	('michael', 71),
	('xavier', 69);

-- Let's use the IN operator to returns students who missed the next letter grade by one point.

SELECT
	student_name,
	score
FROM 
	student_grades
WHERE score IN (69, 79, 89);

-- Results:

student_name|score|
------------+-----+
jacob       |   79|
chris       |   89|
xavier      |   69|


-- Let's use the BETWEEN operator to returns students who have a score between 85 and 95.

SELECT
	student_name,
	score
FROM 
	student_grades
WHERE score BETWEEN 85 AND 95;

-- Results:

student_name|score|
------------+-----+
john        |   95|
chris       |   89|
brenda      |   90|

-- 14. What is the difference between the WHERE and the HAVING clause?

/*
 	Both of these clauses are used for filtering results, but this question is easier to understand if you understand 
 	that there is a difference between 'The order of execution' and 'The order of writing' an SQL query.
 	
 	The order of execution is as follows:
 	
 		1. FROM/JOIN
 		2. WHERE
 		3. GROUP BY
 		4. HAVING
 		5. SELECT	
 		6. Distinct
 		7. ORDER BY
 		8. LIMIT / OFFSET
 		
 	WHERE is used to filter individual rows BEFORE groupings are made.  Which is why aggregate functions CANNOT be used in a where clause
 	because the GROUP does NOT exist when the WHERE clause if filtering.
 	
 	HAVING is used for filtering values from a GROUP which would allow you to use aggregate functions within its conditions.
 		
*/

-- Let's create create a table where we can illustrate the differences.

DROP TABLE IF EXISTS avg_student_grades;
CREATE TABLE avg_student_grades (
	student_name TEXT,
	score int
);

INSERT INTO avg_student_grades (student_name, score)
VALUES
	('john', 89),
	('mary', 99),
	('jacob', 79),
	('john', 83),
	('mary', 92),
	('jacob', 75);

-- Let's use a WHERE clause to find all test scores greater than 80.

SELECT
	student_name,
	score
FROM
	avg_student_grades
WHERE
	score > 80
ORDER BY
	student_name;

-- Results:

student_name|score|
------------+-----+
john        |   89|
john        |   83|
mary        |   99|
mary        |   92|

-- Let's use a HAVING clause to find the MAX() test score in a group for test scores greater than 80.

SELECT
	student_name,
	max(score)AS max_score
FROM
	avg_student_grades
GROUP BY
	student_name
HAVING 
	max(score) > 80
ORDER BY
	student_name;

-- Results:

student_name|max_score|
------------+---------+
john        |       89|
mary        |       99|

-- 15. From a table of names, write a query that only returns EVEN number rows.

/*
 	For this query we will use the ROW_NUMBER() window function in a CTE (Common Table Expression)
 	and the modulo operator.  For easier tracking, I will use common MALE names for odd number entries and
 	FEMALE names for the even number entries.
 		
*/

DROP TABLE IF EXISTS common_names;
CREATE TABLE common_names (
	user_name TEXT
);

INSERT INTO common_names (user_name)
VALUES
	('aaron'),
	('mary'),
	('luke'),
	('jennifer'),
	('mark'),
	('laura'),
	('john'),
	('olivia');

-- We will use a CTE to give each entry a unique row number.

WITH get_row_number as (
	SELECT
		ROW_NUMBER() OVER () AS rn,
		user_name
	FROM
		common_names
)
-- Now let's select only the names where the newly assigned row number is EVEN.
SELECT
	rn AS even_id,
	user_name
FROM
	get_row_number
WHERE (rn % 2) = 0;

-- 16. How can we copy the contents of one table to a new table?

-- Let's create a new table.

DROP TABLE IF EXISTS original_table;
CREATE TABLE original_table (
	user_id serial,
	user_name TEXT,
	user_age smallint
);

INSERT INTO original_table (user_name, user_age)
VALUES
	('william', 34),
	('marjorie', 22),
	('larence', 55),
	('maria', 19),
	('moses', 40),
	('britney', 39),
	('jake', 27),
	('barbara', 42);

-- First we have to create a new table with the same structure as the original table and no data.

DROP TABLE IF EXISTS copied_table;
CREATE TABLE copied_table AS 
TABLE original_table
WITH NO DATA;

-- This statement creates an empty table with the same structure as the original
-- table.  Now we can insert (copy) the data from the original table.

INSERT INTO copied_table
(SELECT * FROM original_table);

-- We can take a look at our copied table.

SELECT * FROM copied_table;

-- Results:

user_id|user_name|user_age|
-------+---------+--------+
      1|william  |      34|
      2|marjorie |      22|
      3|larence  |      55|
      4|maria    |      19|
      5|moses    |      40|
      6|britney  |      39|
      7|jake     |      27|
      8|barbara  |      42|
      
-- Let us now DROP the original table.

DROP TABLE original_table;

-- 17. In string pattern matching, what is the difference between LIKE and ILIKE?

/*
 	LIKE and ILIKE are both used in charater-based pattern matching.
 	
 	LIKE is used for case-sensitive pattern matching.
 	ILIKE is used for case-insensitive pattern matching.
 		
*/

-- Let's create a table with case-sensitive data.

DROP TABLE IF EXISTs case_sensitivity;
CREATE TABLE case_sensitivity (
	crazy_case TEXT 
);

INSERT INTO case_sensitivity (crazy_case)
VALUES
	('jaime'),
	('JAIME'),
	('jAImE');

-- Let's see what LIKE pattern matching returns when using upper-case characters.

SELECT
	*
FROM case_sensitivity
WHERE crazy_case LIKE '%JAIME%';

-- Results:

crazy_case|
----------+
JAIME     |

-- Now let's see what ILIKE pattern matching returns.

SELECT
	*
FROM case_sensitivity
WHERE crazy_case ILIKE '%JAIME%';

-- Results:

crazy_case|
----------+
jaime     |
JAIME     |
jAImE     |

/*
 	Make note that ILIKE CANNOT use an index created on a case-sensitive column
 	for optimization.
 		
*/



















          
          
          

