-- ================================
-- Coffee Shop Sales Analysis (SQL)
-- Portfolio-ready Example File
-- ================================

-- SECTION 1: Database & Table Setup
CREATE DATABASE IF NOT EXISTS coffee_sales_db;
USE coffee_sales_db;

CREATE TABLE IF NOT EXISTS coffee_sales (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE NOT NULL,
    transaction_time TIME NOT NULL,
    store_id INT NOT NULL,
    store_location VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_sale DECIMAL(10,2) NOT NULL
);

-- SECTION 2: Sample Data Insert (OPTIONAL: Replace with your own CSV import)
-- INSERT INTO coffee_sales (transaction_id, transaction_date, transaction_time, store_id, store_location,
--      product_id, product_name, product_category, quantity, unit_price, total_sale)
-- VALUES
-- (1, '2023-05-01', '09:15:00', 1, 'Downtown', 101, 'Cappuccino', 'Beverage', 2, 3.50, 7.00),
-- (2, '2023-05-01', '09:45:00', 2, 'Uptown', 103, 'Blueberry Muffin', 'Bakery', 1, 2.25, 2.25);

-- SECTION 3: Data Cleaning
-- Check for null values
SELECT 
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS null_transaction_date,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product_name
FROM coffee_sales;

-- Remove duplicates by transaction_id
DELETE FROM coffee_sales
WHERE transaction_id NOT IN (
    SELECT MIN(transaction_id)
    FROM coffee_sales
    GROUP BY transaction_date, transaction_time, store_id, product_id
);

-- SECTION 4: Analysis Queries

-- 1. Total Sales by Month
SELECT 
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    SUM(total_sale) AS monthly_sales
FROM coffee_sales
GROUP BY month
ORDER BY month;

-- 2. Revenue By Store Location
SELECT 
    store_location,
    SUM(total_sale) AS total_revenue
FROM coffee_sales
GROUP BY store_location
ORDER BY total_revenue DESC;

-- 3. Top 10 Best-Selling Products
SELECT 
    product_name, 
    SUM(quantity) AS total_units_sold, 
    SUM(total_sale) AS total_revenue
FROM coffee_sales
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 4. Sales Trend (7-Day Moving Average)
SELECT 
    transaction_date,
    SUM(total_sale) AS daily_sales,
    ROUND(AVG(SUM(total_sale)) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS seven_day_moving_avg
FROM coffee_sales
GROUP BY transaction_date
ORDER BY transaction_date;

-- 5. Weekday vs Weekend Sales Comparison
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(transaction_id) AS total_orders,
    SUM(total_sale) AS total_sales
FROM coffee_sales
GROUP BY day_type;

-- ================================
-- End Of File | Upload this to GitHub after saving as .sql
-- ================================
