CREATE DATABASE case_study_2;
USE case_study_2;

# 1.	Market Segmentation Analysis: Identify the top 3 cities with the 
# 		highest number of customers to determine key markets for targeted marketing and logistic optimization.

SELECT location, COUNT(customer_ID) AS number_of_customers
FROM Customers
GROUP BY location 
ORDER BY number_of_customers DESC 
LIMIT 3;

/*
2.	Engagement Depth Analysis: Determine the distribution of customers by the number of orders placed. 
	This insight will help in segmenting customers into one-time buyers, occasional shoppers, and regular customers for tailored marketing strategies. 
*/

SELECT NumberOfOrders, COUNT(*) AS CustomerCount 
FROM (
	SELECT customer_id, COUNT(order_id) AS NumberOfOrders 
	FROM Orders GROUP BY customer_id
) AS CustomerOrders 
GROUP BY NumberOfOrders
ORDER BY NumberOfOrders ASC;

# 3.	Single Purchase High-Value Products: Identify products where the average purchase quantity per order 
# 		is one but with a high total revenue, suggesting premium product trends.

SELECT product_id, AVG(quantity) AS AvgQuantity, 
	SUM(quantity * price_per_unit) AS TotalRevenue 
FROM Order_Details 
GROUP BY product_id 
HAVING AvgQuantity <= 2
ORDER BY TotalRevenue DESC; 

# 4. 	Category-wise Customer Reach: For each product category, calculate the unique number of customers 
# 		purchasing from it. This will help understand which categories have wider appeal across the customer base.

SELECT p.category, COUNT(DISTINCT o.customer_id) AS Unique_Customers 
FROM Orders o 
JOIN Order_Details od ON o.order_id = od.order_id 
JOIN Products p ON od.product_id = p.product_id 
GROUP BY p.category;

# 5.	Sales Trend Analysis: Analyze the month-on-month percentage change in total sales to identify 
# 		growth trends.
select * from orders;
WITH MonthlySales AS 
(
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month, SUM(total_amount) AS TotalSales 
    FROM Orders
    GROUP BY Month 
) 
SELECT Month, TotalSales, 
ROUND(((TotalSales - LAG(TotalSales) OVER (ORDER BY Month)) / LAG(TotalSales) OVER (ORDER BY Month)) * 100, 2) 
AS PercentChange 
FROM MonthlySales;

# 6.	Average Order Value Fluctuation: Examine how the average order value changes month-on-month. 
# 		Insights can guide pricing and promotional strategies to enhance order value.

WITH MonthlyOrderValues AS 
(
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month, AVG(total_amount) AS AvgOrderValue 
    FROM Orders
    GROUP BY Month 
) 
SELECT Month, AvgOrderValue, ROUND((AvgOrderValue - LAG(AvgOrderValue) OVER (ORDER BY Month)), 2) AS ChangeInValue 
FROM MonthlyOrderValues;

# 7.	Inventory Refresh Rate: Based on sales data, identify products with the fastest turnover rates, 
# 		suggesting high demand and the need for frequent restocking.

SELECT product_id, COUNT(order_id) AS SalesFrequency 
FROM Order_Details
GROUP BY product_id ORDER BY SalesFrequency DESC LIMIT 5; 

# 8.	Low Engagement Products: List products purchased by less than 40% of the customer base, 
# 		indicating potential mismatches between inventory and customer interest.

SELECT p.product_id, p.name, COUNT(DISTINCT o.customer_id) AS UniqueCustomerCount 
FROM Products p 
JOIN Order_Details od ON p.product_id = od.product_id
JOIN Orders o ON od.order_id = o.order_id 
GROUP BY p.product_id, p.name -- Added p.name to the GROUP BY clause
HAVING UniqueCustomerCount < (SELECT COUNT(*) FROM Customers) * 0.40; 

# 9.	Customer Acquisition Trends: Evaluate the month-on-month growth rate in the customer 
# 		base to understand the effectiveness of marketing campaigns and market expansion efforts.

WITH MonthlyNewCustomers AS 
(
    SELECT DATE_FORMAT(MIN(order_date), '%Y-%m') AS FirstPurchaseMonth, COUNT(DISTINCT customer_id) AS NewCustomers 
    FROM Orders
    GROUP BY customer_id 
) 
SELECT FirstPurchaseMonth, SUM(NewCustomers) AS TotalNewCustomers 
FROM MonthlyNewCustomers 
GROUP BY FirstPurchaseMonth 
ORDER BY FirstPurchaseMonth;

# 10.	Peak Sales Period Identification: Identify the months with the highest sales volume, 
# 		aiding in planning for stock levels, marketing efforts, and staffing in anticipation of peak demand periods.

SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month, SUM(total_amount) AS TotalSales 
FROM Orders
GROUP BY Month 
ORDER BY TotalSales DESC 
LIMIT 3;


