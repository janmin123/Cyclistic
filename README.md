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
BigQuery is selected as the platform to manage and analyze the data. This is because Microsoft Excel spreadsheet has a row limit of 1,048,576 rows and a column limit of 16,384 columns. It is unable to handle large datasets such as Cyclistic dataset which has 5.6 millions rows.

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
<kbd>
<img src="https://github.com/user-attachments/assets/60ed60fc-7419-4677-9de2-04db3c895cfe" width="900" height="35">
</kbd>

* Duplicates
  * Observed 211 duplicate ride_id
<kbd>
<img src="https://github.com/user-attachments/assets/fc17d967-a235-48b0-a6bc-9b0b0b4be404" width="185" height="35">
</kbd>

* String Length
  * All ride_id have the same length of 16 char
<kbd>
<img src="https://github.com/user-attachments/assets/67edf445-46ac-43f5-a920-0a9231bafb4b" width="90" height="35">
</kbd>

* Trip Duration (in minutes)
  * Observed 469306 rows with trip duration less than 5 minutes
  * Observed 11859 rows with trip duration more than a day
  * Observed 344 rows with negative trip duration
<kbd>
<img src="https://github.com/user-attachments/assets/1ea79d12-68df-41b4-9afd-827c39c6264c" width="220" height="80">
</kbd>

* Membership type
  * 2 types: member and casual
  * Trip counts for each type sums up to total number of row
<kbd>
<img src="https://github.com/user-attachments/assets/3cf10c29-19ad-4a4e-89f9-e373c3cdc819" width="205" height="55">
</kbd>

* Ride type
  * 2 types: electric and classic
  * Trip counts for each type sums up to total number of rows
<kbd>
<img src="https://github.com/user-attachments/assets/1d0a231f-ccb6-4e25-8d7b-e6a96fe6748d" width="205" height="55">
</kbd>


### Data Cleaning
* Removed  1502022 rows of null values
* Removed 121 rows of duplicate values 
* Removed 816586 rows of trips with duration less than 5 minutes, more than a day or has negative duration
* Total removed: 2318729 rows
* Remaining: 3380910 rows
* Added 2 columns 
  * ride_length: calculate the trip duration in HH:MM:SS format
  * day_of_week: determine which day of the week the trip started

## Analyze
Tableau was chosen for visualizing the data as it enables quick and impactful insights into the riders' bike usages patterns and trends.

<kbd>
<img src="https://github.com/user-attachments/assets/06cdb402-7d7b-49d1-855a-1b274fcff46f" width="900" height="420">
</kbd>

* Bikes type breakdown by membership
  * The more popular bike type amongst all riders is the classic bike as compared to electric bike.
  * Members make up of majority users for both classic and electric bike.
  * Members constitute the majority of total rides at 61.5% while casual riders constitute 38.5%.

<kbd>
<img src="https://github.com/user-attachments/assets/3e05bb74-d8fa-4109-841b-3b2e44fa340e" width="900" height="700">
</kbd>

* Trips count in a day
  * Between 12am – 4am and 10am – 2pm, members and casual riders remain relatively stagnant
  * Member’s trend observe 2 peaks between 5am – 9am and 3pm – 6pm while casual riders trip count gradually increased throughout the day starting from 5am till 5pm before decreasing after.
  * Trip count generally decrease from 6pm onwards across all riders

* Trips count in a week
  * Across a week, the trip count remain relatively consistent on weekdays from Monday to Thursday.
  * Trip count for member decreases from Friday to Sunday while casual riders increases and peaks on Saturday.

* Trips count in a month
  *  Across a month, the trip count remain relatively consistent amongst all riders.
  *  The trip count decreases slightly at the end of the month for all riders

* Trips count in a year
  * Across a year, both members and casual riders observe the same trend where trip count sees a decrease from October till January and increases thereafter before plateauing in June.
 

<kbd>
<img src="https://github.com/user-attachments/assets/11294b1f-1809-4add-8016-0db4bf2ab51d" width="900" height="700">
</kbd>

* Average trip duration in a day
  * The trip duration for casual riders tend to dip at around 3am - 5am  on bounces back only from 8am.
  * The trip duration for members also remain consistent throughout without any significant changes.

