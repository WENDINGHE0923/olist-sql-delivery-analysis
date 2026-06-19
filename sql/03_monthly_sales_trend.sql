-- 03_monthly_sales_trend.sql
-- Analyze monthly order volume, product revenue, freight value, and average order value for delivered orders.
-- Product revenue is calculated from item price and does not include freight value.


with monthly_delivered_order as 
(select strftime('%Y-%m', o.order_purchase_timestamp) as order_month, O.order_id,
sum(OI.price) as order_revenue, sum(OI.freight_value) as freight_value
from orders as O
join order_items as OI
on O.order_id =OI.order_id 
where O.order_status ='delivered'
group by O.order_id,order_month 
 )

select order_month,
count(distinct order_id) as total_orders,
round(sum(order_revenue),2) as total_product_revenue,
round(sum(freight_value),2) as total_freight_value,
round(avg(order_revenue),2) as avg_order_value
from monthly_delivered_order
group by order_month
order by order_month

--Monthly order volume and item sales increased significantly after early 2017. 
--The earliest months had very small sample sizes, so their sales patterns should be interpreted carefully. 
--Overall, the platform showed clear growth in delivered order volume and item sales during the main analysis period.