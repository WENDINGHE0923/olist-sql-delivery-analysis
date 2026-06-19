-- Q4: What is the average delivery time for delivered orders?
-- Calculate the average number of days between order purchase and customer delivery.

With deliver_time_per_order as (
select O.order_id, julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) as deliver_days
from orders as O
where O.order_status ='delivered'
and O.order_purchase_timestamp is not null
and O.order_estimated_delivery_date is not null
group by O.order_id 
)

select round(avg(deliver_days),2) as avg_delivery_days
from deliver_time_per_order 
;

-- The average delivery time for delivered orders is 12.56 days.

-- Q5: What percentage of delivered orders were delivered late?
-- This query calculates the late delivery rate for delivered orders.
-- An order is considered late if the actual customer delivery date is later than the estimated delivery date.

with late_delivery as (
select order_id as late_order 
from orders as O
where O.order_delivered_customer_date >O.order_estimated_delivery_date 
and O.order_status ='delivered'
and O.order_purchase_timestamp is not null
and O.order_delivered_customer_date is not null
and O.order_estimated_delivery_date is not null
group by O.order_id 
)

select count(O.order_id) as order_delivered_orders,count(L.late_order) as late_orders,
round(count(L.late_order)*100.0/count(O.order_id),2) as late_rate_percent from orders as O
left join late_delivery as L
on O.order_id = L.late_order
where O.order_status ='delivered'
and O.order_purchase_timestamp is not null
and O.order_delivered_customer_date is not null
and O.order_estimated_delivery_date is not null
;


--Among 96,478 delivered orders, 7,826 were delivered later than the estimated delivery date. 
--The late delivery rate was 8.11%.

-- Q6: How did the average delivery time change over time?

select strftime('%Y-%m', order_purchase_timestamp) as order_month, 
count(order_id) AS delivered_orders,
round(AVG(julianday(order_delivered_customer_date)- julianday(order_purchase_timestamp)),2) as avg_delivery_days
from orders as O
where O.order_delivered_customer_date is not null
and O.order_purchase_timestamp is not null
and O.order_status ='delivered'
group by order_month
order by order_month;

--Monthly delivery time varied over time. Early months had small sample sizes,
--while delivery time was higher in late 2017 / early 2018 and improved by mid-to-late 2018.

