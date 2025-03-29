-- best_cars_in_best_class.sql
-- Находит автомобили в классе с наименьшей средней позицией.

WITH ClassAvgPosition AS (
    SELECT 
        c.class AS car_class,
        cl.country AS car_country,
        COUNT(r.race) AS total_races,
        AVG(r.position) AS avg_position
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.class, cl.country
),
MinAvgPosition AS (
    SELECT MIN(avg_position) AS min_avg FROM ClassAvgPosition
)
SELECT 
    c.name AS car_name,
    c.class AS car_class,
    cap.avg_position,
    COUNT(r.race) AS race_count,
    cap.car_country,
    cap.total_races
FROM Results r
JOIN Cars c ON r.car = c.name
JOIN ClassAvgPosition cap ON c.class = cap.car_class
JOIN MinAvgPosition map ON cap.avg_position = map.min_avg
GROUP BY c.name, c.class, cap.avg_position, cap.car_country, cap.total_races
ORDER BY avg_position, car_name;