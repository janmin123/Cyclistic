--combine 12 months of data tables from 2023 Sep to 2024 Aug into a single table

CREATE TABLE IF NOT EXISTS `cyclistic_data.cyclistic_12months_data` AS (
  SELECT * FROM `cyclistic_data.cyclistic_2023_Sep`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2023_Oct`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2023_Nov`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2023_Dec`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2024_Jan`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2024_Feb`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2024_Mar`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2024_Apr`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2024_May`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2024_Jun`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2024_Jul`
  UNION ALL
  SELECT * FROM `cyclistic_data.cyclistic_2024_Aug`
  )

--counting the total rows in the combined data table which is 5699639
SELECT COUNT(*)
FROM `cyclistic_data.cyclistic_12months_data`
