/* ===========================================
   Retail Sales SQL Analysis Project
   Author: Jidnyasa Sonavane
   Database: retail_analysis
=========================================== */

-- -------------------------------------------
-- 1. Create and Select Database
-- -------------------------------------------
Create Database retail_analysis;
USE retail_analysis;

-- -------------------------------------------
-- 2. Basic Data Exploration
-- -------------------------------------------

-- Total number of records
SELECT COUNT(*) AS total_records
FROM sales;

-- Date range of dataset
SELECT 
    MIN(sales_date) AS start_date,
    MAX(sales_date) AS end_date
FROM sales;

-- Total sales revenue
SELECT SUM(sales_amount) AS total_sales
FROM sales;

-- Average sales
SELECT AVG(sales_amount) AS avg_sales
FROM sales;

-- Top 5 highest sales days
SELECT *
FROM sales
ORDER BY sales_amount DESC
LIMIT 5;

-- -------------------------------------------
-- 3. Monthly Aggregation
-- -------------------------------------------

-- Monthly total sales
SELECT 
    MONTH(sales_date) AS month,
    SUM(sales_amount) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;

-- Highest sales month
SELECT 
    MONTH(sales_date) AS month,
    SUM(sales_amount) AS total_sales
FROM sales
GROUP BY month
ORDER BY total_sales DESC
LIMIT 1;

-- -------------------------------------------
-- 4. Segmentation Using CASE
-- -------------------------------------------

-- Categorize daily sales performance
SELECT
    CASE
        WHEN sales_amount < 3000 THEN 'Low'
        WHEN sales_amount BETWEEN 3000 AND 6000 THEN 'Medium'
        ELSE 'High'
    END AS sales_category,
    COUNT(*) AS count_days
FROM sales
GROUP BY sales_category;

-- -------------------------------------------
-- 5. Subquery Analysis
-- -------------------------------------------

-- Days above average sales
SELECT *
FROM sales
WHERE sales_amount >
    (SELECT AVG(sales_amount) FROM sales)
ORDER BY sales_amount DESC;

-- -------------------------------------------
-- 6. Window Functions
-- -------------------------------------------

-- Running total of sales
SELECT 
    sales_date,
    sales_amount,
    SUM(sales_amount)
        OVER (ORDER BY sales_date) AS running_total
FROM sales;

-- Ranking sales days
SELECT 
    sales_date,
    sales_amount,
    RANK()
        OVER (ORDER BY sales_amount DESC) AS sales_rank
FROM sales;

-- Day-to-day sales change
SELECT 
    sales_date,
    sales_amount,
    sales_amount - LAG(sales_amount)
        OVER (ORDER BY sales_date) AS change_from_previous
FROM sales;

-- 7-Day Moving Average
SELECT
    sales_date,
    sales_amount,
    AVG(sales_amount)
        OVER (
            ORDER BY sales_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS moving_avg_7day
FROM sales;
