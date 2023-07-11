/*
	Differences between a Common Table Expression (CTE) and a subquery.

	** What is a subquery?
	
	A subquery is a query that is define inside of another query.
	Let's create a table and give an example of a subquery.
	
	I am using postgres v13.  Here is a db fiddle of the table.
	
	https://www.db-fiddle.com/f/hkgEEdGCJBbaEvZTGtzY1M/0

*/

DROP TABLE IF EXISTS grapplers;
CREATE TABLE grapplers (
	grappler_id int GENERATED ALWAYS AS IDENTITY,
	first_name varchar(100) UNIQUE NOT NULL,
	team varchar(100) NOT NULL,
	belt_rank varchar(20) NOT NULL,
	wins int NOT NULL,
	losses int NOT NULL,
	PRIMARY KEY (grappler_id)
);

INSERT INTO grapplers (
	first_name,
	team,
	belt_rank,
	wins,
	losses
)
VALUES
	('chris', 'gracie barra', 'blue', 1, 3),
	('rick', 'carlson gracie team', 'white', 4, 1),
	('ronald', 'checkmat', 'brown', 5, 7),
	('david', 'gracie barra', 'white', 3, 3),
	('fred', 'checkmat', 'blue', 5, 2),
	('abe', 'atos jiu-jitsu', 'blue', 10, 1),
	('zach', 'atos jiu-jitsu', 'white', 0, 3),
	('michael', 'checkmat', 'white', 6, 0),
	('aldo', 'checkmat', 'purple', 2, 3),
	('william', 'carlson gracie team', 'purple', 7, 3),
	('john', 'gracie barra', 'blue', 4, 1),
	('duane', 'carlson gracie team', 'blue', 1, 1),
	('james', 'atos jiu-jitsu', 'purple', 5, 4),
	('jaime', 'gracie barra', 'purple', 8, 2),
	('samuel', 'carlson gracie team', 'brown', 9, 0),
	('henry', 'atos jiu-jitsu', 'brown', 2, 5);

-- Lets take a look at the table

SELECT * FROM grapplers;

grappler_id|first_name|team               |belt_rank|wins|losses|
-----------+----------+-------------------+---------+----+------+
          1|chris     |gracie barra       |blue     |   1|     3|
          2|rick      |carlson gracie team|white    |   4|     1|
          3|ronald    |checkmat           |brown    |   5|     7|
          4|david     |gracie barra       |white    |   3|     3|
          5|fred      |checkmat           |blue     |   5|     2|
          6|abe       |atos jiu-jitsu     |blue     |  10|     1|
          7|zach      |atos jiu-jitsu     |white    |   0|     3|
          8|michael   |checkmat           |white    |   6|     0|
          9|aldo      |checkmat           |purple   |   2|     3|
         10|william   |carlson gracie team|purple   |   7|     3|
         11|john      |gracie barra       |blue     |   4|     1|
         12|duane     |carlson gracie team|blue     |   1|     1|
         13|james     |atos jiu-jitsu     |purple   |   5|     4|
         14|jaime     |gracie barra       |purple   |   8|     2|
         15|samuel    |carlson gracie team|brown    |   9|     0|
         16|henry     |atos jiu-jitsu     |brown    |   2|     5|


-- What is the AVG wins per team?
         
SELECT
	team AS BJJ_Team,
	round(avg(wins), 2) AS avg_team_wins
FROM
	grapplers
GROUP BY -- AGGREGATE FUNCTIONS (AVG, SUM, COUNT...) require TO GROUP BY field names.
	team
ORDER BY
	avg_team_wins DESC;
         
bjj_team           |avg_team_wins|
-------------------+-------------+
carlson gracie team|         5.25|
checkmat           |         4.50|
atos jiu-jitsu     |         4.25|
gracie barra       |         4.00|

-- What if I only want to see teams where the avg_team_wins is >= 4.5?
         
SELECT
	team AS BJJ_Team,
	round(avg(wins), 2) AS avg_team_wins
FROM
	grapplers
WHERE
	round(avg(wins), 2) > 4.5
GROUP BY
	team
ORDER BY
	avg_team_wins DESC;

-- This will result in an error because aggregate functions are not allowed in a where clause.

SQL Error [42803]: ERROR: aggregate functions are not allowed in WHERE

-- We can add a HAVING clause because aggregate functions are allowed in it.
         
SELECT
	team AS BJJ_Team,
	round(avg(wins), 2) AS avg_team_wins
FROM
	grapplers
GROUP BY
	team
HAVING
	round(avg(wins), 2) >= 4.5
ORDER BY
	avg_team_wins DESC;     
         
         
bjj_team           |avg_team_wins|
-------------------+-------------+
carlson gracie team|         5.25|
checkmat           |         4.50|

