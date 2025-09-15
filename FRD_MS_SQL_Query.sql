SELECT * FROM FRD


-- # CLEANING AND TRANSFORMING
ALTER TABLE FRD
ADD benford_law INT

UPDATE FRD
SET benford_law = LEFT(purchase_value, 1)


-- # TESTING BENFORD LAW 
SELECT benford_law, (COUNT(*)*1.0/(SELECT COUNT(*) FROM FRD)*100) AS percentage_dist
FROM FRD
GROUP BY benford_law
ORDER BY benford_law

SELECT benford_law,
	   ROUND(COUNT(CASE WHEN class = '1' THEN 1
						ELSE NULL
						END)*1.0/COUNT(*)*100,2) AS fraudulent_transactions_percent
FROM FRD
GROUP BY benford_law
ORDER BY fraudulent_transactions_percent


-- # DATA ANALYSIS
SELECT * FROM FRD


-- Checking the Fradulent Distribution by purchase_time by day.
SELECT
	DAY(purchase_time) AS Day,
	COUNT(CASE WHEN class = '0' THEN 1
			   ELSE NULL
			   END) AS 'Legit',
	COUNT(CASE WHEN class = '1' THEN 1
			   ELSE NULL
			   END) AS 'Fraud'
FROM FRD
GROUP BY Day(purchase_time)
ORDER BY Day


-- Checking the Fradulent Distribution by purchase_time by month.
SELECT
	MONTH(purchase_time) AS Month,
	COUNT(CASE WHEN class = '0' THEN 1
			   ELSE NULL
			   END) AS 'Legit',
	COUNT(CASE WHEN class = '1' THEN 1
			   ELSE NULL
			   END) AS 'Fraud'
FROM FRD
GROUP BY Month(purchase_time)
ORDER BY Month


-- Checking the Fradulent Distribution by signup_time by day.
SELECT
	DAY(signup_time) AS Day,
	COUNT(CASE WHEN class = '0' THEN 1
			   ELSE NULL
			   END) AS 'Legit',
	COUNT(CASE WHEN class = '1' THEN 1
			   ELSE NULL
			   END) AS 'Fraud'
FROM FRD
GROUP BY Day(signup_time)
ORDER BY Day


-- Checking the Fradulent Distribution by signup_time by month.
SELECT
	MONTH(signup_time) AS Month,
	COUNT(CASE WHEN class = '0' THEN 1
			   ELSE NULL
			   END) AS 'Legit',
	COUNT(CASE WHEN class = '1' THEN 1
			   ELSE NULL
			   END) AS 'Fraud'
FROM FRD
GROUP BY Month(signup_time)
ORDER BY Month


-- Checking the difference of days between the signup_time and the purchase_time.
SELECT 
	DATEDIFF(DAY, signup_time, purchase_time) AS Day,
	COUNT(CASE WHEN class = '0' THEN 1
			   ELSE NULL
			   END) AS 'Legit',
	COUNT(CASE WHEN class = '1' THEN 1
			   ELSE NULL
			   END) AS 'Fraud'
FROM FRD
GROUP BY DATEDIFF(Day, signup_time, purchase_time)
ORDER BY DAY


SELECT MIN(purchase_value) AS max_purchase_value, MAX(purchase_value) AS min_purchase_value
FROM FRD


