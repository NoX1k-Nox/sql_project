-- cars_better_than_class_average.sql
-- Находит автомобили, которые выступают лучше, чем средний показатель по их классу, 
-- в классах с двумя и более автомобилями.

WITH ClassStats AS (
    SELECT 
        c.class AS car_class,
        cl.country AS car_country,
        COUNT(DISTINCT c.name) AS car_count,
        AVG(r.position) AS class_avg_position
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.class, cl.country
    HAVING COUNT(DISTINCT c.name) >= 2
),
CarStats AS (
    SELECT 
        r.car AS car_name,
        c.class AS car_class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY r.car, c.class
)
SELECT 
    cs.car_name,
    cs.car_class,
    cs.avg_position,
    cs.race_count,
    cl.country AS car_country
FROM CarStats cs
JOIN ClassStats cls ON cs.car_class = cls.car_class
JOIN Classes cl ON cs.car_class = cl.class
WHERE cs.avg_position < cls.class_avg_position
ORDER BY cs.car_class, cs.avg_position;