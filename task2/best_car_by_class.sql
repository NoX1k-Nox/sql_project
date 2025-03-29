-- best_car_by_class.sql

WITH AvgPositions AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.name, c.class
),
MinPositions AS (
    SELECT 
        car_class,
        MIN(average_position) AS min_avg_position
    FROM AvgPositions
    GROUP BY car_class
)
SELECT 
    a.car_name,
    a.car_class,
    a.average_position,
    a.race_count
FROM AvgPositions a
JOIN MinPositions m ON a.car_class = m.car_class AND a.average_position = m.min_avg_position
ORDER BY a.average_position ASC, a.race_count DESC, a.car_name ASC;