-- # CREATING A PURCHASE VALUE GROUP
WITH cte AS ( 
	 SELECT
	 CASE WHEN purchase_value >= 9 AND purchase_value <= 10 THEN '9-10'
		  WHEN purchase_value > 10 AND purchase_value <= 20 THEN '11-20'
		  WHEN purchase_value > 20 AND purchase_value <= 30 THEN '21-30'
		  WHEN purchase_value > 30 AND purchase_value <= 40 THEN '31-40'
		  WHEN purchase_value > 40 AND purchase_value <= 50 THEN '41-50'
		  WHEN purchase_value > 50 AND purchase_value <= 60 THEN '51-60'
		  WHEN purchase_value > 60 AND purchase_value <= 70 THEN '61-70'
		  WHEN purchase_value > 70 AND purchase_value <= 80 THEN '71-80'
		  WHEN purchase_value > 80 AND purchase_value <= 90 THEN '81-90'
		  WHEN purchase_value > 90 AND purchase_value <= 100 THEN '91-100'
		  WHEN purchase_value > 100 AND purchase_value <= 110 THEN '101-110'
		  WHEN purchase_value > 110 AND purchase_value <= 120 THEN '111-120'
		  WHEN purchase_value > 120 AND purchase_value <= 130 THEN '121-130'
		  WHEN purchase_value > 130 AND purchase_value <= 140 THEN '131-140'
		  WHEN purchase_value > 140 AND purchase_value <= 150 THEN '141-150'
		  WHEN purchase_value > 150 AND purchase_value <= 160 THEN '151-160'
	 ELSE NULL
	 END AS purchase_value_group,
	 Class
FROM FRD)
SELECT purchase_value_group,
	   COUNT(CASE WHEN class = '0' THEN 1
				  ELSE NULL
				  END) AS 'Legit',
	   COUNT(CASE WHEN class = '1' THEN 1
				  ELSE NULL
				  END) AS 'Fraud'
FROM cte
GROUP BY purchase_value_group
ORDER BY Fraud DESC


-- # CREATING A AGE VALUE GROUP
WITH cte AS (
	 SELECT
	 CASE WHEN age >= 18 AND age <= 25 THEN '18-25'
		  WHEN age > 25 AND age <= 30 THEN '26-30'
		  WHEN age > 30 AND age <= 35 THEN '31-35'
 		  WHEN age > 35 AND age <= 40 THEN '36-40'
 		  WHEN age > 40 AND age <= 45 THEN '41-45'
 		  WHEN age > 45 AND age <= 50 THEN '46-50'
 		  WHEN age > 50 AND age <= 55 THEN '51-55'
		  WHEN age > 55 AND age <= 60 THEN '56-60'
		  WHEN age > 60 AND age <= 65 THEN '61-65'
		  WHEN age > 65 AND age <= 70 THEN '66-70'
		  WHEN age > 70 AND age <= 75 THEN '71-75'
		  WHEN age > 75 AND age <= 80 THEN '76-80'
	ELSE NULL
	END AS age_group,
	Class
FROM FRD)
SELECT age_group,
	   COUNT(CASE WHEN class = '0' THEN 1
				  ELSE NULL
				  END) AS 'Legit',
	   COUNT(CASE WHEN class = '1' THEN 0
				  ELSE NULL
				  END) AS 'Fraud'
FROM cte
GROUP BY age_group
ORDER BY Fraud DESC


-- # Determining the source
SELECT source,
	   ROUND(COUNT(CASE WHEN class = '0' THEN 1
				  ELSE NULL
				  END)*1.0/COUNT(*)*100,2) AS Fraudulent_Transactions_Percent
FROM FRD
GROUP BY source


-- # Determining the legit and fraudulent transactions by gender.
SELECT sex,
	   COUNT(CASE WHEN class = '0' THEN 1
				  ELSE NULL
				  END) AS 'Legit',
	   COUNT(CASE WHEN class = '1' THEN 0
				  ELSE NULL
				  END) AS 'Fraud'
FROM FRD
GROUP BY sex


-- #FINAL TEST
SELECT
	MONTH(signup_time) AS Month,
	source,
	COUNT(CASE WHEN class  = '0' THEN 1
			   ELSE NULL
			   END) AS 'Legit_Transactions',
	COUNT(CASE WHEN class  = '1' THEN 0
			   ELSE NULL
			   END) AS 'Fraudulent_Transactions',
	ROUND(COUNT(CASE WHEN class = '1' THEN 1
					 ELSE NULL
					 END)*1.0/COUNT(*)*100,2) AS Fraudulent_Transactions_Percent
FROM FRD
WHERE DATEDIFF(DAY, signup_time, purchase_time) < 1
AND source = 'direct' AND MONTH(signup_time) < 2
GROUP BY MONTH(signup_time), source
ORDER BY MONTH


SELECT SUM(purchase_value)
FROM FRD
WHERE DATEDIFF(DAY, signup_time, purchase_time) < 1
AND source = 'direct' AND MONTH(signup_time) < 2


SELECT COUNT(*)
FROM FRD
WHERE class = '1'


SELECT SUM(purchase_value)
FROM FRD
WHERE class = '1'