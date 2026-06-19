-- 02_business_overview.sql
-- Overall business performance of the e-commerce platform.

with delivered_order as (
select O.order_id,O.customer_id,sum(OI.price) as order_revenue,sum(OI.freight_value ) as freight_value 
from orders as O
join order_items as OI
on O.order_id = OI.order_id 
where order_status = 'delivered'
group by O.order_id,O.customer_id 
)

SELECT 
count (distinct order_id) as order_count, 
count (distinct customer_id) as customer_count,
round(SUM(order_revenue),2) as total_revenue,
round(sum(freight_value),2) as total_freight_value,
round(avg(order_revenue),2) as avg_order_revenue
from delivered_order;