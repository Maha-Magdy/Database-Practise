-- 1962 movies
SELECT id,
    title
FROM movie
WHERE yr = 1962;

-- When was Citizen Kane released?
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- Star Trek movies
SELECT id,
    title,
    yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- id for actor Glenn Close
SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- id for Casablanca
SELECT id
FROM movie
WHERE title = 'Casablanca';

-- Cast list for Casablanca
SELECT name
FROM actor
    JOIN casting ON id = actorid
WHERE movieid = 11768;

-- Alien cast list
SELECT name
FROM actor
    JOIN casting ON id = actorid
WHERE movieid = (
        SELECT id
        FROM movie
        WHERE title = 'Alien'
    );

-- Harrison Ford movies
SELECT title
FROM movie
    JOIN casting ON id = movieid
WHERE actorid = (
        SELECT id
        FROM actor
        WHERE name = 'Harrison Ford'
    );

-- Harrison Ford as a supporting actor
SELECT title
FROM movie
    JOIN casting ON id = movieid
    AND ord != 1
WHERE actorid = (
        SELECT id
        FROM actor
        WHERE name = 'Harrison Ford'
    );

-- Lead actors in 1962 movies
SELECT title,
    (
        SELECT name
        FROM actor
        WHERE casting.actorid = actor.id
    ) AS name
FROM movie
    JOIN casting ON id = movieid
    AND ord = 1
WHERE yr = 1962;

-- Busy years for Rock Hudson
SELECT yr,
    COUNT(title)
FROM movie
    JOIN casting ON movie.id = movieid
    JOIN actor ON actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- Lead actor in Julie Andrews movies
SELECT title,
    (
        SELECT name
        FROM actor
        WHERE actor.id = actorid
    ) AS name
FROM movie
    JOIN casting ON (
        movie.id = movieid
        AND ord = 1
    )
WHERE id IN (
        SELECT movieid
        FROM casting
        WHERE actorid = 179
    );

-- Actors with 15 leading roles
SELECT name
FROM actor
    JOIN casting ON id = actorid
    AND ord = 1
GROUP BY name
HAVING count(name) >= 15;

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title,
    COUNT(actorid) AS casting
FROM movie
    JOIN casting ON id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC,
    title;

-- List all the people who have worked with 'Art Garfunkel'.
SELECT name
FROM actor
    JOIN casting ON id = actorid
    AND movieid IN (
        SELECT movieid
        FROM casting
        WHERE actorid = (
                SELECT id
                FROM actor
                WHERE name = 'Art Garfunkel'
            )
    )
    AND name != 'Art Garfunkel';