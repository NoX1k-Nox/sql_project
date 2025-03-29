-- car_overall.sql

WITH AvgPositions AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
MinPosition AS (
    SELECT MIN(average_position) AS min_avg_position
    FROM AvgPositions
)
SELECT 
    a.car_name,
    a.car_class,
    a.average_position,
    a.race_count,
    a.car_country
FROM AvgPositions a
JOIN MinPosition m ON a.average_position = m.min_avg_position
ORDER BY a.car_name ASC
LIMIT 1;
