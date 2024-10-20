--Data Cleaning

--remove null values for start_station_name and start_station_id (968697 rows removed)
DELETE FROM `cyclistic_data.cyclistic_12months_data`
WHERE start_station_name IS NULL AND start_station_id IS NULL

--remove null values for start_station_name and start_station_id (533325 rows removed)
DELETE FROM `cyclistic_data.cyclistic_12months_data`
WHERE end_station_name IS NULL AND end_station_id IS NULL

--remove null values for end_lat and end_lng (0 rows removed as already removed above)
DELETE FROM `cyclistic_data.cyclistic_12months_data`
WHERE end_lat IS NULL AND end_lng IS NULL

--create a table without the duplicate values (removed 121 row with duplicate ride_id)
SELECT *
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY ride_id
    ) AS row_number
  FROM `cyclistic_data.cyclistic_12months_data`
)
WHERE row_number = 1

--remove trip with duration lesser than 5 minutes, more than a day, or has negative duration
DELETE FROM `cyclistic_data.cyclistic_12months_data`
WHERE ride_id IN (
  SELECT
    ride_id
  FROM (
      SELECT
        ride_id,
        TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS trip_duration_minutes
      FROM `cyclistic_data.cyclistic_12months_data`
  ) AS duration_data
  WHERE
    (CASE
      WHEN trip_duration_minutes < 0 THEN 'Negative Duration'
      WHEN trip_duration_minutes < 5 THEN 'Less than 5 minutes'
      WHEN trip_duration_minutes >= 1440 THEN 'More than 1 day'
      ELSE 'Other'
    END) != 'Other'
)

--create a new column for ride_length
ALTER TABLE `cyclistic_data.cyclistic_12months_data`
ADD COLUMN ride_length STRING

--convert the ride_length from seconds to HH:MM:SS
UPDATE `cyclistic_data.cyclistic_12months_data`
SET ride_length = 
  CONCAT(
    LPAD(CAST(FLOOR(TIMESTAMP_DIFF(ended_at, started_at, SECOND) / 3600) AS STRING), 2, '0'), ':',
    LPAD(CAST(FLOOR((TIMESTAMP_DIFF(ended_at, started_at, SECOND) - (FLOOR(TIMESTAMP_DIFF(ended_at, started_at, SECOND) / 3600) * 3600)) / 60) AS STRING), 2, '0'), ':',
    LPAD(CAST((TIMESTAMP_DIFF(ended_at, started_at, SECOND) - (FLOOR(TIMESTAMP_DIFF(ended_at, started_at, SECOND) / 3600) * 3600) - (FLOOR((TIMESTAMP_DIFF(ended_at, started_at, SECOND) - (FLOOR(TIMESTAMP_DIFF(ended_at, started_at, SECOND) / 3600) * 3600)) / 60) * 60)) AS STRING), 2, '0')
  )
WHERE TRUE

--create a new column for ride_length_minutes
ALTER TABLE `cyclistic_data.cyclistic_12months_data`
ADD COLUMN ride_length_minutes INT64

UPDATE `cyclistic_data.cyclistic_12months_data`
SET ride_length_minutes = TIMESTAMP_DIFF(ended_at, started_at, MINUTE)
WHERE TRUE

--create a new column for day_of_week
ALTER TABLE `cyclistic_data.cyclistic_12months_data`
ADD COLUMN day_of_week STRING;

UPDATE `cyclistic_data.cyclistic_12months_data`
SET day_of_week = FORMAT_TIMESTAMP('%A', started_at)
WHERE TRUE


--create 2 columns for start_lng and start_lat average
CREATE OR REPLACE TABLE `cyclistic_data.cyclistic_12months_data` AS
WITH start_avg_lnglat AS (
    SELECT 
        start_station_name,
        AVG(start_lng) AS start_average_longitude,
        AVG(start_lat) AS start_average_latitude
    FROM 
        `cyclistic_data.cyclistic_12months_data`
    GROUP BY 
        start_station_name
)

SELECT 
    t.*,
    a.start_average_longitude,
    a.start_average_latitude
FROM 
    `cyclistic_data.cyclistic_12months_data` AS t
LEFT JOIN 
    start_avg_lnglat AS a 
    ON t.start_station_name = a.start_station_name;
  

--create 2 columns for end_lng and end_lat average
CREATE OR REPLACE TABLE `cyclistic_data.cyclistic_12months_data` AS
WITH avg_lnglat AS (
    SELECT 
        end_station_name,
        AVG(end_lng) AS end_average_longitude,
        AVG(end_lat) AS end_average_latitude
    FROM 
        `cyclistic_data.cyclistic_12months_data`
    GROUP BY 
        end_station_name
)

SELECT 
    t.*,
    a.end_average_longitude,
    a.end_average_latitude
FROM 
    `cyclistic_data.cyclistic_12months_data` AS t
LEFT JOIN 
    avg_lnglat AS a 
    ON t.end_station_name = a.end_station_name;
