# Contributing to E-Commerce SQL Case Study

Thank you for your interest in contributing! This document outlines the process for adding queries, fixing bugs, or extending the project.

---

## How to Contribute

### 1. Fork and Clone

```bash
git clone https://github.com/your-username/ecommerce-sql-case-study.git
cd ecommerce-sql-case-study
git checkout -b feature/your-feature-name
```

### 2. Set Up Your Environment

Follow the [Installation and Setup](README.md#-installation-and-setup) steps in the README to get the database running locally.

### 3. Write Your SQL

- Place new queries in `queries/`
- Use descriptive file names: `customer_cohort_retention.sql`, not `new_query.sql`
- Add a comment header to every new file:

```sql
-- ============================================================
-- Query: Customer Cohort Retention
-- Author: Your Name
-- Date: YYYY-MM-DD
-- Description: Calculates month-1 and month-3 retention rates
--              for each monthly acquisition cohort.
-- ============================================================
```

- Comment complex logic inline so reviewers can follow your reasoning.

### 4. Test Before Submitting

Run your queries against the provided schema. Verify:
- No syntax errors
- Results are non-empty and sensible
- JOINs produce the expected row counts

### 5. Submit a Pull Request

Push your branch and open a Pull Request against `develop`. In the PR description, include:
- **What business question does this answer?**
- **Sample output** (paste a small result table)
- **Any caveats** (e.g., assumes no duplicate order_ids)

---

## Code Style Guidelines

| Rule | Example |
|---|---|
| Keywords in uppercase | `SELECT`, `FROM`, `WHERE`, `GROUP BY` |
| Table/column aliases are descriptive | `o` for orders, `od` for order_details |
| Indent subqueries and CTEs consistently | 4 spaces |
| One clause per line for readability | `SELECT ...\nFROM ...\nWHERE ...` |
| Use CTEs over nested subqueries when possible | `WITH cte AS (...)` |

---

## Ideas for New Contributions

- **Customer cohort analysis** — retention rates by acquisition month
- **Product affinity / market basket** — which products are bought together
- **Revenue by city** — join customers to orders for geographic revenue breakdown  
- **Repeat purchase intervals** — average days between orders per customer
- **Price sensitivity** — do higher-priced products have lower order frequencies?
- **Dashboard integration** — connect results to Metabase, Redash, or Looker Studio

---

## Reporting Issues

If you spot an error in a query or the schema, open a GitHub Issue with:
1. The query or file name
2. The unexpected behavior
3. The MySQL version you're running

---

## License

By contributing, you agree that your contributions will be licensed under the same [MIT License](LICENSE) as this project.
