# 📦 Noon Orders SQL Analysis

This project contains SQL-based analysis on a simulated Noon e-commerce orders dataset. It includes table creation and a series of queries to extract meaningful insights about customer behavior, order volumes, product performance, and platform trends.

---

## 🗂️ Project Structure
```
noon-orders-sql-analysis/
│
├── sql/
│   ├── create_noon_orders_table.sql       # DDL script to create table
│   └── noon_orders_analysis.sql           # SQL queries for analysis
│
├── README.md                              # Project overview
```
---

## 🛠️ Tech Stack

- **SQL** (MySQL or PostgreSQL syntax depending on your environment)
- **DB Client**: Use any DB visualization tool like DBeaver, pgAdmin, or MySQL Workbench

---

## 🚀 How to Run

1. Import the `create_noon_orders_table.sql` into your SQL environment to create the schema.
2. Insert your data (or adapt queries to a dataset you have).
3. Run the queries from `noon_orders_analysis.sql` to explore insights.

---

## 📁 Example Use Cases

- E-commerce business intelligence dashboards
- SQL learning & practice project
- Interview prep (joins, aggregates, group by, etc.)
- Portfolio demo

---

## 📊 Key Analysis

The SQL queries provide insights such as:

- Total number of orders
- Orders by city or platform
- Customer behavior trends (e.g. average basket size)
- Top-selling products and categories
- Revenue and order volume over time

---

## SQL Queries
1. Find the top outlet by cuisine type without using limit and top function.
```
(Below can be modified to list top 3 outlets)

with cte as(
select Cuisine, Restaurant_id, count(*) as no_of_orders 
from orders
group by Cuisine, Restaurant_id
)
select * -- normal querying doesnt work so i have to subquery the main query to be able to use "where rn = 1" cuz that show sql works
from (
select *, row_number() over (partition by Cuisine order by no_of_orders desc) as rn
from cte
) as a -- need to put an alias after every subquery
where rn = 1;
```

---

2. How many new customers is Noon acquiring daily since their launch data?
```
(Below can also be solved using row number.)

with cte as (
select Customer_code, cast(min(Placed_at) as date) as first_order_date
from orders
group by Customer_code
)
select first_order_date, count(*) as no_of_new_customers
from cte
group by first_order_date
order by first_order_date
;
```

3. 

