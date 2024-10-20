--Data Exploration

--check for missing values
SELECT 
  COUNT(*) - COUNT(ride_id) AS ride_id_null,
  COUNT(*) - COUNT(rideable_type) rideable_type_null,
  COUNT(*) - COUNT(started_at) started_at_null,
  COUNT(*) - COUNT(ended_at) ended_at_null,
  COUNT(*) - COUNT(start_station_name) start_station_name_null,
  COUNT(*) - COUNT(start_station_id) start_station_id_null,
  COUNT(*) - COUNT(end_station_name) end_station_name_null,
  COUNT(*) - COUNT(end_station_id) end_station_id_null,
  COUNT(*) - COUNT(start_lat) start_lat_null,
  COUNT(*) - COUNT(start_lng) start_lng_null,
  COUNT(*) - COUNT(end_lat) end_lat_null,
  COUNT(*) - COUNT(end_lng) end_lng_null,
  COUNT(*) - COUNT(member_casual) member_casual_null
FROM `cyclistic_data.cyclistic_12months_data`

--check for null start_station_name  and null start_station_id
--check if the start_station_name and start_station_id has null on the same rows
SELECT
  ride_id,
  start_station_name,
  start_station_id
FROM `cyclistic_data.cyclistic_12months_data`
WHERE start_station_name IS NULL AND start_station_id IS NULL


--check for null end_station_name and null end_station_id
--check if the end_station_name and end_station_id has null on the same rows
SELECT
  ride_id,
  end_station_name,
  end_station_id
FROM `cyclistic_data.cyclistic_12months_data`
WHERE end_station_name IS NULL AND end_station_id IS NULL

--check for rows with null end/start_station_name and null end/start_station_id
SELECT
  ride_id,
  start_station_name,
  start_station_id,
  end_station_name,
  end_station_id
FROM `cyclistic_data.cyclistic_12months_data`
WHERE end_station_name IS NULL AND end_station_id IS NULL AND start_station_name IS NULL AND start_station_id IS NULL


--check for null start_lat and null start_lng
SELECT
  ride_id,
  start_lat,
  start_lng
FROM `cyclistic_data.cyclistic_12months_data`
WHERE start_lat IS NULL AND start_lng IS NULL

--check for null end_lat and null end_lng
SELECT
  ride_id,
  end_lat,
  end_lng
FROM `cyclistic_data.cyclistic_12months_data`
WHERE end_lat IS NULL AND end_lng IS NULL


--check for duplicates in ride_id
SELECT
  COUNT(DISTINCT ride_id) AS distinct_rideid_count,
  COUNT(*) AS total_rideid_count
FROM `cyclistic_data.cyclistic_12months_data`

--check for ride_id length
SELECT 
  LENGTH(ride_id) AS ride_id_length
FROM `cyclistic_data.cyclistic_12months_data`
GROUP BY ride_id_length

--check the types of rideable_types
SELECT 
  DISTINCT rideable_type, 
  COUNT(rideable_type) AS trips_count
FROM `cyclistic_data.cyclistic_12months_data`
GROUP BY rideable_type

--check each trip duration in terms of minutes
SELECT
  CASE
    WHEN trip_duration_minutes < 0 THEN 'Negative Duration'
    WHEN trip_duration_minutes < 5 THEN 'Less than 5 minutes'
    WHEN trip_duration_minutes >= 1440 THEN 'More than 1 day'
    ELSE 'Other'
  END AS duration_category,
  COUNT (*) AS trip_count
FROM (
  SELECT
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) / 60 +
    TIMESTAMP_DIFF(ended_at, started_at, MINUTE) +
    TIMESTAMP_DIFF(ended_at, started_at, HOUR) * 60 + 
    TIMESTAMP_DIFF(ended_at, started_at, DAY) * 24 * 60 AS trip_duration_minutes
    FROM `cyclistic_data.cyclistic_12months_data`
) AS duration_data
GROUP BY
  duration_category
ORDER BY trip_count DESC


--check for membership type
SELECT
  member_casual AS membership_type,
  COUNT(*) AS trip_count
FROM `cyclistic_data.cyclistic_12months_data`
GROUP BY member_casual
