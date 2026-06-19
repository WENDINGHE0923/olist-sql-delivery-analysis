-- Q12: What is the average freight value by product category?

select
    N.product_category_name_english,
    count(OI.order_item_id) as item_count,
    round(avg(OI.freight_value), 2) as avg_freight_value,
    round(avg(OI.price), 2) as avg_item_price,
    round(avg(OI.freight_value) * 100.0 / avg(OI.price), 2) as freight_to_price_percent
from orders as O
join order_items as OI
    on O.order_id = OI.order_id
join products as P
    on OI.product_id = P.product_id
join category_name_translation as N
    on p.product_category_name = N.product_category_name
where O.order_status = 'delivered'
  and OI.freight_value is not null
  and OI.price is not null
  and N.product_category_name_english is not null
group by N.product_category_name_english
having count(OI.order_item_id) >= 100
order by avg_freight_value desc;

-- The freight-to-price percentage can be used to identify categories where shipping cost 
-- represents a relatively large share of the item price.

-- Q13: Is freight cost associated with review scores?

with order_freight as (
select  O.order_id,round(sum(OI.freight_value),2) as total_freight
from orders as O
join order_items as OI
on O.order_id =OI.order_id 
where O.order_status ='delivered'
and OI.freight_value is not null
group by O.order_id 
)

select Case when total_freight<10 then 'low freight'
	when total_freight<=30 and total_freight>=10 then 'medium freight'
	else 'high freight'
end as freight_group,
count(distinct OFR.order_id) as orders_count,
round(avg(OFR.total_freight),2) as avg_freight_value,
round(avg(ORR.review_score),2) as avg_review_score
from order_freight as OFR
join order_reviews as ORR
on OFR.order_id = ORR.order_id
where ORR.review_score in (1,2,3,4,5)
group by freight_group
order by avg_freight_value asc

-- lower freight cost was associated with higher average review scores.