* Average trip duration in a week
  * The trip duration for casual riders gradually increases from Friday till Sunday
  * The trip duration for members also remain consistent on weekdays before picking up slightly from Fridays till Sunday.

* Average trip duration in a month
  * The trip duration remains fairly consistent across all riders

* Average trip duration in a year
  * The trip duration for casual riders sees a dip from October onwards before picking up gradually in January.
  * The trip duration for members also remain consistent throughout without any significant changes.

From the data above, we can observe that
1) Members are likely using the bikes for commuting to and from their workplace, residential area and possibly schools. This can be seen from the **spike in trip count during peak hours in the morning and evening**, **coupled with the decrease in trip count on the weekends when there is no work or school**.
2) Casual riders are likely using the bikes for leisure purposes such as touring or sightseeing . This can be observed from the 
**gradual increase in trip count throughout the day until 5pm where the usage decreases after 5pm which is the closing hours of most places of attraction**,
**significant increase (~2x) in trip counts on the weekends** and
**gradual increase in average trip duration on the weekends**.
3) Both members and casual riders observe a dip in trip counts during colder months from October till January. However, the cycle duration for members remain consistent while casual riders are observed to cycle for a shorter duration during this period. This further supports the hypothesis that members are using the bikes for commuting while casual riders are using the bikes for more ad hoc and leisure purposes
4) Casual riders has a lower frequency than members in terms of the trips they take but twice the trip duration
   
To further confirm the findings above, we look at the geographical data of the trips taken by the riders. From below, we are able to see that casual riders hotspots are located along the coastal regions while members hotspots are scattered around the city center.

<kbd>
<img src="https://github.com/user-attachments/assets/a2dd0d38-6dac-4cdd-a5a0-412483ec3fcf" width="900" height="400">
</kbd>

<kbd>
<img src="https://github.com/user-attachments/assets/87938eba-789d-4b52-b388-415e5c08f817" width="900" height="400">
</kbd>

To summarize the findings in terms of differences between members and casual riders: 
* **Purpose of Bike Usage**
  * Casual riders are likely using the bikes for sightseeing and touring as they coincide with most of Chicago’s places of attraction are located near the coastal areas, for instance the Navy Pier, 360 Chicago, Museum of Contemporary Art and Millennium Park just to name a few.
  * Member riders are likely using the bikes for commuting as most trip locations are spread out across the city center where the offices, schools and residential areas are located.
 
* **Time of Bike Usage**
  * Casual riders are likely to ride bikes during weekends and the usage gradually increase throughout the day from 5am to 5pm.They are likely to use the bikes during Spring/Summer/Autumn as during winter (October to January) we see the trip counts and average trip duration dipping concurrently.
  * Members are likely to use the bikes during weekdays and especially during peak hours (5am - 9am and 3pm - 6pm) for commuting. Similar to casual riders, members use the bikes frequently in Spring/Summer/Autumn and lesser during winter. However, their trip duration did not dip during Winter, suggesting that they may still be using the bikes for commuting purpose.
    
* **Frequency and duration of Bike Usage**
  * Casual riders has a lower frequency of trip undertaken than members, but their average trip duration is approximately twice longer


## Act
With the differences in bike usage patterns identified, I propose the below marketing strategies targeted at casual riders to convert them to members.

### Targeted Promotions
* **Seasonal Membership Offers**: Introduce special promotions during Spring/Summer to encourage casual riders to sign up for memberships, highlighting the benefits of year-round access.
* **Weekend Deals**: Offer discounts on weekend rides for casual users who sign up for membership, emphasizing the value of unlimited rides.

### Enhanced Experience Offerings
* **Exclusive Events**: Organize member-only events, such as guided tours of attractions, to provide casual riders with unique experiences that incentivize membership.
* **Loyalty Programs**: Develop a loyalty program that rewards members for frequent rides, potentially converting casual riders who enjoy longer trips

### Flexible Membership Options
*  **Trial Memberships**: Offer a discounted trial membership for casual riders, allowing them to experience the benefits of membership firsthand without a long-term commitment.
*  **Flexible Payment Plans**: Introduce flexible membership options, such as monthly payments, to make it easier for casual riders to transition.





