-- cars_with_low_positions.sql
-- Находит автомобили со средней позицией выше 3.0 и предоставляет 
-- статистику по классам с такими автомобилями.


WITH CarStats AS (
    SELECT 
        r.car AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY r.car, c.class, cl.country
),
ClassStats AS (
    SELECT 
        cs.car_class,
        COUNT(*) AS low_position_car_count,
        SUM(cs.race_count) AS total_races_in_class
    FROM CarStats cs
    WHERE cs.average_position > 3.0
    GROUP BY cs.car_class
)
SELECT 
    cs.car_name,
    cs.car_class,
    cs.average_position,
    cs.race_count,
    cs.car_country,
    cl.total_races_in_class,
    cl.low_position_car_count
FROM CarStats cs
JOIN ClassStats cl ON cs.car_class = cl.car_class
WHERE cs.average_position > 3.0
ORDER BY cl.low_position_car_count DESC, cs.car_class, cs.average_position DESC, cs.car_name;

