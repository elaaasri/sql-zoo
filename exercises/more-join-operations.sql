-- 1 - List the films where the yr is 1962 and the budget is over 2000000 [Show id, title]:
SELECT id, title
FROM movie
WHERE yr=1962
AND budget > 2000000; 

-- 2 - Give year of 'Citizen Kane': 
SELECT yr 
FROM movie
WHERE title = 'Citizen Kane';

-- 3 - List all of the Star Trek movies, include the id, title and yr (all of these movies start with the words Star Trek in the title). Order results by year:
SELECT id, title, yr 
FROM movie 
WHERE title LIKE 'Star Trek%'
ORDER BY yr;

-- 4 - What id number does the actor 'Glenn Close' have:
SELECT id 
FROM actor
WHERE name = 'Glenn Close';

-- 5 - What is the id of the 1942 film 'Casablanca':
Select id 
FROM movie
WHERE yr = 1942 
AND title = 'Casablanca';

-- 6 - Obtain the cast list for 1942's 'Casablanca':
SELECT name 
FROM actor 
JOIN casting ON actor.id = casting.actorid 
JOIN movie ON casting.movieid = movie.id
WHERE title = 'Casablanca'
AND yr = 1942;

-- 7 - Obtain the cast list for the film 'Alien':
SELECT name 
FROM actor 
JOIN casting ON actor.id = casting.actorid 
JOIN movie ON casting.movieid = movie.id
WHERE title = 'Alien';

-- 8 - List the films in which 'Harrison Ford' has appeared: 
SELECT title FROM movie
JOIN casting ON movie.id = casting.movieid 
JOIN actor ON casting.actorid = actor.id
WHERE name = 'Harrison Ford';

-- 9 - List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]:
SELECT title 
FROM movie
JOIN casting ON movie.id = casting.movieid 
JOIN actor ON casting.actorid = actor.id
WHERE name = 'Harrison Ford'
AND ord != 1;

-- 10 - List the films together with the leading star for all 1962 films: 
SELECT title, name 
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE yr = 1962 
AND ord = 1;

-- 11 - Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies:
SELECT yr, COUNT(title) 
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- 12 - List the film title and the leading actor for all of the films 'Julie Andrews' played in:
SELECT movie.title, actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON actor.id = casting.actorid
WHERE movie.id IN (
            SELECT movieid
            FROM casting
            JOIN actor ON actor.id = casting.actorid
            WHERE actor.name = 'Julie Andrews'
            )
AND casting.ord = 1;

-- 13 - Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles:
SELECT name
FROM actor
JOIN casting ON actor.id = casting.actorid
WHERE casting.ord = 1
GROUP BY name
HAVING SUM(ord) >= 15
ORDER BY name;

-- 14 - List the films released in the year 1978 ordered by the number of actors in the cast, then by title: 
SELECT movie.title, COUNT(casting.actorid) AS num_actors
FROM movie
JOIN casting ON movie.id = casting.movieid
WHERE movie.yr = 1978
GROUP BY movie.title
ORDER BY num_actors DESC, movie.title ASC;

-- 15 - List all the people who have worked with 'Art Garfunkel':
SELECT DISTINCT actor.name
FROM actor 
JOIN casting ON actor.id = casting.actorid
WHERE casting.movieid in (
                SELECT casting.movieid
                FROM actor 
                JOIN casting ON actor.id = casting.actorid
                WHERE actor.name = 'Art Garfunkel'
                )
AND actor.name != 'Art Garfunkel';

