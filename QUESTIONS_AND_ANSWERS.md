# Common SQL interview Questions and Answers.
### by jaime.m.shaker@gmail.com


❗ **Note** ❗

These entry level SQL interview questions appear in many interview preperation resources found online.  

#### 1. How do you find duplicates in a table?

To find the duplicates in a table, let's first create a table with some
	duplicate rows.

````sql
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
````

Run a **select** **\*** statement to see all of our entries.

````sql
SELECT * FROM duplicate_names;
````

**Results:**

id|name   |
--|-------|
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

We can use the **COUNT()** function to find all duplicate rows.

````sql
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
````

**Results:**

The results show all the names that appear more than once and their count.

name  |count|
------|-----|
lisa  |    2|
robert|    3|

#### 2. How do you delete duplicates from a table?

We can delete duplicate rows by using a **DELETE USING** statement.
 	
We can use the table created in the previous question to learn how to delete those duplicates.

````sql
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
````

It is always good practice to run a DELETE USING statement as a SELECT statement FIRST to ensure your query is working correctly.
 	
Let us run our previous query to check again for duplicates.

````sql
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
````
Lets check the original table's content.  From the results returned, we can see that duplicates have been deleted.

````sql
SELECT * FROM duplicate_names;
````

**Results:**

id|name   |
--|-------|
 1|jaime  |
 2|robert |
 3|william|
 4|lisa   |
 6|john   |
 7|jane   |
10|fred   |

#### 3. What is the difference between union and union all?

The union operator combines two or more **SELECT** statements into one result set. 
* **UNION** returns only DISTINCT values.  So no duplicate values in the final result set.
* **UNION ALL** returns EVERYTHING including duplicates.
 	
Please note that to use UNION, each SELECT statement must 
1. Have the same number of columns selected.
2. Have the same number of column expressions.
3. Have the same data type.
 4. Have them in the same order.
 	
Let's create two small tables to illustrate this.

````sql
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
````
Lets use a simple UNION with our SQL statements.

````sql
SELECT * FROM coolest_guy_ever
UNION
SELECT * FROM sexiest_guy_ever;
````
**Results:** (Only distinct values are returned)

name             |year|
-----------------|----|
jame dean        |1954|
george clooney   |2001|
brad pitt        |1994|
arthur fonzarelli|1960|
jaime shaker     |1998|

Lets use a simple UNION ALL.

````sql
SELECT * FROM coolest_guy_ever
UNION ALL
SELECT * FROM sexiest_guy_ever;
````
**Results:** (Returns duplicate values)

name             |year|
-----------------|----|
**jaime shaker**     |**1998**| 
jame dean        |1954|
arthur fonzarelli|1960|
brad pitt        |1994|
**jaime shaker**     |**1998**| 
george clooney   |2001|

#### 4. Difference between rank,row_number and dense_rank?

RANK, DENSE_RANK and ROW_NUMBER are all analytical window functions.
* **RANK**: Will rank a column but will skip a value if there are ties.
* **DENSE_RANK**: Will rank a column bbut will NOT skip a value for ties.
* **ROW_NUMBER**: Assigns a unique row number to each row.
 	
Let's display these functions with a simple table of users and salaries.

````sql
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
````
Lets use the window functions to show how they work.

````sql
SELECT
	user_name,
	salary,
	RANK() OVER (ORDER BY salary desc),
	DENSE_RANK() OVER (ORDER BY salary desc),
	ROW_NUMBER() OVER ()
FROM
	user_salary;
````

The results are ordered by salary in descending order.
* **RANK**: Shows that some user salaries tied, but then skips that amount until the next rank.
* **DENSE_RANK**: Shows that some user salaries tied, but but does NOT skip anything and goes immediately to the next rank. 
* **ROW_NUMBER**: Gives a unique row number to every row.

**Results:**

user_name|salary|rank|dense_rank|row_number|
---------|------|----|----------|----------|
elizabeth|150000|   1|         1|         1|
mary     |105000|   2|         2|         2|
robert   |105000|   2|         2|         3|
jaime    |100000|   4|         3|         4|
josh     | 80000|   5|         4|         5|
heather  | 80000|   5|         4|         6|
ken      | 80000|   5|         4|         7|
jennifer | 75000|   8|         5|         8|

#### 5. Find records in a table which are not present in another table.

This type of a join is called an **anti-join**.  An anti-join does not have it's own syntax.
It is basically a left join (or right join) with a WHERE clause.
 	
Let's display this by performing a **LEFT ANTI-JOIN**.
 	
Let's create 2 different tables for this query.

````sql
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
````

````sql
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
````

Let's perform our **LEFT ANTI-JOIN**.

````sql
SELECT
	lt.id
FROM left_table AS lt
LEFT JOIN right_table AS rt
ON lt.id = rt.id
WHERE rt.id IS null;
````

**Results:**

This query returns the values in the LEFT TABLE that are **NOT**
in the RIGHT TABLE.

id|
--|
 1|
 4|
 5|

 #### 6. Find second highest salary employees in each department.

This question will require us to rank salaries and partition that ranking
by the department of each individual employee.
 	
I will also add a manager id column so as to use this table in the next question also.

````sql
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
````

Let's create a CTE (**Common Table Expression**) that assigns a rank value to each row by partition.

````sql
WITH get_salary_rank AS (
	SELECT
		emp_name,
		department,
		salary,
		DENSE_RANK() OVER (PARTITION BY department ORDER BY salary desc) AS rnk
	FROM
		employee
)
````
Now, lets select **name**, **department** and **salary** where the rank = 2 from the CTE result set.

````sql
SELECT
	emp_name,
	department,
	salary,
	rnk
FROM
	get_salary_rank
WHERE
	rnk = 2;
````

**Results:**

emp_name|department|salary|rnk|
--------|----------|------|---|
marge   |HR        | 70000|  2|
robert  |IT        | 75000|  2|
jane    |SALES     | 80000|  2|

#### 7. Find employees with greater salaries than their manager's salary.

Using the employee salary from the previous question, we can 
find this answer using a sub-query in the where clause. I added
a sub-query to the select statement to show the manager salary also.

````sql
SELECT
	e1.emp_name,
	e1.department,
	e1.salary AS employee_salary,
	(SELECT salary from employee WHERE emp_id = e1.manager_id) AS manager_salary
FROM
	employee AS e1
WHERE
	e1.salary > (SELECT salary from employee WHERE emp_id = e1.manager_id);
````

**Results:**

emp_name|department|employee_salary|manager_salary|
--------|----------|---------------|--------------|
richard |SALES     |          85000|         80000|
jennifer|HR        |          71000|         70000|

#### 8. Difference between inner and left join?

An **INNER JOIN** will return only join matching rows between tables.
A **LEFT JOIN** will return all items in the left table and matching rows from the right table.
 	
Using the left_table and right_table from question #5, we can see how they work.

**INNER JOIN**:

````sql
SELECT
	lt.id
FROM
	left_table AS lt
INNER JOIN 
	right_table AS rt
ON
	lt.id = rt.id;
````

**Results:**

These results exclude id **#1** and **#5** from the left_table because they do not exist in the right_table.  It will also return a result for EVERY match that occurs in both tables.

id|
--|
 2|
 2|
 3|
 6|
 6|
 6|

 **LEFT JOIN**:

````sql
SELECT
	lt.id
FROM
	left_table AS lt
LEFT JOIN 
	right_table AS rt
ON
	lt.id = rt.id;
````

**Results:**

These results include **ALL** rows from the left_table and only those that match from the right table.

id|
--|
 1|
 2|
 2|
 3|
 4|
 5|
 6|
 6|
 6|

 