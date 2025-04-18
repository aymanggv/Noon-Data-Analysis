-- Find top outlet by cuisine type without using limit and top function. (Can be modified to list top 3 outlets)
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

-- Find daily new customer count from launch date. (How many new customers are we acquiring daily?) Below can also be solved using row number.
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


-- Count of all users who were acquired in Jan 2025 and only placed 1 order in Jan and did not place any other order. (My solution is diff from video. Check below to see his version)
WITH cte AS (
  SELECT Customer_code, MIN(Placed_at) AS first_order_date, MAX(Placed_at) as last_order_date, count(*) as count_of_orders
  FROM orders
  GROUP BY Customer_code
)
SELECT *
FROM cte
WHERE DATE(first_order_date) LIKE '2025-01%' and DATE(last_order_date) like '2025-01%' and count_of_orders < 2
order by Customer_code
;

/*select Customer_code, count(*) as no_of_orders
from orders
where MONTH(placed_at)=1 and YEAR (placed_at)=2025
and Customer_code not in (select distinct Customer_code
from orders
where not (MONTH(placed_at)=1 and YEAR (placed_at)=2025)
 )
group by Customer_code
having COUNT(*)=1
order by Customer_code
;*/

-- List All the customers with no order in the last 7 days but were acquired one month ago with their first order on promo.
 
 with cte as
 (SELECT Customer_code, MIN(Placed_at) AS first_order_date, MAX(Placed_at) as last_order_date
  FROM orders
  GROUP BY Customer_code
)
select cte.*, orders.Promo_code_Name as first_order_promo 
from cte
inner join orders
on cte.first_order_date = orders.Placed_at
where Promo_code_Name is not null AND last_order_date < (current_date() - INTERVAL 14 DAY) AND first_order_date < (current_date() - INTERVAL 45 DAY)
;


-- Growth team is plnning to create a trigger that will target customers after their every 3rd order with a personalized message. Create a query to find those customers
with cte as (select Customer_code, order_id, row_number() over (partition by Customer_code order by order_id) as rn
from orders
group by Customer_code, order_id
order by order_id)
select * from cte
where rn % 3 = 0 -- add an "and current date = today" code as well so that the team only sees only recent ordes and not old orders.
;


-- List customers who placed more than 1 order and all their orders on a promo only
select Customer_code, count(*) as no_of_orders, count(Promo_code_Name) as promo_code_orders
from orders
group by Customer_code
having no_of_orders > 1 and no_of_orders = promo_code_orders
;

-- What percent of customers were organically acquired in Jan 2025? (Placed first order without promo code) Another solution provided below
with cte as (SELECT Customer_code, MIN(Placed_at) AS first_order_date
FROM orders
where Month(Placed_at) = 1
group by Customer_code
)
select count(case when Promo_code_Name is null then orders.Customer_code end) / count(distinct orders.Customer_code) * 100.0
from cte
inner join orders 
on cte.first_order_date = orders.Placed_at
;

/*with cte as (
select *, ROW_NUMBER() over (partition by customer_code order by placed_at) as rn
from orders
where MONTH (placed_at)=1
)
select count(case when rn=1 and Promo_code_Name is null then Customer_code end)
*100/ COUNT(distinct Customer_code)
from cte*/

