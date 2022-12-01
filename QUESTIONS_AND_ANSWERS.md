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







