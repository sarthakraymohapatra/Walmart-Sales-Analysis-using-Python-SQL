SELECT * FROM walmart;

-- Business Problems

-- 1. Find different payment method and number of transactions, number of quantity sold.
SELECT
	payment_method,
	COUNT(*) AS no_of_payments,
	SUM(quantity) AS quantity_sold
FROM walmart
GROUP BY payment_method;

-- 2. Identity the highest-rated category in each branch, displaying the branch, category, AVG rating.
SELECT *
FROM
	(SELECT
		branch,
		category,
		AVG(rating) AS avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS RANK
	FROM walmart
	GROUP BY 1, 2)
WHERE RANK = 1;

-- 3. Identify the busiest day for each branch based on the number of transactions.
SELECT *
FROM
	(SELECT
		 branch,
		 TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') AS day_name,
		 COUNT(*) AS no_transactions,
		 RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS RANK
	FROM walmart
	GROUP BY 1, 2)
WHERE RANK = 1;

-- 4. Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.
SELECT
	payment_method,
	SUM(quantity) AS total_quantity
FROM walmart
GROUP BY payment_method;

-- 5. Determine the average, minimum, and maximum rating of category for each city. List the city, average_rating, min_rating, and max_rating.
SELECT
	city,
	category,
	AVG(rating) as average_rating,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating
FROM walmart
GROUP BY 1, 2;

-- 6. Calculate the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin). List category and total_profit, ordered from highest to lowest profit.
SELECT
	category,
	SUM(total) AS revenue,
	SUM(total * profit_margin) AS total_profit
FROM walmart
GROUP BY 1;

-- 7. Determine the most common payment method for each Branch. Display Branch and the preferred_payment_method.
SELECT
	branch,
	payment_method,
	COUNT(*) AS total_transactions,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS RANK
FROM walmart
GROUP BY 1, 2;

-- 8. Categorize sales into 3 group MORNING, AFTERNOON, EVENING. Find out which of the shift and number of invoices.
SELECT
	branch,
	CASE
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- 9. Identify 5 branch with highest decrease ratio in revenue compare to last year (current year 2023 and last year 2022).
