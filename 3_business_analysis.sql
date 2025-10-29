-- Monthly sales trends  
SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS month, SUM(total_sale) AS monthly_sales
FROM coffee_sales
GROUP BY month;

-- Peak hours  
SELECT HOUR(transaction_time) AS hour, SUM(total_sale) AS revenue
FROM coffee_sales
GROUP BY hour
ORDER BY revenue DESC;