/*
	What is the difference between the WHERE and the HAVING clause?
	Both of these clauses are used for filtering results, but this question is easier to understand if you understand that 
	there is a difference between 'The order of execution' and 'The order of writing' an SQL query.

	The order of execution is as follows:

		1. FROM/JOIN
		2. WHERE
		3. GROUP BY
		4. HAVING
		5. SELECT	
		6. Distinct
		7. ORDER BY
		8. LIMIT / OFFSET
		
	**WHERE** is used to filter individual rows BEFORE groupings are made. Which is why aggregate functions CANNOT be used in a where clause 
	because the GROUP does NOT exist when the WHERE clause if filtering.
	
	**HAVING** is used for filtering values from a GROUP which would allow you to use aggregate functions within its conditions.
*/ 

-- Let's use a subquery to get the same results.

SELECT
	BJJ_Team,
	avg_team_wins
FROM
	(SELECT
		team AS BJJ_Team,
		round(avg(wins), 2) AS avg_team_wins
	FROM
		grapplers
	GROUP BY
		team) AS inner_query
WHERE
	avg_team_wins >= 4.5;

bjj_team           |avg_team_wins|
-------------------+-------------+
carlson gracie team|         5.25|
checkmat           |         4.50|

-- The inner_query did the aggregation and the outer query allows us to filter it.
-- Let's use a CTE to get the same results.

-- A CTE will allow us to move the inner_query and define it seperately.
-- This makes the query easier to read and it's less of a performance hit on the server.
-- With a small query, probably not a big deal.  But this allows you simplify code.

WITH cte_get_avg_wins AS (
	SELECT
		team AS BJJ_Team,
		round(avg(wins), 2) AS avg_team_wins
	FROM
		grapplers
	GROUP BY
		team
)
SELECT
	BJJ_Team,
	avg_team_wins
FROM
    cte_get_avg_wins     
WHERE
	avg_team_wins >= 4.5;        
         
bjj_team           |avg_team_wins|
-------------------+-------------+
carlson gracie team|         5.25|
checkmat           |         4.50| 

-- Let's say we wanted to rank grapplers by their belt rank.  We can use the rank() or dense_rank() 
-- window function.

SELECT
	first_name,
	team AS BJJ_Team,
	belt_rank,
	wins,
	DENSE_RANK() OVER (PARTITION BY belt_rank ORDER BY wins DESC) AS belt_rankings
FROM
	grapplers;

first_name|bjj_team           |belt_rank|wins|belt_rankings|
----------+-------------------+---------+----+-------------+
abe       |atos jiu-jitsu     |blue     |  10|            1|
fred      |checkmat           |blue     |   5|            2|
john      |gracie barra       |blue     |   4|            3|
chris     |gracie barra       |blue     |   1|            4|
duane     |carlson gracie team|blue     |   1|            4|
samuel    |carlson gracie team|brown    |   9|            1|
ronald    |checkmat           |brown    |   5|            2|
henry     |atos jiu-jitsu     |brown    |   2|            3|
jaime     |gracie barra       |purple   |   8|            1|
william   |carlson gracie team|purple   |   7|            2|
james     |atos jiu-jitsu     |purple   |   5|            3|
aldo      |checkmat           |purple   |   2|            4|
michael   |checkmat           |white    |   6|            1|
rick      |carlson gracie team|white    |   4|            2|
david     |gracie barra       |white    |   3|            3|
zach      |atos jiu-jitsu     |white    |   0|            4|

-- What if we only wanted the #2 ranked grappler?

SELECT
	first_name,
	team AS BJJ_Team,
	belt_rank,
	wins,
	DENSE_RANK() OVER (PARTITION BY belt_rank ORDER BY wins DESC) AS belt_rankings
FROM
	grapplers
WHERE
	belt_rankings = 2;

-- This will cause an error becuase the belt_rankings column does not exist (yet)
-- when the WHERE clause is executed.

SQL Error [42703]: ERROR: column "belt_rankings" does not exist

-- Let's use a CTE

WITH cte_get_belt_rankings AS (
	SELECT
	first_name,
	team AS BJJ_Team,
	belt_rank,
	wins,
	DENSE_RANK() OVER (PARTITION BY belt_rank ORDER BY wins DESC) AS belt_rankings
	FROM
		grapplers
)
SELECT
	first_name,
	BJJ_Team,
	belt_rank,
	belt_rankings
FROM
	cte_get_belt_rankings
WHERE
	belt_rankings = 2;

first_name|bjj_team           |belt_rank|belt_rankings|
----------+-------------------+---------+-------------+
fred      |checkmat           |blue     |            2|
ronald    |checkmat           |brown    |            2|
william   |carlson gracie team|purple   |            2|
rick      |carlson gracie team|white    |            2|









         

