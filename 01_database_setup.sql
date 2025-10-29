CREATE DATABASE coffee_sales_db;
USE coffee_sales_db;

CREATE TABLE coffee_sales (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    transaction_time TIME,
    store_location VARCHAR(50),
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);
02_data_cleaning.sql
Data quality checks and cleaning:

sql
SELECT COUNT(*) FROM coffee_sales WHERE transaction_date IS NULL;
DELETE FROM coffee_sales WHERE transaction_id IN (
    SELECT transaction_id
    FROM (
        SELECT transaction_id, ROW_NUMBER() OVER (PARTITION BY transaction_date, transaction_time, store_location, product_name ORDER BY transaction_id) AS rn
        FROM coffee_sales
    ) t WHERE rn > 1
);
