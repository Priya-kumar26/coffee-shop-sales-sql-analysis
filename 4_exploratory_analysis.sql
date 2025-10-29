SELECT store_location, COUNT(*) AS transactions, SUM(total_sale) AS total_revenue
FROM coffee_sales
GROUP BY store_location;
