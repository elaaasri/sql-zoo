-- 1 - Modify the query to show data from Spain:
SELECT name, DAY(whn), confirmed, deaths, recovered
FROM covid
WHERE name = 'Spain'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 2 - Modify the query to show confirmed for the day before.
SELECT name, DAY(whn), confirmed, LAG(confirmed) OVER (PARTITION BY name ORDER BY whn)
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 3 - Show the number of new cases for each day, for Italy, for March.
SELECT name, DAY(whn), confirmed - LAG(confirmed,1 ) OVER (PARTITION BY name ORDER BY  whn) AS new
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 4 - Show the number of new cases in Italy for each week in 2020 - show Monday only.
SELECT name, DATE_FORMAT(whn,'%Y-%m-%d'), confirmed - LAG(confirmed) OVER (PARTITION BY name ORDER BY whn)
FROM covid
WHERE name = 'Italy'
AND WEEKDAY(whn) = 0 AND YEAR(whn) = 2020
ORDER BY whn;

-- 5 - Show the number of new cases in Italy for each week - show Monday only.
-- cw ==> current week
-- pw ==> previous week
SELECT cw.name, DATE_FORMAT(cw.whn,'%Y-%m-%d') AS week_date, cw.confirmed - pw.confirmed AS new_cases
FROM covid cw 
LEFT JOIN covid pw ON DATE_ADD(pw.whn, INTERVAL 1 WEEK) = cw.whn AND cw.name = pw.name
WHERE cw.name = 'Italy'
AND WEEKDAY(cw.whn) = 0 
ORDER BY pw.whn;

-- 6 - Add a column to show the ranking for the number of deaths due to COVID.
SELECT 
    name,
    confirmed,
    RANK() OVER (ORDER BY confirmed DESC) AS rc,
    deaths,
    RANK() OVER (ORDER BY deaths DESC) AS rd
FROM covid
WHERE whn = '2020-04-20'
ORDER BY confirmed DESC;

-- 7 - Show the infection rate ranking for each country. Only include countries with a population of at least 10 million.
SELECT 
    world.name,
    ROUND(100000*confirmed/population, 2) AS rate,
    RANK() OVER (ORDER BY rate DESC) AS ranking
FROM covid 
JOIN world ON covid.name = world.name
WHERE whn = '2020-04-20' AND population > 10000000;

-- 8 - For each country that has had at least 20000 new cases in a single day, show name of country, the date of the peak number of new cases and the peak value.
WITH daily AS (
    SELECT  name,
            whn,
            confirmed - LAG(confirmed) OVER (PARTITION BY name ORDER BY whn) AS new_cases
    FROM covid
),
ranked AS (
    SELECT  name,
            whn,
            new_cases,
            RANK() OVER (PARTITION BY name ORDER BY new_cases DESC) AS rank
    FROM daily
)
SELECT  name,
        DATE_FORMAT(whn,'%Y-%m-%d') AS date,
        new_cases
FROM ranked
WHERE rank = 1
AND new_cases >= 20000;


