CREATE DATABASE ecommerce;
USE ecommerce;
CREATE TABLE orders (
    order_id        VARCHAR(20),
    customer_id     VARCHAR(20),
    product_id      VARCHAR(20),
    category        VARCHAR(50),
    price           DECIMAL(10,2),
    discount        DECIMAL(4,2),
    quantity        INT,
    payment_method  VARCHAR(30),
    order_date      DATE,
    delivered_date  DATE,
    region          VARCHAR(30),
    returned        VARCHAR(5),
    request_date    VARCHAR(20),
    return_reason   VARCHAR(50),
    total_amount    DECIMAL(10,2),
    shipping_cost   DECIMAL(10,2),
    profit_margin   DECIMAL(10,2),
    customer_age    INT,
    customer_gender VARCHAR(20),
    order_month     VARCHAR(10),
    delivery_days   INT,
    is_returned     INT,
    net_sales       DECIMAL(10,2)
);

-- Overall KPIs-- 
SELECT COUNT(*) AS orders,
ROUND(SUM(total_amount)) AS sales,
ROUND(SUM(net_sales)) AS net_sales,
ROUND(AVG(total_amount), 2) AS aov,
ROUND(AVG(is_returned) * 100, 2) AS return_pct
FROM orders;

-- Category performance-- 
SELECT category,
COUNT(*) AS orders,
ROUND(SUM(total_amount)) AS sales,
ROUND(SUM(profit_margin)) AS profit,
ROUND(AVG(is_returned) * 100, 2) AS return_pct
FROM orders
GROUP BY category
ORDER BY sales DESC;


-- Region performance-- 
SELECT region,
ROUND(SUM(total_amount)) AS sales,
ROUND(AVG(is_returned) * 100, 2) AS return_pct
FROM orders
GROUP BY region
ORDER BY sales DESC;


-- Monthly sales trend-- 
SELECT order_month, ROUND(SUM(total_amount)) AS sales
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- Return reasons-- 
SELECT return_reason, COUNT(*) AS total
FROM orders
WHERE returned = 'Yes'
GROUP BY return_reason
ORDER BY total DESC;

-- Top 5 customers-- 
SELECT customer_id, COUNT(*) AS orders, ROUND(SUM(total_amount)) AS spent
FROM orders
GROUP BY customer_id
ORDER BY spent DESC
LIMIT 5;

-- Discount ka return par asar-- 
SELECT CASE WHEN discount = 0 THEN 'No Discount'
            WHEN discount <= 0.10 THEN 'Low'
            ELSE 'High' END AS discount_group,
       COUNT(*) AS orders,
       ROUND(AVG(is_returned) * 100, 2) AS return_pct
FROM orders
GROUP BY discount_group;

-- Month-over-Month growth-- 

SELECT order_month,
       ROUND(SUM(total_amount)) AS sales,
       ROUND((SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY order_month))
             * 100.0 / LAG(SUM(total_amount)) OVER (ORDER BY order_month), 1) AS growth_pct
FROM orders
GROUP BY order_month
ORDER BY order_month;


SELECT category, return_reason, COUNT(*) AS total
FROM orders
WHERE returned = 'Yes'
GROUP BY category, return_reason
ORDER BY category, total DESC;



