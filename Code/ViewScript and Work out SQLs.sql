------------------------------------------------------------------------------------------
-- Table to store data from Febraury 2021 with added columns FISCAL YEAR & FISCAL MONTH 
------------------------------------------------------------------------------------------
CREATE TABLE tripdata
(
	ride_id				VARCHAR		PRIMARY KEY,
	rideable_type		VARCHAR,
	started_at			TIMESTAMP,
	ended_at			TIMESTAMP,
	start_station_name	VARCHAR,
	start_station_id	VARCHAR,
	end_station_name	VARCHAR,
	end_station_id		VARCHAR,
	start_lat			NUMERIC,
	start_lng			NUMERIC,
	end_lat				NUMERIC,
	end_lng				NUMERIC,
	member_casual		VARCHAR,
	fiscal_year			INTEGER,
	fiscal_month		INTEGER
);

SELECT DISTINCT fiscal_year, fiscal_month
	FROM public.tripdata AS trip_data_2021
	ORDER BY fiscal_year ASC, fiscal_month ASC;

--------------------------------------------------------------------------------------------------------
-- Table to store data from Year 2017 to January 2021 with added columns FISCAL YEAR & FISCAL MONTH 
--------------------------------------------------------------------------------------------------------

CREATE TABLE tripdata2
(
	ride_id					VARCHAR		PRIMARY KEY,
	tripduration			INTEGER,
	starttime				TIMESTAMP,
	stoptime				TIMESTAMP,
	start_station_id		VARCHAR,
	start_station_name		VARCHAR,
	start_station_latitude	NUMERIC,
	start_station_longitude	NUMERIC,
	end_station_id			VARCHAR,
	end_station_name		VARCHAR,
	end_station_latitude	NUMERIC,
	end_station_longitude	NUMERIC,
	bikeid					VARCHAR,
	usertype				VARCHAR,
	birth_year				VARCHAR,
	gender					INTEGER,
	fiscal_year				INTEGER,
	fiscal_month			INTEGER
);

SELECT DISTINCT fiscal_year, fiscal_month
	FROM public.tripdata2 AS trip_data_2017_2018_2019_2020
	ORDER BY fiscal_year ASC, fiscal_month ASC;
    
--------------------------------------------------------------------------------------------------------
-- Table update statements - Updates the additional FISCAL YEAR & FISCAL MONTH columnns 
--     based on the trip start date
--------------------------------------------------------------------------------------------------------
UPDATE tripdata
	SET fiscal_year = DATE_PART('year', started_at),
		fiscal_month = DATE_PART('month', started_at);
        
UPDATE tripdata2
	SET fiscal_year = DATE_PART('year', starttime),
		fiscal_month = DATE_PART('month', starttime);     

--------------------------------------------------------------------------------------------------------    
-- VIEW Script - View shows the complete data from Year 2017 till September 2021 in single format
--------------------------------------------------------------------------------------------------------
 
 DROP VIEW public.citibiketripdata;
 CREATE VIEW citibiketripdata AS
 SELECT tripdata.ride_id,
    tripdata.started_at,
    tripdata.ended_at,
    date_part('epoch'::text, tripdata.ended_at - tripdata.started_at) AS tripduration,
    round(date_part('epoch'::text, tripdata.ended_at - tripdata.started_at) / 60::double precision) AS tripdurationinmins,
    tripdata.start_station_name,
    tripdata.start_station_id,
    tripdata.start_lat,
    tripdata.start_lng,
    tripdata.end_station_name,
    tripdata.end_station_id,
    tripdata.end_lat,
    tripdata.end_lng,
        CASE
            WHEN tripdata.member_casual::text = 'member'::text THEN 'member'::text
            WHEN tripdata.member_casual::text = 'casual'::text THEN 'casual'::text
            ELSE 'casual'::text
        END AS member_casual,	
	tripdata.fiscal_year,
	tripdata.fiscal_month,
	tripdata.started_at::timestamp::date AS trip_date,
	'Unknown' AS gender	
   FROM tripdata 
