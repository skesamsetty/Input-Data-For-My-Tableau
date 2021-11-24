-- Data from 2017 to 2021 January
CREATE TABLE tripdata
(
	ride_id				VARCHAR	PRIMARY KEY,
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

-- Data from 2021 February till date
CREATE TABLE tripdata2
(
	ride_id						VARCHAR	PRIMARY KEY,
	tripduration				INTEGER,
	starttime					TIMESTAMP,
	stoptime					TIMESTAMP,
	start_station_id			VARCHAR,
	start_station_name			VARCHAR,
	start_station_latitude		NUMERIC,
	start_station_longitude		NUMERIC,
	end_station_id				VARCHAR,
	end_station_name			VARCHAR,
	end_station_latitude		NUMERIC,
	end_station_longitude		NUMERIC,
	bikeid						VARCHAR,
	usertype					VARCHAR,
	birth_year					VARCHAR,
	gender						INTEGER,
	fiscal_year					INTEGER,
	fiscal_month				INTEGER
);

SELECT DISTINCT fiscal_year, fiscal_month
	FROM public.tripdata
	ORDER BY fiscal_year ASC, fiscal_month ASC;
