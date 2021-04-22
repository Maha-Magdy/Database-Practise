-- 1. How many stops are in the database.
SELECT COUNT(*) AS stops_number
FROM stops;

-- 2. Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart';

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name
FROM stops
     JOIN route ON id = stop
WHERE company = 'LRT' AND num = '4';

-- 4. Run the query and notice the two services that link these stops have a count of 2.
-- Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*) AS visits
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING visits = 2;

-- 5. Without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop = 53
      AND b.stop = (select id FROM stops WHERE name = 'London Road');

-- 6. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
             JOIN stops stopa ON (a.stop=stopa.id)
             JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road';

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith').
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON a.company = b.company AND a.num = b.num
             JOIN stops stopa ON (a.stop=stopa.id)
             JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Haymarket' AND stopb.name='Leith';

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'.
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON a.company = b.company AND a.num = b.num
             JOIN stops stops_a ON stops_a.id = a.stop
             JOIN stops stops_b ON stops_b.id = b.stop
WHERE stops_a.name = 'Craiglockhart' AND stops_b.name = 'Tollcross';

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus,
-- including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT stopb.name, a.company, a.num
FROM route a JOIN route b ON (a.num=b.num AND a.company=b.company)
             JOIN stops stopa ON (a.stop=stopa.id)
             JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name = 'Craiglockhart';

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.
SELECT a.num, a.company, stop_b.name, d.num, d.company
FROM route a join route b ON a.num = b.num AND a.company = b.company
             join route c ON b.stop = c.stop
             join route d ON d.num = c.num AND d.company = c.company
             join stops stop_a ON stop_a.id = a.stop
             join stops stop_b ON stop_b.id = b.stop
             join stops stop_c ON stop_c.id = c.stop
             join stops stop_d ON stop_d.id = d.stop
WHERE stop_a.name = 'Craiglockhart'  AND stop_d.name = 'Lochend'
ORDER BY a.num, stop_b.name, d.num;

