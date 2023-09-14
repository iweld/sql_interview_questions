--create school database

DROP TABLE IF EXISTS teachers
CREATE TABLE teachers (
	id INTEGER PRIMARY KEY,
    name TEXT,
    subject TEXT,
    department TEXT
);
    
INSERT INTO teachers (name, subject, department) 
Values 
	("Miranda", "Ag Chemistry", "Science"),
	("Miranda", "Sustainable Ag", "Science"),
	("Munn", "Ag Biology", "Science"),
	("Munn", "Plant and Animal", "Science"),
	("Niederfrank", "Ag Science", "Science"),
	("Niederfrank", "Ag Biology", "Science"),
	("Gonzalez", "Ag Biology", "Science"),
	("Gonzalez", "Plant and Animal", "Science"),
	("Stuhr", "Basic Fab", "CTE"),
	("Stuhr", "ROP Welding", "CTE"),
	("Stuhr", "Welding 1", "CTE"),
	("Carpenter", "Construction", "CTE"),
	("Carpenter", "ROP Construction", "CTE"),
	("Carpenter", "Basic Fab", "CTE"),
	("Barcellos", "ROP Floral", "CTE"),
	("Barcellos", "Floral", "CTE"),
	("Barcellos", "Basic Fab", "CTE");

DROP TABLE IF EXISTS grade_levels;
CREATE TABLE grade_levels (
	id INTEGER PRIMARY KEY,
    class_name TEXT,
    grade INTEGER
);
    
INSERT INTO grade_levels (class_name, grade) 
VALUES 
	("Ag Chemistry", 10),
 	("Ag Chemistry", 11),
 	("Sustainable Ag", 12),
 	("Ag Biology", 9),
 	("Plant and Animal", 10),
 	("Plant and Animal", 11),
 	("Ag Science", 9),
 	("Basic Fab", 9),
 	("Welding 1", 10),
 	("ROP Welding", 11),
 	("ROP Welding", 12),
 	("ROP Construction", 11),
 	("ROP Construction", 12),
 	("Construction", 10),
 	("ROP Floral", 11),
 	("ROP Floral", 12),
 	("Floral", 10);

--what subjects does each teacher teach and what grade levels can take those classes?
SELECT t.name, t.subject, g.grade
FROM teachers t
JOIN grade_levels g
ON t.subject = g.class_name
ORDER BY t.name asc;

--what teachers could a 9th grader possibly get?
SELECT t.name, g.grade
FROM teachers t
JOIN grade_levels g
ON t.subject = g.class_name
WHERE grade = 9
GROUP BY t.name;

--what grade levels does each teacher teach?
SELECT t.name, g.grade
FROM teachers t
JOIN grade_levels g
ON t.subject = g.class_name
ORDER BY t.name, g.grade asc;
        
