-- ============================
-- Project: RFM Customer Segmentation (SQL Script)
-- ============================

-- Create Table
CREATE TABLE transactions (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(20),
    description VARCHAR(255),
    quantity INT,
    invoice_date DATE,
    unit_price FLOAT,
    customer_id INT,
    country VARCHAR(100)
);


-- Filtered Sales Data
-- Only positive transactions with known customers
CREATE VIEW clean_sales AS
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    quantity,
    unit_price,
    (quantity * unit_price) AS sales
FROM transactions
WHERE quantity > 0 AND unit_price > 0 AND customer_id IS NOT NULL;

-- Calculate RFM Metrics
CREATE VIEW rfm_table AS
SELECT
    customer_id,
    DATEDIFF('2011-12-10', MAX(invoice_date)) AS recency,
    COUNT(DISTINCT invoice_no) AS frequency,
    ROUND(SUM(sales), 2) AS monetary
FROM clean_sales
GROUP BY customer_id;

-- Select Final RFM Table (for export to CSV or analysis)
SELECT * FROM rfm_table ORDER BY recency;

