--Q7: What is the distribution of review scores?

with total_review as 
(select count(order_id) as total_review_num
from order_reviews 
where review_score in (1,2,3,4,5)
)

select O1.review_score,count(O1.order_id) as review_count, 
round(count(O1.order_id)*100.0/T.total_review_num,2) as review_percentage
from order_reviews as O1
cross join total_review as T
where O1.review_score in (1,2,3,4,5)
group by O1.review_score ;

-- Result:
-- Customer reviews were generally positive.
-- Review score 5 accounted for 57.69% of valid reviews, followed by score 4 at 19.35%.
-- However, score 1 accounted for 11.55%, indicating that a meaningful share of customers had very negative experiences.

-- Q8: What is the average delivery time by review score?
select
    R.review_score,
    count(distinct O.order_id) as order_count,
    round(avg(julianday(O.order_delivered_customer_date)- julianday(O.order_purchase_timestamp)),2) as avg_delivery_days
from orders as O
join order_reviews as R
    on O.order_id = R.order_id
where O.order_status = 'delivered'
  and O.order_purchase_timestamp is not null
  and O.order_delivered_customer_date is not null
  and R.review_score in (1, 2, 3, 4, 5)
group by R.review_score
order by R.review_score;


-- Result:
-- Lower review scores were associated with longer average delivery times.
-- Slower delivery may be related to lower customer satisfaction.

-- Q9: Does late delivery affect customer review scores?
select
    case when o.order_delivered_customer_date > o.order_estimated_delivery_date then 'Late'
        else 'On time'
    end as delivery_status,
    count(distinct O.order_id) as reviewed_orders,
    round(avg(R.review_score), 2) as avg_review_score
from orders as O
join order_reviews as R
    on O.order_id = R.order_id
where O.order_status = 'delivered'
  and O.order_delivered_customer_date is not null
  and O.order_estimated_delivery_date is not null
  and O.order_purchase_timestamp is not null
  and R.review_score in (1, 2, 3, 4, 5)
group by delivery_status
order by avg_review_score;

--Late delivery appears to have a strong negative impact on customer satisfaction.
--Late orders had an average review score of 2.56, compared with 4.29 for on-time orders.