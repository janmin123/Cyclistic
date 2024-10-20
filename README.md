# Cyclistic
## Project Background
### About the company Cyclistic
Cyclistic is a bike-share program, in Chicago, that features more than 5,800 bicycles and 600 docking stations. It sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use the bikes to commute to work each day. 

### Scenario
I am a junior data analyst working on the marketing analyst team at Cyclistic. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, my team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, my team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve my recommendations, so they must be backed up with compelling data insights and professional data visualizations.

## Ask
### Business Task
Design marketing strategies aimed at converting casual riders into annual members. 

### Stakeholders
* Lily Moreno: The director of marketing and your manager. Moreno is responsible for the development of campaigns and initiatives to promote the bike-share program. These may include email, social media, and other channels
* Cyclistic marketing analytics team: A team of data analysts who are responsible for collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy.
* Cyclistic executive team: The notoriously detail-oriented executive team will decide whether to approve the recommended marketing program. 

### Guiding Questions
1. How do annual members and casual riders use Cyclistic bikes differently? 
2. Why would casual riders buy Cyclistic annual memberships? 
3. How can Cyclistic use digital media to influence casual riders to become members? 

Moreno has assigned me the first question to answer: How do annual members and casual differ in their use of Cyclistic bikes?

## Prepare
### Data Source
* Cyclistic’s [historical trip data](https://divvy-tripdata.s3.amazonaws.com/index.html) from Sep 2023 to Aug 2024 will be used to analyze and identify trends 
* The data has been made available by Motivate International Inc. under this [license](https://divvybikes.com/data-license-agreement)
* This is public data that can be used to explore how different customer types are using Cyclistic bikes. Data-privacy issues prohibits the usage of riders’ personally identifiable information. This means that I won’t be able to connect pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes. 

### Data Organization
There are 12 monthly csv files and each includes information on ride id, ride type, start time, end time, start station name, start station id, end station name, end station id, start gps location, end gps location and rider’s membership type. 

## Process
BigQuery is selected as the platform to manage and analyze the data. This is because Microsoft Excel spreadsheet has a row limit of 1,048,576 rows and a column limit of 16,384 columns and is unable to handle large datasets such as Cyclistic dataset which has 5.6 millions rows.

### Data Combination
* As the Free Plan on BigQuery limits 100MB per upload, the 12 CSV files (which is larger than 100MB each) are first uploaded in Google Cloud Storage before being uploaded as tables in the dataset `cyclistic_data`.
* The 12 CSV files are combined into the data table `cyclistic_12months_data` and contains 5699639 rows.

### Data Exploration
* Null Values
  * Observed 968697 rows of null values for start_station_name
  * Observed 968697 rows of null values for start_station_id
    * Checked that both start_station_name and start_station_id null values occur at the same row
  * Observed 1006133 rows of null values for end_station_name
  * Observed 1006133 rows of null values for end_station_id
    * Checked that both end_station_name and end_station_id  null values occur at the same row
    * Checked that 472808 rows contain null values for start and end_station_name and start and end_station_id
  * Observed 7526 rows of null values for end_lat
  * Observed 7526 rows of null values for end_lng
    * Checked that both end_lat and end_lng  null values occur at the same row
    
![image](https://github.com/user-attachments/assets/60ed60fc-7419-4677-9de2-04db3c895cfe)

* Duplicates
  * Observed 211 duplicate ride_id

![image](https://github.com/user-attachments/assets/fc17d967-a235-48b0-a6bc-9b0b0b4be404)

* String Length
  * All ride_id have the same length of 16 char

![image](https://github.com/user-attachments/assets/67edf445-46ac-43f5-a920-0a9231bafb4b)

* Trip Duration (in minutes)
  * Observed 469306 rows with trip duration less than 5 minutes
  * Observed 11859 rows with trip duration more than a day
  * Observed 344 rows with negative trip duration

![image](https://github.com/user-attachments/assets/1ea79d12-68df-41b4-9afd-827c39c6264c)

* Membership type
  * 2 types: member and casual
  * Trip counts for each type sums up to total number of row

![image](https://github.com/user-attachments/assets/3cf10c29-19ad-4a4e-89f9-e373c3cdc819)

* Ride type
  * 2 types: electric and classic
  * Trip counts for each type sums up to total number of rows

![image](https://github.com/user-attachments/assets/1d0a231f-ccb6-4e25-8d7b-e6a96fe6748d)


### Data Cleaning
* Removed  1502022 rows of null values
* Removed 121 rows of duplicate values 
* Removed 816586 rows of duration less than 5 minutes, more than a day or negative
* Total removed: 2318729 row
* Remaining: 3380910 rows
* Added 2 columns 
  * ride_length: calculate the trip duration in HH:MM:SS format
  * day_of_week: determine which day of the week the trip started
