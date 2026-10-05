# Task 3 – SQL for Data Analysis

**Data Analyst Internship – Elevate Labs**

## Objective
Use SQL queries to extract and analyze data from an e-commerce database.

## Tool
SQLite

## Dataset
A small e-commerce SQL database created specifically for this task. It contains:
- `customers`
- `products`
- `orders`
- `order_items`

## SQL concepts demonstrated
1. `SELECT`
2. `WHERE`
3. `ORDER BY`
4. `GROUP BY`
5. Aggregate functions: `SUM()`, `AVG()`, `COUNT()`
6. `INNER JOIN`
7. `LEFT JOIN`
8. Subqueries
9. Revenue analysis / average revenue per user
10. SQL `VIEW`
11. Indexes and `EXPLAIN QUERY PLAN`

## Files
- `task3_sql_queries.sql` – complete SQL script
- `ecommerce.db` – SQLite database
- `screenshots/` – output images for the main queries

## How to run
### Option 1: DB Browser for SQLite
1. Open DB Browser for SQLite.
2. Open `ecommerce.db`.
3. Open the **Execute SQL** tab.
4. Run the queries from `task3_sql_queries.sql`.
5. Compare the output with the screenshots.

### Option 2: SQLite command line
```bash
sqlite3 ecommerce.db
.read task3_sql_queries.sql
```

## Key analysis
- Electronics is the highest-revenue product category in this sample.
- Customer-level revenue can be calculated by joining customers, orders and order items.
- The subquery identifies customers whose non-cancelled revenue is above the average customer revenue.
- The `customer_revenue` view provides a reusable analysis layer.
- Indexes are added on common join/filter columns to support query optimization.

## Interview Questions

### 1. WHERE vs HAVING
`WHERE` filters individual rows before grouping. `HAVING` filters groups after `GROUP BY` and is commonly used with aggregate functions.

### 2. Types of joins
Common SQL joins are `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `FULL OUTER JOIN`. SQLite supports `INNER`, `LEFT`, and `CROSS` joins directly; RIGHT/FULL support depends on SQLite version.

### 3. Average revenue per user
Calculate total non-cancelled revenue and divide it by the number of distinct customers:
`SUM(revenue) / COUNT(DISTINCT customer_id)`.

### 4. What are subqueries?
A subquery is a query nested inside another SQL query. It can be used in `WHERE`, `FROM`, or `SELECT`.

### 5. How do you optimize a SQL query?
Select only required columns, filter early, use appropriate joins, add indexes to useful filter/join columns, avoid unnecessary subqueries, inspect the execution plan, and avoid processing unnecessary rows.

### 6. What is a view?
A view is a stored SQL query that behaves like a virtual table. It simplifies repeated analysis and can provide a consistent abstraction over multiple tables.

### 7. Handling NULL values
Use `IS NULL` / `IS NOT NULL` to test for NULL and functions such as `COALESCE()` to replace NULL with a suitable value when appropriate.
