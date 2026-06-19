-- Q10: Which product categories generated the highest sales?
with category_sales as (
select N.product_category_name_english, 
count(distinct O.order_id) as order_count,
count(OI.order_item_id) as item_count,
round(sum(OI.price),2) as total_sales
from category_name_translation as N
join products as P
on N.product_category_name = P.product_category_name 
JOIN order_items as OI 
on P.product_id =OI.product_id 
join orders as O
on OI.order_id =O.order_id 
where O.order_status ='delivered'
group by N.product_category_name_english
order by total_sales desc
)

select *, round(total_sales/item_count,2)  as avg_item_price
from category_sales
order by total_sales desc
;
-- The highest-sales product categories were health_beauty, watches_gifts, bed_bath_table, sports_leisure, and computers_accessories.


-- Q11: Which product categories had the best average review scores?

with category_orders as (
select distinct N.product_category_name_english, 
O.order_id 
from category_name_translation as N
join products as P
on N.product_category_name = P.product_category_name 
JOIN order_items as OI 
on P.product_id =OI.product_id 
join orders as O
on OI.order_id =O.order_id 
where O.order_status ='delivered'
)

select CO.product_category_name_english,
count(distinct CO.order_id) as order_count,
round(avg(ORR.review_score),2) as avg_review_score
from category_orders as CO
join order_reviews as ORR
on CO.order_id = ORR.order_id 
where ORR.review_score IN (1, 2, 3, 4, 5)
group by CO.product_category_name_english
having count(distinct CO.order_id)>=100
order by avg_review_score desc

-- After excluding categories with fewer than 100 reviewed orders, the highest-rated categories had average review scores above 4.