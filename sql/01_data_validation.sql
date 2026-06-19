-- 01_data_validation.sql
-- Purpose: Check whether all key tables were imported successfully
-- and validate important fields used in the analysis.

------------------------------------------------------------
-- 1. Check row counts for all imported tables
------------------------------------------------------------

select 'orders' as table_name, count(*) as row_count from orders
union all
select 'customers', count(*) from customers
union all
select 'order_items', count(*) from order_items
union all
select 'order_reviews', count(*) from order_reviews
union all
select 'products', count(*) from products
union all
select 'category_name_translation', count(*) from category_name_translation;


------------------------------------------------------------
-- 2. Check order status distribution
------------------------------------------------------------

select
    order_status,
    count(*) as order_count
from orders
group by order_status
order by order_count desc;


------------------------------------------------------------
-- 3. Count delivered orders used in the main analysis
------------------------------------------------------------

select
    count(*) as delivered_order_count
from orders
where order_status = 'delivered';


------------------------------------------------------------
-- 4. Check review score distribution and possible invalid values
------------------------------------------------------------

select
    review_score,
    count(*) as review_count
from order_reviews
group by review_score
order by review_score;


------------------------------------------------------------
-- 5. Count invalid review scores
------------------------------------------------------------

select
    count(*) as invalid_review_score_count
from order_reviews
where review_score not in (1, 2, 3, 4, 5)
   or review_score is null;