UNION ALL
 SELECT tripdata2.ride_id,
    tripdata2.starttime AS started_at,
    tripdata2.stoptime AS ended_at,
	tripdata2.tripduration AS tripduration,
    (tripdata2.tripduration/60) AS tripdurationinmins,
    tripdata2.start_station_name,
    tripdata2.start_station_id,
    tripdata2.start_station_latitude AS start_lat,
    tripdata2.start_station_longitude AS start_lng,
    tripdata2.end_station_name,
    tripdata2.end_station_id,
    tripdata2.end_station_latitude AS end_lat,
    tripdata2.end_station_longitude AS end_lng,
        CASE
            WHEN tripdata2.usertype::text = 'Subscriber'::text THEN 'member'::text
            WHEN tripdata2.usertype::text = 'Customer'::text THEN 'casual'::text
            ELSE 'casual'::text
        END AS member_casual,
	tripdata2.fiscal_year,
	tripdata2.fiscal_month,
	tripdata2.starttime::timestamp::date AS trip_date,	
		CASE
			WHEN tripdata2.gender = 0 THEN 'Unknown'
			WHEN tripdata2.gender = 1 THEN 'Male'
			WHEN tripdata2.gender = 2 THEN 'Female'
			ELSE 'Unknown'
		END AS gender
   FROM tripdata2;
--------------------------------------------------------------------------------------------------------
-- Workout Queries
--------------------------------------------------------------------------------------------------------
   
SELECT * FROM public.tripdata2 LIMIT 10;
   
SELECT DISTINCT 
		member_casual, 
		COUNT(*) as trip_count
	FROM tripdata
	GROUP BY trip_date, member_casual
	ORDER BY trip_date ASC;

SELECT fiscal_year,
		fiscal_month,
		COUNT(ride_id) AS trip_count,
		SUM(tripduration) AS tripduration_sum,
		(SUM(tripduration)/60) AS tripduration_hour,
		((SUM(tripduration)/60)/24) AS tripduration_day,
		SUM(tripduration)/COUNT(ride_id) AS tripduration_avg
FROM public.citibiketripdata
GROUP BY fiscal_year, fiscal_month
ORDER BY fiscal_year ASC, fiscal_month ASC;
  
SELECT fiscal_year,
		fiscal_month,
		gender,
		COUNT(ride_id)
FROM public.citibiketripdata
GROUP BY fiscal_year,
		fiscal_month,
		gender
ORDER BY fiscal_year ASC,
		fiscal_month ASC,
		gender ASC;
		
SELECT fiscal_year,
		fiscal_month,
		member_casual,
		COUNT(ride_id)
FROM public.citibiketripdata
GROUP BY fiscal_year,
		fiscal_month,
		member_casual
ORDER BY fiscal_year ASC,
		fiscal_month ASC,
		member_casual ASC;
		
		
SELECT bikeid, fiscal_year, 
		AVG(tripduration) AS AVG_Trip_Duration_Seconds,
		(AVG(tripduration)/60) AS AVG_Trip_Duration_Minutes,
		((AVG(tripduration)/60)/60) AS AVG_Trip_Duration_Hours,
		(((AVG(tripduration)/60)/60)/24) AS AVG_Trip_Duration_Days
FROM public.tripdata2
GROUP BY bikeid, fiscal_year
ORDER BY AVG(tripduration) DESC
LIMIT 100;

SELECT * FROM public.tripdata2
WHERE bikeid = '37947'
ORDER BY starttime DESC;

	
	
SELECT fiscal_year, 
		fiscal_month, 
		member_casual,
		COUNT(ride_id) as tripCount,
		SUM(tripdurationinmins) as tripdurationMins,
		round((SUM(tripdurationinmins)/60)) as tripdurationHrs,
		round(((SUM(tripdurationinmins)/60)/24)) as tripdurationDays,
		SUM(tripdurationinmins)/COUNT(ride_id) AS calc,
		AVG(tripdurationinmins) AS avgtripdurationMins
	FROM citibiketripdata
	GROUP BY fiscal_year, fiscal_month, member_casual
	ORDER BY fiscal_year ASC, fiscal_month ASC;
	
SELECT fiscal_year, 
		fiscal_month, 
		member_casual,
		COUNT(ride_id) as tripCount,
		SUM(tripdurationinmins) as tripdurationMins,
		round(AVG(tripdurationinmins)) AS avgtripdurationMins
	FROM citibiketripdata
	GROUP BY fiscal_year, fiscal_month, member_casual
	ORDER BY fiscal_year ASC, fiscal_month ASC;