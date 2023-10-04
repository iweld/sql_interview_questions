
CREATE SCHEMA IF NOT EXISTS sales_project;

DROP TABLE IF EXISTS sales_project.sales_data;
CREATE TABLE sales_project.sales_data (
	ORDERNUMBER int,
	QUANTITYORDERED int,
	PRICEEACH numeric,
	ORDERLINENUMBER int,
	SALES numeric,
	ORDERDATE TEXT,
	STATUS text,
	QTR_ID int,
	MONTH_ID int,
	YEAR_ID int,
	PRODUCTLINE text,
	MSRP int,
	PRODUCTCODE text,
	CUSTOMERNAME text,
	PHONE text,
	ADDRESSLINE1 text,
	ADDRESSLINE2 text,
	CITY text,
	STATE text,
	POSTALCODE text,
	COUNTRY text,
	TERRITORY text,
	CONTACTLASTNAME text,
	CONTACTFIRSTNAME text,
	DEALSIZE text
);

COPY sales_project.sales_data (
	ORDERNUMBER,
	QUANTITYORDERED,
	PRICEEACH,
	ORDERLINENUMBER,
	SALES,
	ORDERDATE,
	STATUS,
	QTR_ID,
	MONTH_ID,
	YEAR_ID,
	PRODUCTLINE,
	MSRP,
	PRODUCTCODE,
	CUSTOMERNAME,
	PHONE,
	ADDRESSLINE1,
	ADDRESSLINE2,
	CITY,
	STATE,
	POSTALCODE,
	COUNTRY,
	TERRITORY,
	CONTACTLASTNAME,
	CONTACTFIRSTNAME,
	DEALSIZE
)
FROM '/var/lib/postgresql/source_data/sql_sales_project/sales_data.csv'
WITH DELIMITER ',' HEADER CSV;

-- Let's fix the date to the proper date format
UPDATE sales_project.sales_data
SET orderdate = split_part(orderdate, ' ', 1);


UPDATE sales_project.sales_data
SET orderdate = split_part(orderdate, '/', 3) || '-' || split_part(orderdate, '/', 1) || '-' || split_part(orderdate, '/', 2);

-- Change the column to the proper data type

ALTER TABLE sales_project.sales_data
ALTER COLUMN orderdate TYPE date
USING orderdate::date;

SELECT *
FROM 
	sales_project.sales_data
LIMIT 5;

/*

ordernumber|quantityordered|priceeach|orderlinenumber|sales  |orderdate |status |qtr_id|month_id|year_id|productline|msrp  |productcode|customername      |phone     |addressline1           |addressline2|city    |state |postalcode|country|territory|contactlastname|contactfirstname|dealsize|
-----------+---------------+---------+---------------+-------+----------+-------+------+--------+-------+-----------+------+-----------+------------------+----------+-----------------------+------------+--------+------+----------+-------+---------+---------------+----------------+--------+
      10146|             47|    67.14|              2|3155.58|2003-09-03|Shipped|     3|       9|   2003|Motorcycles|    62|S18_3782   |Gift Ideas Corp.  |2035554407|2440 Pompton St.       |[NULL]      |Glendale|CT    |97561     |USA    |NA       |Lewis          |Dan             |Medium  |
      10237|             27|      100|              5|3113.64|2004-04-05|Shipped|     2|       4|   2004|Motorcycles|   102|S32_4485   |Vitachrome Inc.   |2125551500|2678 Kingston Rd.      |Suite 101   |NYC     |NY    |10022     |USA    |NA       |Frick          |Michael         |Medium  |
      10414|             27|    90.37|              8|2439.99|2005-05-06|On Hold|     2|       5|   2005|Ships      |    99|S700_3962  |Gifts4AllAges.com |6175559555|8616 Spinnaker Dr.     |[NULL]      |Boston  |MA    |51003     |USA    |NA       |Yoshido        |Juri            |Small   |
      10107|             30|     95.7|              2|   2871|2003-02-24|Shipped|     1|       2|   2003|Motorcycles|    95|S10_1678   |Land of Toys Inc. |2125557818|897 Long Airport Avenue|[NULL]      |NYC     |NY    |10022     |USA    |NA       |Yu             |Kwai            |Small   |
      10121|             34|    81.35|              5| 2765.9|2003-05-07|Shipped|     2|       5|   2003|Motorcycles|    95|S10_1678   |Reims Collectables|26.47.1555|59 rue de l'Abbaye     |[NULL]      |Reims   |[NULL]|51100     |France |EMEA     |Henriot        |Paul            |Small   |
 
 */





















