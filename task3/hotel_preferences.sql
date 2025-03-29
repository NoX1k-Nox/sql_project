-- customer_hotel_preferences.sql
-- Определяет предпочтительный тип отеля для каждого клиента

WITH HotelCategories AS (
    SELECT 
        h.ID_hotel, 
        h.name, 
        CASE 
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_type
    FROM Room r
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
CustomerPreferences AS (
    SELECT 
        b.ID_customer,
        c.name,
        GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ',') AS visited_hotels,
        MAX(CASE WHEN hc.hotel_type = 'Дорогой' THEN 3
                 WHEN hc.hotel_type = 'Средний' THEN 2
                 ELSE 1 END) AS hotel_type_priority
    FROM Booking b
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    JOIN HotelCategories hc ON h.ID_hotel = hc.ID_hotel
    JOIN Customer c ON b.ID_customer = c.ID_customer
    GROUP BY b.ID_customer, c.name
)
SELECT 
    ID_customer,
    name,
    CASE 
        WHEN hotel_type_priority = 3 THEN 'Дорогой'
        WHEN hotel_type_priority = 2 THEN 'Средний'
        ELSE 'Дешевый'
    END AS preferred_hotel_type,
    visited_hotels
FROM CustomerPreferences
ORDER BY hotel_type_priority, ID_customer;