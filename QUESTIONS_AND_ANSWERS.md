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