-- Show a Sample of the data.

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

--NUMBER OF COUNTRIES IN WHICH WERE TAKING PLACE
SELECT 
	COUNT(DISTINCT(COUNTRY)) AS country_count
FROM 
	sales_project.sales_data;

/*

country_count|
-------------+
           19|

*/
--IT WAS FOUND OUT THAT THE COMPANY IS SENDING ORDER IN 19 DIFFERENT COUNTRIES


--DIFFERENT TYPES OF ORDER STATUSES AND THEIR COUNT
SELECT DISTINCT
	STATUS AS types_of_statuses,
	count(*) AS status_count
FROM 
	sales_project.sales_data
GROUP BY
	status;

/*

types_of_statuses|status_count|
-----------------+------------+
Cancelled        |          60|
Disputed         |          14|
In Process       |          41|
On Hold          |          44|
Resolved         |          47|
Shipped          |        2617|

*/


--DIFFERENT TYPES OF PRODUCTS
SELECT DISTINCT
	PRODUCTLINE,
	count(*) AS product_count
FROM 
	sales_project.sales_data
GROUP BY
	productline;

/*

productline     |product_count|
----------------+-------------+
Classic Cars    |          967|
Motorcycles     |          331|
Planes          |          306|
Ships           |          234|
Trains          |           77|
Trucks and Buses|          301|
Vintage Cars    |          607|

*/


--NUMBER OF DISTINCT CUSTOMERS
SELECT
	count(DISTINCT CUSTOMERNAME) AS number_of_customers
FROM 
	sales_project.sales_data;

/*

number_of_customers|
-------------------+
                 92|

*/


--DATA EXPLORATORY ANALYSIS

--1. FINDING OUT THE PRODUCT OF HIGHEST SALES
  
SELECT 
	PRODUCTLINE, 
	SUM(SALES) AS TOTAL_SALES
FROM 
	sales_project.sales_data
GROUP BY 
	PRODUCTLINE
ORDER BY
	total_sales DESC;

/*

productline     |total_sales|
----------------+-----------+
Classic Cars    | 3919615.66|
Vintage Cars    | 1903150.84|
Motorcycles     | 1166388.34|
Trucks and Buses| 1127789.84|
Planes          |  975003.57|
Ships           |  714437.13|
Trains          |  226243.47|

*/

--It was found out that Classical Cars has the most highest sales and Trains have the lowest sales.

--2. FINDING OUT THE BEST YEAR OF SALES

SELECT 
	YEAR_ID, 
	SUM(SALES) AS REVENUE
FROM 
	sales_project.sales_data
GROUP BY 
	YEAR_ID
ORDER BY 
	REVENUE DESC;

/*

year_id|revenue   |
-------+----------+
   2004|4724162.60|
   2003|3516979.54|
   2005|1791486.71|

*/

--It was found out that year 2004 has the highest sales and 2005 has the lowest sales.

--3. FURTHER ANALYSIS WAS DONE IN ORDER TO FIND OUT WHY 2005 HAVE LEAST SALES

SELECT 
	year_id,
	count(DISTINCT MONTH_ID) AS total_months_recorded
FROM 
	sales_project.sales_data
GROUP BY
	year_id;

/*

year_id|total_month|
-------+-----------+
   2003|         12|
   2004|         12|
   2005|          5|

*/

--IT WAS FOUND OUT THAT 2005 HAD THE LEAST SALES BECAUSE SALES TOOK PLACE FOR ONLY 5 MONTHS 

--4. WHICH MONTH HAS THE BEST SALES 

WITH get_ranks AS (
	SELECT 
		year_id,
		MONTH_ID,
		SUM(SALES) AS REVENUE, 
		COUNT(ORDERLINENUMBER) AS FREQUENCY,
		DENSE_RANK() OVER (
			PARTITION BY year_id
			ORDER BY sum(sales) DESC
		) AS rankings
	FROM 
		sales_project.sales_data
	GROUP BY
		year_id,
		MONTH_ID
)
SELECT
	year_id,
	month_id,
	revenue,
	frequency
FROM
	get_ranks
WHERE
	rankings = 1;


/*

year_id|month_id|revenue   |frequency|
-------+--------+----------+---------+
   2003|      11|1029837.66|      296|
   2004|      11|1089048.01|      301|
   2005|       5| 457861.06|      120|

*/

--It was found out that the year 2004 and 2003 have their highest sales in  the month of November, while in the year 2005 highest sales took place in month of May

--5. WHICH TOP 3 COUNTRIES HAD THE MOST SALES

SELECT DISTINCT 
	COUNTRY, 
	SUM(SALES) AS REVENUE
