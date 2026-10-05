# Data Dictionary

| Table | Column | Description |
|---|---|---|
| customers | customer_id | Unique customer ID |
| customers | customer_name | Customer name |
| customers | email | Customer email |
| customers | city | Customer city |
| customers | signup_date | Signup date |
| products | product_id | Unique product ID |
| products | product_name | Product name |
| products | category | Product category |
| products | price | Current product price |
| orders | order_id | Unique order ID |
| orders | customer_id | Customer who placed the order |
| orders | order_date | Date of order |
| orders | status | Order status |
| order_items | order_item_id | Unique order-line ID |
| order_items | order_id | Related order |
| order_items | product_id | Related product |
| order_items | quantity | Quantity purchased |
| order_items | unit_price | Price paid per unit |
