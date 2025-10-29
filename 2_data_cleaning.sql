SELECT COUNT(*) FROM coffee_sales WHERE transaction_date IS NULL;
DELETE FROM coffee_sales WHERE transaction_id IN (
    SELECT transaction_id
    FROM (
        SELECT transaction_id, ROW_NUMBER() OVER (PARTITION BY transaction_date, transaction_time, store_location, product_name ORDER BY transaction_id) AS rn
        FROM coffee_sales
    ) t WHERE rn > 1
);