FROM 
	sales_project.sales_data
GROUP BY 
	COUNTRY
ORDER BY 
	REVENUE DESC
LIMIT 3;

/*

country|revenue   |
-------+----------+
USA    |3627982.83|
Spain  |1215686.92|
France |1110916.52|

*/

--It was found out that USA, SPAIN and FRANCE had the most sales.

--6. WHO IS THE BEST CUSTOMER

SELECT 
	CUSTOMERNAME, 
	SUM(QUANTITYORDERED) AS total_ordered
FROM 
	sales_project.sales_data
GROUP BY 
	CUSTOMERNAME
ORDER BY 
	total_ordered DESC
LIMIT 1;

/*

customername         |total_ordered|
---------------------+-------------+
Euro Shopping Channel|         9327|

*/

--It was found out that Euro Shopping Channel is the best customer.

--7. FURTHER ANALYSIS WAS DONE TO FIND OUT THE STATUS OF THE CUSTOMERS

/**************************************************
 * 
 * Please note that this query is not correct.  You are trying to
 * get an average AFTER aggregation and its giving incorrect results.
 * I added an avg_quatity_ordered to show how the value is contantly 
 * changing.
 * 
 */
SELECT 
	CUSTOMERNAME, 
	round(AVG(QUANTITYORDERED), 2) AS avg_quantity_ordered,
	COUNT(QUANTITYORDERED) AS number_of_orders,
	CASE 
		WHEN count(QUANTITYORDERED) >= AVG(QUANTITYORDERED) THEN 'Frequent Customer'
		ELSE 'Infrequent Customer'
	END CUSTOMER_STATUS
FROM 
	sales_project.sales_data
GROUP BY 
	CUSTOMERNAME
ORDER BY 
	number_of_orders DESC;

