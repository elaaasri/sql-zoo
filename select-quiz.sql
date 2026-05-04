-- Question 1 
SELECT name, population
  FROM world
 WHERE population BETWEEN 1000000 AND 1250000

-- Question 2
Table-E
Albania	3200000
Algeria	32900000

-- Question 3
SELECT name FROM world
 WHERE name LIKE '%a' OR name LIKE '%l'

-- Question 4
name	length(name)
Italy	5
Malta	5
Spain	5

-- Question 5
Andorra	936

-- Question 6
SELECT name, area, population
  FROM world
 WHERE area > 50000 AND population < 10000000

-- Question 7
SELECT name, population/area
  FROM world
 WHERE name IN ('China', 'Nigeria', 'France', 'Australia')