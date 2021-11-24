# Preparation of Data and Analysis For My Tableau Visuals of New York City - Citi Bike

## Background

This Project is to analyze and generate a story using Tableau.

Citi Bike is the nation's largest bike share program, with 20,000 bikes and over 1,300 stations across Manhattan, Brooklyn, Queens, the Bronx and Jersey City. It was designed for quick trips with convenience in mind, and it’s a fun and affordable way to get around town. Huge amounts of data is available as part of daily trips. On an average, each year has atleast 14.5Million records.

To perform analysis on Bike ride data of past 5 years, Tableau is taking so much time to load the amount of data from CSV files.

Hence I chose to load all data from 2017 January till 2021 September into `PostgreSQL` database.

Also the format of the data has changed since 2021 February. So I have created a SQL View to union the common fields from earlier and current csv formats. Then used this SQL View in Jupyter notebook to fetch appropriate reporting summary data.

Using `SQLAlchemy with Jupyter Notebook` helped generate required CSV files in the Resources folder.

Tableau is pointing to this Resources folder to fetch all required data for the Worksheets, Dashboards and Story. It can be accessed using the URL [NYC Citi Bike Analysis](https://public.tableau.com/views/CitiBikeAnalytics_SushmaKesamsetty/CitiBikeAnalysis?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link)

## Analysis

After performing the analysis on the data, we can see that the popularity for CitiBike has been increasing year on year with a growth of overall 40% already in September 2021.

We can also notice that the growth is impacted and it can be clearly related to Covid19.

There are so many entires with NULL End station name and ID. We would need additional data like Ride service history to understand if these bikes are taken out for maintenance.

As of new data format in 2021, Citi Bike has stopped tracking the Bike ID, Birth Year, Gender and hence did not generate any visualization based on these attributes.

### Summary CSV files:
* `yearMonthSummary.csv`: Generated with Year/Month total trip counts, trip duration in minutes and average trips per day.
* `yearlySummaryBySubscribers.csv`: Generated to hold trip counts at Member/Casual customer level.
* `DaywiseUsage.csv`: Generated to hold Daywise, trip counts, total trip duration in minutes and Member/Casual usage.
* `HourlyUsage.csv`: Generated to hold hour wise trip counts and Member/Casual usage (Considering data for the year 2020 and 2021).
* `202109-citibike-tripdata.csv`: csv file from the [Citi Bike Data](https://www.citibikenyc.com/system-data) webpage.