/*
 
 customername                      |avg_quantity_ordered|number_of_orders|customer_status    |
----------------------------------+--------------------+----------------+-------------------+
Euro Shopping Channel             |               36.01|             259|Frequent Customer  |
Mini Gifts Distributors Ltd.      |               35.37|             180|Frequent Customer  |
Australian Collectors, Co.        |               35.02|              55|Frequent Customer  |
La Rochelle Gifts                 |               34.57|              53|Frequent Customer  |
AV Stores, Co.                    |               34.86|              51|Frequent Customer  |
Land of Toys Inc.                 |               33.29|              49|Frequent Customer  |
Rovelli Gifts                     |               34.38|              48|Frequent Customer  |
Muscle Machine Inc                |               36.98|              48|Frequent Customer  |
Souveniers And Things Co.         |               34.80|              46|Frequent Customer  |
Anna's Decorations, Ltd           |               31.93|              46|Frequent Customer  |
Dragon Souveniers, Ltd.           |               35.44|              43|Frequent Customer  |
Reims Collectables                |               34.95|              41|Frequent Customer  |
Corporate Gift Ideas Co.          |               35.29|              41|Frequent Customer  |
Saveley & Henriot, Co.            |               34.83|              41|Frequent Customer  |
Salzburg Collectables             |               36.05|              40|Frequent Customer  |
The Sharp Gifts Warehouse         |               41.40|              40|Infrequent Customer|
L'ordine Souveniers               |               32.82|              39|Frequent Customer  |
Scandinavian Gift Ideas           |               35.76|              38|Frequent Customer  |
Handji Gifts& Co                  |               34.33|              36|Frequent Customer  |
Danish Wholesale Imports          |               36.53|              36|Infrequent Customer|
Mini Creations Ltd.               |               32.57|              35|Frequent Customer  |
Technics Stores Inc.              |               34.68|              34|Infrequent Customer|
Online Diecast Creations Co.      |               36.71|              34|Infrequent Customer|
Baane Mini Imports                |               33.81|              32|Infrequent Customer|
Oulu Toy Supplies, Inc.           |               34.69|              32|Infrequent Customer|
Corrida Auto Replicas, Ltd        |               36.34|              32|Infrequent Customer|
Tokyo Collectables, Ltd           |               35.94|              32|Infrequent Customer|
Vida Sport, Ltd                   |               34.77|              31|Infrequent Customer|
Diecast Classics Inc.             |               35.84|              31|Infrequent Customer|
Suominen Souveniers               |               34.37|              30|Infrequent Customer|
Toys4GrownUps.com                 |               35.33|              30|Infrequent Customer|
Toys of Finland, Co.              |               35.03|              30|Infrequent Customer|
Herkku Gifts                      |               33.55|              29|Infrequent Customer|
Signal Gift Stores                |               32.03|              29|Infrequent Customer|
UK Collectables, Ltd.             |               36.07|              29|Infrequent Customer|
Auto Canal Petit                  |               37.07|              27|Infrequent Customer|
Heintze Collectables              |               32.67|              27|Infrequent Customer|
Marta's Replicas Co.              |               36.15|              27|Infrequent Customer|
FunGiftIdeas.com                  |               34.73|              26|Infrequent Customer|
Mini Classics                     |               35.73|              26|Infrequent Customer|
Gifts4AllAges.com                 |               35.88|              26|Infrequent Customer|
Cruz & Sons Co.                   |               36.96|              26|Infrequent Customer|
Stylish Desk Decors, Co.          |               36.04|              26|Infrequent Customer|
Toms Spezialitten, Ltd            |               36.00|              26|Infrequent Customer|
giftsbymail.co.uk                 |               34.42|              26|Infrequent Customer|
Amica Models & Co.                |               32.42|              26|Infrequent Customer|
Royal Canadian Collectables, Ltd. |               33.58|              26|Infrequent Customer|
Gift Depot Inc.                   |               36.12|              25|Infrequent Customer|
Vitachrome Inc.                   |               31.48|              25|Infrequent Customer|
Collectable Mini Designs Co.      |               38.16|              25|Infrequent Customer|
Petit Auto                        |               31.84|              25|Infrequent Customer|
Marseille Mini Autos              |               32.16|              25|Infrequent Customer|
Collectables For Less Inc.        |               33.13|              24|Infrequent Customer|
Norway Gifts By Mail, Co.         |               32.79|              24|Infrequent Customer|
Enaco Distributors                |               38.35|              23|Infrequent Customer|
Motor Mint Distributors Inc.      |               31.74|              23|Infrequent Customer|
Australian Collectables, Ltd      |               30.65|              23|Infrequent Customer|
La Corne D'abondance, Co.         |               36.35|              23|Infrequent Customer|
Canadian Gift Exchange Network    |               31.95|              22|Infrequent Customer|
Blauer See Auto, Co.              |               36.86|              22|Infrequent Customer|
Quebec Home Shopping Network      |               32.59|              22|Infrequent Customer|
Mini Wheels Co.                   |               32.95|              21|Infrequent Customer|
Tekni Collectables Inc.           |               43.14|              21|Infrequent Customer|
Classic Gift Ideas, Inc           |               31.81|              21|Infrequent Customer|
Daedalus Designs Imports          |               34.95|              20|Infrequent Customer|
Osaka Souveniers Co.              |               34.60|              20|Infrequent Customer|
Lyon Souveniers                   |               34.20|              20|Infrequent Customer|
Alpha Cognac                      |               34.35|              20|Infrequent Customer|
Classic Legends Inc.              |               36.00|              20|Infrequent Customer|
Volvo Model Replicas, Co          |               34.05|              19|Infrequent Customer|
Mini Caravy                       |               41.00|              19|Infrequent Customer|
Gift Ideas Corp.                  |               35.05|              19|Infrequent Customer|
Auto Assoc. & Cie.                |               35.39|              18|Infrequent Customer|
Diecast Collectables              |               38.61|              18|Infrequent Customer|
Super Scale Inc.                  |               37.41|              17|Infrequent Customer|
Clover Collections, Co.           |               30.63|              16|Infrequent Customer|
Online Mini Collectables          |               38.13|              15|Infrequent Customer|
Australian Gift Network, Co       |               36.33|              15|Infrequent Customer|
Signal Collectibles Ltd.          |               34.27|              15|Infrequent Customer|
Iberia Gift Imports, Corp.        |               39.27|              15|Infrequent Customer|
Mini Auto Werke                   |               35.47|              15|Infrequent Customer|
Bavarian Collectables Imports, Co.|               28.64|              14|Infrequent Customer|
Men 'R' US Retailers, Ltd.        |               35.71|              14|Infrequent Customer|
West Coast Collectables Co.       |               39.31|              13|Infrequent Customer|
CAF Imports                       |               36.00|              13|Infrequent Customer|
Double Decker Gift Stores, Ltd    |               29.75|              12|Infrequent Customer|
Cambridge Collectables Co.        |               32.45|              11|Infrequent Customer|
Microscale Inc.                   |               38.10|              10|Infrequent Customer|
Royale Belge                      |               34.75|               8|Infrequent Customer|
Auto-Moto Classics Inc.           |               35.88|               8|Infrequent Customer|
Atelier graphique                 |               38.57|               7|Infrequent Customer|
Boards & Toys Co.                 |               34.00|               3|Infrequent Customer|
 */
	
	