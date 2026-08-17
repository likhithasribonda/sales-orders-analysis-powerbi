USE mobile_laptop_analysis;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_reviews FROM reviews;
SELECT COUNT(*) AS total_returns FROM returns;
SELECT * FROM products LIMIT 10;
SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM reviews LIMIT 10;
SELECT * FROM returns LIMIT 10;
-- product analysis
SELECT Product_Name,Brand,Rating FROM products ORDER BY Rating DESC LIMIT 10;
SELECT Brand,COUNT(*) AS total_products FROM products GROUP BY Brand ORDER BY total_products DESC;
SELECT Category,COUNT(*) AS total_products FROM products GROUP BY Category;
SELECT Category,ROUND(AVG(Price_INR), 2) AS average_price FROM products GROUP BY Category;
SELECT Product_Name,Brand,Category,Price_INR FROM products ORDER BY Price_INR DESC LIMIT 10;
-- customer analysis 
SELECT City,COUNT(*) AS total_customers FROM customers GROUP BY City ORDER BY total_customers DESC;
SELECT CASE WHEN Age < 25 THEN '18-24' WHEN Age < 35 THEN '25-34' WHEN Age < 45 THEN '35-44'ELSE '45+'END AS age_group,
COUNT(*) AS customers FROM customers GROUP BY age_group ORDER BY customers DESC
-- sales/order analysis
SELECT p.Category,COUNT(o.Order_ID) AS total_orders FROM orders o JOIN products p ON o.Product_ID = p.Product_ID GROUP BY p.Category;
SELECT p.Brand, COUNT(o.Order_ID) AS total_order FROM orders o JOIN products p ON o.Product_ID = p.Product_ID GROUP BY p.Brand ORDER BY total_orders DESC;
SELECT MONTH(Order_Date) AS month,COUNT(*) AS total_orders FROM orders GROUP BY MONTH(Order_Date) ORDER BY month;
-- customer purchasing analysis
SELECT c.Customer_ID, c.Customer_Name, COUNT(o.Order_ID) AS total_orders FROM customers c JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name ORDER BY total_orders DESC LIMIT 10;
SELECT c.Customer_ID, c.Customer_Name, COUNT(o.Order_ID) AS total_orders FROM customers c JOIN orders o
ON c.Customer_ID = o.Customer_ID GROUP BY c.Customer_ID, c.Customer_Name HAVING COUNT(o.Order_ID) > 1 ORDER BY total_orders DESC;
-- review analysis 
SELECT p.Brand, ROUND(AVG(r.Rating), 2) AS average_rating FROM reviews r JOIN products p ON r.Product_ID = p.Product_ID
GROUP BY p.Brand ORDER BY average_rating DESC;
SELECT p.Product_Name,COUNT(r.Review_ID) AS total_reviews,ROUND(AVG(r.Rating), 2) AS average_rating FROM products p
JOIN reviews r ON p.Product_ID = r.Product_ID GROUP BY p.Product_ID, p.Product_Name ORDER BY total_reviews DESC
-- return analysis 
SELECT Return_Reason, COUNT(*) AS total_returns FROM returns GROUP BY Return_Reason ORDER BY total_returns DESC;
SELECT p.Category, COUNT(r.Return_ID) AS total_returns FROM returns r JOIN products p
ON r.Product_ID = p.Product_ID GROUP BY p.Category;
SELECT p.Brand,COUNT(r.Return_ID) AS total_returns FROM returns r JOIN products p ON r.Product_ID = p.Product_ID
GROUP BY p.Brand ORDER BY total_returns DESC;
-- 
SELECT p.Brand, COUNT(o.Order_ID) AS total_orders,RANK() OVER (ORDER BY COUNT(o.Order_ID) DESC) AS brand_rank FROM orders o 
JOIN products p ON o.Product_ID = p.Product_ID GROUP BY p.Brand;
WITH product_orders AS (SELECT p.Product_ID, p.Product_Name,p.Category,COUNT(o.Order_ID) AS total_orders
FROM products p JOIN orders o ON p.Product_ID = o.Product_ID GROUP BY
p.Product_ID,p.Product_Name,p.Category),
ranked_products AS (SELECT *,RANK() OVER (PARTITION BY Category ORDER BY total_orders DESC) AS product_rank
FROM product_orders) SELECT *FROM ranked_products WHERE product_rank <= 3;
SELECT c.Customer_ID, c.Customer_Name,COUNT(o.Order_ID) AS total_orders FROM customers c JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID,c.Customer_Name HAVING COUNT(o.Order_ID) > 1 ORDER BY total_orders DESC;
SELECT c.Customer_ID, c.Customer_Name,COUNT(o.Order_ID) AS total_orders,RANK() OVER (ORDER BY COUNT(o.Order_ID) DESC) AS customer_rank
FROM customers c JOIN orders o ON c.Customer_ID = o.Customer_ID GROUP BY c.Customer_ID,c.Customer_Name;
SELECT Product_Name, Brand,Price_INR FROM products WHERE Price_INR > (SELECT AVG(Price_INR)
FROM products)ORDER BY Price_INR DESC;