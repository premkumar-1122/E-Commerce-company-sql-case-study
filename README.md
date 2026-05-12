# 🛒 E-Commerce SQL Case Study

> A structured SQL analytics case study simulating real-world data analyst tasks for a mid-sized Indian e-commerce company — covering customer segmentation, product performance, sales trend analysis, and inventory optimization.

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Business Context](#-business-context)
- [Technologies and Tools](#-technologies-and-tools)
- [Repository Structure](#-repository-structure)
- [Installation and Setup](#-installation-and-setup)
- [Data Schema](#-data-schema)
- [Business Problems and SQL Solutions](#-business-problems-and-sql-solutions)
- [Key Findings](#-key-findings)
- [GitHub Best Practices](#-github-best-practices)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

---

## 📖 Project Overview

This case study simulates the day-to-day responsibilities of a data analyst at an e-commerce company operating across major Indian cities. Using a relational MySQL database with **100 customers**, **200 orders**, **519 order line items**, and **8 products**, the project answers 10 strategic business questions across four domains:

| Domain | Focus |
|---|---|
| Customer Intelligence | Segmentation, acquisition trends, city-level market analysis |
| Product Analytics | Turnover rates, low-engagement products, revenue per product |
| Sales Operations | Month-on-month growth, peak periods, average order value |
| Inventory Management | Fast-moving items, restock frequency, demand signals |

---

## 🏢 Business Context

The company sells electronics and wearable tech products to customers across 12+ Indian cities. The analytics team is tasked with surfacing insights to guide decisions in:

- **Marketing** — Which cities and segments to target
- **Merchandising** — Which products to promote or delist
- **Finance** — Revenue trends and pricing optimization
- **Supply Chain** — Stock planning for high-demand periods

---

## 🛠 Technologies and Tools

| Tool / Technology | Purpose |
|---|---|
| **MySQL 8.0** | Primary database engine |
| **MySQL Workbench** | Query authoring, schema visualization |
| **SQL** (MySQL dialect) | All analytics queries |
| **CSV** | Portable data export format |
| **Excel / Google Sheets** | Optional: data preview and charting |
| **Git + GitHub** | Version control and collaboration |

**SQL Features Used:**
- Window Functions (`LAG()`, `OVER()`)
- Common Table Expressions (CTEs with `WITH`)
- Aggregate Functions (`COUNT`, `SUM`, `AVG`)
- Multi-table `JOIN` operations
- Subqueries and `HAVING` filters
- `DATE_FORMAT()` for time-series grouping

---

## 📁 Repository Structure

```
ecommerce-sql-case-study/
│
├── data/                          # Raw data files
│   ├── customers_extracted.csv
│   ├── orders_extracted.csv
│   ├── order_details_extracted.csv
│   └── products_extracted.csv
│
├── schema/                        # Database definition
│   └── E-Commerce_SQL_case_study_schema.sql
│
├── queries/                       # Analysis scripts
│   └── E-Commerce_SQL_case_study_scripts.sql
│
├── docs/                          # Supporting documentation
│   └── E-Commerce_Company_case_study_problem_statement.docx
│
├── results/                       # Query outputs (optional: CSV exports)
│   └── .gitkeep
│
├── .gitignore
├── LICENSE
└── README.md
```

> **Tip:** Keep raw data in `data/`, never edit it directly. Place derived or cleaned files in a `results/` folder.

---

## ⚙️ Installation and Setup

### Prerequisites

- [MySQL 8.0+](https://dev.mysql.com/downloads/mysql/) installed locally
- [MySQL Workbench](https://www.mysql.com/products/workbench/) (recommended) or any MySQL client

### Step 1 — Clone the Repository

```bash
git clone https://github.com/your-username/ecommerce-sql-case-study.git
cd ecommerce-sql-case-study
```

### Step 2 — Create the Database and Load Schema

Open MySQL Workbench (or your preferred client) and run:

```sql
CREATE DATABASE IF NOT EXISTS case_study_2;
USE case_study_2;
```

Then execute the schema file to create tables and load all data:

```bash
mysql -u root -p case_study_2 < schema/E-Commerce_SQL_case_study_schema.sql
```

Or from within MySQL Workbench:  
`File → Open SQL Script → schema/E-Commerce_SQL_case_study_schema.sql → Execute`

### Step 3 — Verify the Data Load

```sql
USE case_study_2;

SELECT 'customers'    AS tbl, COUNT(*) AS rows FROM customers    UNION ALL
SELECT 'orders',               COUNT(*)        FROM orders        UNION ALL
SELECT 'order_details',        COUNT(*)        FROM order_details UNION ALL
SELECT 'products',             COUNT(*)        FROM products;
```

**Expected output:**

| tbl | rows |
|---|---|
| customers | 100 |
| orders | 200 |
| order_details | 519 |
| products | 8 |

### Step 4 — Run the Analysis Queries

```bash
mysql -u root -p case_study_2 < queries/E-Commerce_SQL_case_study_scripts.sql
```

Or open `queries/E-Commerce_SQL_case_study_scripts.sql` in Workbench and run individual queries.

---

## 🗃 Data Schema

### Entity Relationship Overview

```
customers ──────────< orders >──────────< order_details >────────── products
(customer_id)        (customer_id)        (order_id)                 (product_id)
                     (order_id)           (product_id)
```

### Table Definitions

#### `customers`
| Column | Type | Description |
|---|---|---|
| `customer_id` | INT | Unique customer identifier |
| `name` | TEXT | Full name of the customer |
| `location` | TEXT | City of residence |

**Sample data:** 100 customers across Delhi, Mumbai, Chennai, Bangalore, Pune, Hyderabad, Jaipur, Kolkata, Ahmedabad, and Lucknow.

---

#### `products`
| Column | Type | Description |
|---|---|---|
| `product_id` | INT | Unique product identifier |
| `name` | TEXT | Product name |
| `category` | TEXT | Product category |
| `price` | INT | Unit price (INR) |

**Catalogue (8 products):**

| product_id | name | category | price (INR) |
|---|---|---|---|
| 1 | Smartphone 6" | Electronics | ₹15,000 |
| 2 | Laptop 15" Pro | Electronics | ₹60,000 |
| 3 | Bluetooth Headphones | Electronics | ₹8,000 |
| 4 | E-Book Reader | Electronics | ₹12,000 |
| 5 | Smartwatch Fitness Tracker | Wearable Tech | ₹5,000 |
| 6 | Portable Bluetooth Speaker | Electronics | ₹7,000 |
| 7 | Digital SLR Camera | Photography | ₹40,000 |
| 8 | Wireless Earbuds | Wearable Tech | ₹3,000 |

---

#### `orders`
| Column | Type | Description |
|---|---|---|
| `order_id` | INT | Unique order identifier |
| `order_date` | TEXT | Date of order (YYYY-MM-DD) |
| `customer_id` | INT | FK → customers.customer_id |
| `total_amount` | INT | Total order value (INR) |

**Date range:** March 2023 – February 2024

---

#### `order_details`
| Column | Type | Description |
|---|---|---|
| `order_id` | INT | FK → orders.order_id |
| `product_id` | INT | FK → products.product_id |
| `quantity` | INT | Units purchased |
| `price_per_unit` | INT | Unit price at time of purchase (INR) |

---

## 🔍 Business Problems and SQL Solutions

### Q1 — Market Segmentation: Top 3 Cities by Customer Count

```sql
SELECT location, COUNT(customer_id) AS number_of_customers
FROM customers
GROUP BY location
ORDER BY number_of_customers DESC
LIMIT 3;
```

**Purpose:** Identify priority markets for targeted marketing spend and logistics investment.

---

### Q2 — Engagement Depth: Customer Order Frequency Distribution

```sql
SELECT NumberOfOrders, COUNT(*) AS CustomerCount
FROM (
    SELECT customer_id, COUNT(order_id) AS NumberOfOrders
    FROM orders
    GROUP BY customer_id
) AS CustomerOrders
GROUP BY NumberOfOrders
ORDER BY NumberOfOrders ASC;
```

**Purpose:** Segment customers into one-time buyers, occasional shoppers, and regulars to tailor retention strategies.

---

### Q3 — High-Value Single-Purchase Products

```sql
SELECT product_id,
       AVG(quantity)               AS AvgQuantity,
       SUM(quantity * price_per_unit) AS TotalRevenue
FROM order_details
GROUP BY product_id
HAVING AvgQuantity <= 2
ORDER BY TotalRevenue DESC;
```

**Purpose:** Identify premium products bought in low quantities but generating significant revenue — ideal candidates for upsell campaigns.

---

### Q4 — Category-Wide Customer Reach

```sql
SELECT p.category, COUNT(DISTINCT o.customer_id) AS Unique_Customers
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p      ON od.product_id = p.product_id
GROUP BY p.category;
```

**Purpose:** Understand which product categories have the broadest customer reach to inform assortment decisions.

---

### Q5 — Month-on-Month Sales Growth

```sql
WITH MonthlySales AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month,
           SUM(total_amount)                AS TotalSales
    FROM orders
    GROUP BY Month
)
SELECT Month,
       TotalSales,
       ROUND(
           ((TotalSales - LAG(TotalSales) OVER (ORDER BY Month))
            / LAG(TotalSales) OVER (ORDER BY Month)) * 100, 2
       ) AS PercentChange
FROM MonthlySales;
```

**Purpose:** Track growth velocity month-over-month to identify acceleration or deceleration in sales.

---

### Q6 — Average Order Value Trends

```sql
WITH MonthlyOrderValues AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month,
           AVG(total_amount)                AS AvgOrderValue
    FROM orders
    GROUP BY Month
)
SELECT Month,
       AvgOrderValue,
       ROUND(AvgOrderValue - LAG(AvgOrderValue) OVER (ORDER BY Month), 2) AS ChangeInValue
FROM MonthlyOrderValues;
```

**Purpose:** Monitor shifts in average order value to guide pricing and promotional strategy.

---

### Q7 — Inventory Refresh Rate: Fastest-Moving Products

```sql
SELECT product_id, COUNT(order_id) AS SalesFrequency
FROM order_details
GROUP BY product_id
ORDER BY SalesFrequency DESC
LIMIT 5;
```

**Purpose:** Identify products needing the most frequent restocking based on raw sales frequency.

---

### Q8 — Low Engagement Products

```sql
SELECT p.product_id, p.name, COUNT(DISTINCT o.customer_id) AS UniqueCustomerCount
FROM products p
JOIN order_details od ON p.product_id  = od.product_id
JOIN orders o         ON od.order_id   = o.order_id
GROUP BY p.product_id, p.name
HAVING UniqueCustomerCount < (SELECT COUNT(*) FROM customers) * 0.40;
```

**Purpose:** Flag products with low customer penetration (bought by fewer than 40% of the base) that may need repositioning or discounting.

---

### Q9 — Customer Acquisition Trends

```sql
WITH MonthlyNewCustomers AS (
    SELECT DATE_FORMAT(MIN(order_date), '%Y-%m') AS FirstPurchaseMonth,
           COUNT(DISTINCT customer_id)            AS NewCustomers
    FROM orders
    GROUP BY customer_id
)
SELECT FirstPurchaseMonth,
       SUM(NewCustomers) AS TotalNewCustomers
FROM MonthlyNewCustomers
GROUP BY FirstPurchaseMonth
ORDER BY FirstPurchaseMonth;
```

**Purpose:** Measure how effectively marketing campaigns are bringing in new buyers each month.

---

### Q10 — Peak Sales Periods

```sql
SELECT DATE_FORMAT(order_date, '%Y-%m') AS Month,
       SUM(total_amount)                AS TotalSales
FROM orders
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 3;
```

**Purpose:** Identify the top 3 revenue months to align inventory builds, marketing pushes, and staffing.

---

## 📊 Key Findings

| # | Finding |
|---|---|
| 1 | **Delhi, Chennai, and Jaipur** emerge as the top three customer markets, together accounting for a significant share of the 100-customer base. |
| 2 | The majority of customers are **occasional or one-time buyers**, highlighting a strong opportunity for loyalty programs. |
| 3 | The **Laptop 15" Pro** (₹60,000) and **Digital SLR Camera** (₹40,000) generate the highest total revenue despite low average purchase quantities — classic premium product patterns. |
| 4 | **Electronics** is the dominant category by customer reach, while **Photography** has the narrowest appeal. |
| 5 | Sales show visible **month-on-month fluctuation**, with notable spikes suggesting seasonal demand patterns. |
| 6 | **Average order value** varies significantly by month, providing windows for promotional pricing intervention. |
| 7 | **Bluetooth Headphones** and **E-Book Reader** appear most frequently in orders — candidates for safety stock increases. |
| 8 | Most products are purchased by fewer than 40% of customers, indicating significant untapped cross-sell potential. |
| 9 | New customer acquisition shows an uneven monthly pattern, suggesting campaign timing affects intake volumes. |
| 10 | **Peak revenue months** cluster around specific periods (late 2023), useful for Q4 planning and seasonal campaigns. |

---

## 🗂 GitHub Best Practices

### Directory Organization

Follow the structure defined in [Repository Structure](#-repository-structure). Key principles:

- `data/` — immutable raw files only; never overwrite originals
- `schema/` — DDL and seed scripts; run once per environment
- `queries/` — analytical SQL scripts; one file per theme or module as the project grows
- `docs/` — problem statements, wireframes, presentation decks
- `results/` — exported query outputs; gitignore large files

### Naming Conventions

| Asset | Convention | Example |
|---|---|---|
| SQL files | `snake_case` | `customer_segmentation.sql` |
| Data files | `snake_case` | `orders_extracted.csv` |
| Branches | `kebab-case` | `feature/add-cohort-analysis` |
| Commits | Imperative, present tense | `Add month-on-month sales query` |

### Branching Strategy

```
main          ← stable, production-ready queries only
└── develop   ← integration branch for ongoing work
    ├── feature/customer-cohorts
    ├── feature/inventory-analysis
    └── fix/sales-trend-date-format
```

Merge `feature/*` branches into `develop` via pull request, then `develop` into `main` after review.

### Recommended `.gitignore`

```gitignore
# MySQL dumps with sensitive credentials
*.cnf
my.ini

# Large data exports
results/*.csv
results/*.xlsx

# OS artifacts
.DS_Store
Thumbs.db

# Editor configs
.vscode/
*.iml
```

### Commit Message Format

Use the format: `<type>: <short description>`

```
feat: add customer acquisition trend query
fix: correct HAVING clause in low-engagement query
docs: update README with ER diagram description
data: add order_details CSV export
refactor: extract monthly sales logic into CTE
```

### Supplementary Files to Include

| File | Purpose |
|---|---|
| `README.md` | Project overview (this file) |
| `LICENSE` | Clarifies reuse rights (MIT recommended for open study projects) |
| `.gitignore` | Prevents committing credentials or large outputs |
| `CONTRIBUTING.md` | Contribution guidelines (see below) |
| `CHANGELOG.md` | Optional: documents schema or query changes over time |

---

## 🤝 Contributing

Contributions that extend the analysis, improve query efficiency, or add visualizations are welcome.

1. **Fork** this repository
2. Create a feature branch: `git checkout -b feature/your-analysis`
3. Write your SQL queries with inline comments explaining intent
4. Test queries against the provided schema before committing
5. Submit a **Pull Request** with a clear description of what the query answers and why it matters

**Contribution ideas:**
- Add customer cohort retention analysis
- Build a product affinity / market basket query
- Export results to a dashboard (Metabase, Tableau Public, Google Looker Studio)
- Add indexes to the schema and document performance improvements

---

## 📄 License

This project is released under the [MIT License](LICENSE). You are free to use, adapt, and share this work with attribution.

---

## 📬 Contact

| | |
|---|---|
| **Maintainer** | Your Name |
| **Email** | your.email@example.com |
| **LinkedIn** | [linkedin.com/in/yourprofile](https://linkedin.com/in/yourprofile) |
| **GitHub** | [github.com/your-username](https://github.com/your-username) |

---

*Built with MySQL 8.0 · Case study data represents a fictional Indian e-commerce company · All monetary values are in Indian Rupees (INR)*
