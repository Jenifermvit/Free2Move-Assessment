-- Total number of rental records

SELECT COUNT(*) AS total_rentals
FROM rentals;

-- Identify how many rentals were made by customers vs service agents

SELECT
    SERVICERENTAL,
    COUNT(*) AS rental_count
FROM rentals
GROUP BY SERVICERENTAL;

-- Identify peak rental days

SELECT
    DAYNAME(STARTED_TIME) AS day_of_week,
    COUNT(*) AS total_rentals
FROM rentals
GROUP BY day_of_week
ORDER BY total_rentals DESC;

-- Analyze seasonal demand patterns

SELECT
    MONTH(STARTED_TIME) AS month,
    COUNT(*) AS total_rentals
FROM rentals
GROUP BY month
ORDER BY month;

-- Analyze distribution of battery level at rental start

SELECT
    CHARGELEVELSTART,
    COUNT(*) AS rentals
FROM rentals
GROUP BY CHARGELEVELSTART
ORDER BY CHARGELEVELSTART;

-- Analyze customer rental preference by battery level

SELECT
CASE
    WHEN CHARGELEVELSTART <= 20 THEN '0-20%'
    WHEN CHARGELEVELSTART <= 40 THEN '20-40%'
    WHEN CHARGELEVELSTART <= 60 THEN '40-60%'
    WHEN CHARGELEVELSTART <= 80 THEN '60-80%'
    ELSE '80-100%'
END AS battery_range,
COUNT(*) AS rentals
FROM rentals
WHERE SERVICERENTAL = 0
GROUP BY battery_range;

-- Identify how often vehicles were plugged into chargers

SELECT
CHARGED,
COUNT(*) AS total_events
FROM rentals
GROUP BY CHARGED;

-- Vehicles that started charging but did not reach full battery

SELECT
COUNT(*) AS interrupted_charging
FROM rentals
WHERE CHARGED = 1
AND CHARGELEVELEND < 100;

-- Vehicles successfully reaching full charge

SELECT
COUNT(*) AS completed_charging
FROM rentals
WHERE CHARGED = 1
AND CHARGELEVELEND = 100;

-- Identify vehicles frequently handled by service agents

SELECT
VEHICLE_ID,
COUNT(*) AS service_operations
FROM rentals
WHERE SERVICERENTAL = 1
GROUP BY VEHICLE_ID
ORDER BY service_operations DESC;

-- Calculate average trip duration

SELECT
AVG(TIMESTAMPDIFF(MINUTE, STARTED_TIME, FINISHED_TIME)) AS avg_rental_duration_minutes
FROM rentals;

-- Calculate battery usage per trip

SELECT
AVG(CHARGELEVELSTART - CHARGELEVELEND) AS avg_battery_usage
FROM rentals
WHERE SERVICERENTAL = 0;