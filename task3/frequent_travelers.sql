-- frequent_travelers.sql
-- Находит клиентов, которые бронировали номера более чем в двух разных отелях

WITH CustomerBookings AS (
    SELECT 
        b.ID_customer,
        c.name AS customer_name,
        c.email,
        c.phone,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS different_hotels,
        GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotel_list,
        AVG(DATEDIFF(b.check_out_date, b.check_in_date)) AS avg_stay_length
    FROM Booking b
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    JOIN Customer c ON b.ID_customer = c.ID_customer
    GROUP BY b.ID_customer, c.name, c.email, c.phone
)
SELECT 
    customer_name,
    email,
    phone,
    total_bookings,
    hotel_list,
    ROUND(avg_stay_length, 4) AS avg_stay_length
FROM CustomerBookings
WHERE different_hotels > 1 AND total_bookings > 2
ORDER BY total_bookings DESC;