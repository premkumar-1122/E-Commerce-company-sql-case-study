# E-Commerce Business Analytics Case Study — SQL Documentation

This document explains the SQL script used to analyze an e-commerce dataset in the `case_study_2` database, which contains four tables:

- **Customers** — customer details (ID, location)
- **Orders** — order-level records (order ID, customer ID, order date, total amount)
- **Order_Details** — line-item details per order (product ID, quantity, price per unit)
- **Products** — product catalog (ID, name, category)

The goal of this analysis is to answer 10 core business questions around market segmentation, customer engagement, product performance, and sales trends.

---

## 1. Database Setup

```sql
CREATE DATABASE case_study_2;
USE case_study_2;
```

Creates the working database and selects it for all subsequent queries.

---

## 2. Market Segmentation Analysis

**Business question:** Which cities have the most customers? Useful for targeted marketing and logistics planning.

```sql
SELECT location, COUNT(customer_ID) AS number_of_customers
FROM Customers
GROUP BY location
ORDER BY number_of_customers DESC
LIMIT 3;
```

Groups customers by city and returns the top 3 cities by customer count.

---

## 3. Engagement Depth Analysis

**Business question:** How are customers distributed by number of orders placed? This helps segment them into one-time buyers, occasional shoppers, and regular customers.

```sql
SELECT NumberOfOrders, COUNT(*) AS CustomerCount
FROM (
    SELECT customer_id, COUNT(order_id) AS NumberOfOrders
    FROM Orders
    GROUP BY customer_id
) AS CustomerOrders
GROUP BY NumberOfOrders
ORDER BY NumberOfOrders ASC;
```

An inner query first counts how many orders each customer placed; the outer query then counts how many customers fall into each order-count bucket (e.g., how many customers placed exactly 1 order, exactly 2 orders, etc.).

---

## 4. Single-Purchase, High-Value Products

**Business question:** Which products are typically bought in small quantities per order but still generate high total revenue? This can indicate premium or high-ticket items.

```sql
SELECT product_id, AVG(quantity) AS AvgQuantity,
       SUM(quantity * price_per_unit) AS TotalRevenue
FROM Order_Details
GROUP BY product_id
HAVING AvgQuantity <= 2
ORDER BY TotalRevenue DESC;
```

Filters to products where the average quantity per order is low (≤2), then ranks them by total revenue generated — surfacing premium, low-volume/high-value products.

---

## 5. Category-wise Customer Reach

**Business question:** For each product category, how many unique customers are buying from it? This shows which categories have the broadest appeal.

```sql
SELECT p.category, COUNT(DISTINCT o.customer_id) AS Unique_Customers
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category;
```

Joins Orders → Order_Details → Products to link each purchase to its category, then counts distinct customers per category.

---

## 6. Sales Trend Analysis (Month-over-Month % Change)

**Business question:** How is total revenue trending month over month?

```sql
WITH MonthlySales AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month, SUM(total_amount) AS TotalSales
    FROM Orders
    GROUP BY Month
)
SELECT Month, TotalSales,
    ROUND(
        ((TotalSales - LAG(TotalSales) OVER (ORDER BY Month))
            / LAG(TotalSales) OVER (ORDER BY Month)) * 100, 2
    ) AS PercentChange
FROM MonthlySales;
```

A CTE first aggregates total sales by month. The outer query then uses the `LAG()` window function to pull the previous month's sales and calculate the percentage change month-over-month.

---

## 7. Average Order Value (AOV) Fluctuation

**Business question:** How does the average order value change from month to month? Useful for guiding pricing and promotions.

```sql
WITH MonthlyOrderValues AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month, AVG(total_amount) AS AvgOrderValue
    FROM Orders
    GROUP BY Month
)
SELECT Month, AvgOrderValue,
       ROUND((AvgOrderValue - LAG(AvgOrderValue) OVER (ORDER BY Month)), 2) AS ChangeInValue
FROM MonthlyOrderValues;
```

Same pattern as above, but tracking the absolute month-over-month change in average order value instead of total sales.

---

## 8. Inventory Refresh Rate (Fastest-Turnover Products)

**Business question:** Which products sell most frequently, indicating high demand and the need for frequent restocking?

```sql
SELECT product_id, COUNT(order_id) AS SalesFrequency
FROM Order_Details
GROUP BY product_id
ORDER BY SalesFrequency DESC
LIMIT 5;
```

Counts how many separate orders included each product, then returns the top 5 fastest-moving products.

---

## 9. Low-Engagement Products

**Business question:** Which products are purchased by less than 40% of the customer base? This flags a potential mismatch between inventory and customer interest.

```sql
SELECT p.product_id, p.name, COUNT(DISTINCT o.customer_id) AS UniqueCustomerCount
FROM Products p
JOIN Order_Details od ON p.product_id = od.product_id
JOIN Orders o ON od.order_id = o.order_id
GROUP BY p.product_id, p.name
HAVING UniqueCustomerCount < (SELECT COUNT(*) FROM Customers) * 0.40;
```

Joins Products, Order_Details, and Orders to count unique buyers per product, then filters to products whose unique-customer count falls below 40% of the total customer base — a subquery calculates that 40% threshold dynamically.

---

## 10. Customer Acquisition Trends

**Business question:** How is the customer base growing month over month? This reflects the effectiveness of marketing and expansion efforts.

```sql
WITH MonthlyNewCustomers AS (
    SELECT DATE_FORMAT(MIN(order_date), '%Y-%m') AS FirstPurchaseMonth,
           COUNT(DISTINCT customer_id) AS NewCustomers
    FROM Orders
    GROUP BY customer_id
)
SELECT FirstPurchaseMonth, SUM(NewCustomers) AS TotalNewCustomers
FROM MonthlyNewCustomers
GROUP BY FirstPurchaseMonth
ORDER BY FirstPurchaseMonth;
```

The CTE finds each customer's very first purchase month (their acquisition month). The outer query then sums how many new customers were acquired in each month, giving a month-by-month acquisition trend.

---

## 11. Peak Sales Period Identification

**Business question:** Which months had the highest sales volume? Useful for planning stock levels, marketing pushes, and staffing ahead of peak demand.

```sql
SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month, SUM(total_amount) AS TotalSales
FROM Orders
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 3;
```

Aggregates total sales by month and returns the top 3 highest-selling months.

---

## Summary of Workflow

1. **Setup** — create and select the database.
2. **Customer-focused analysis** — top markets by location, order-frequency segmentation, category reach, low-engagement products, and acquisition trends.
3. **Product-focused analysis** — premium high-value products and fastest-turnover (best-selling) products.
4. **Time-based trend analysis** — month-over-month sales growth, average order value changes, and peak sales periods (using CTEs and the `LAG()` window function throughout).

This set of queries moves from **who the customers are and how they behave**, to **which products perform well or poorly**, to **how the business is trending over time** — giving a full picture to support marketing, inventory, and pricing decisions.
