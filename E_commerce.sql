-- KPI 1 Weekday vs Weekend payment statsitics
SELECT
    SUM(CASE WHEN day IN ('Saturday', 'Sunday') THEN payment_value ELSE 0 END) AS weekend_payment,
    SUM(CASE WHEN day NOT IN ('Saturday', 'Sunday') THEN payment_value ELSE 0 END) AS weekday_payment,
    SUM(CASE WHEN day IN ('Saturday', 'Sunday') THEN payment_installments ELSE 0 END) AS weekend_payment_installments,
    SUM(CASE WHEN day NOT IN ('Saturday', 'Sunday') THEN payment_installments ELSE 0 END) AS weekday_payment_installments

 from olist_orders_dataset ord join olist_order_payments_dataset py
on (ord.order_id = py.order_id);
    
-- KPI 2 Number of orders with review score 5 & payment type as creit_card**
select count(order_id) as Total_orders, review_score, payment_type
from olist_order_payments_dataset inner join olist_order_reviews_dataset
using (order_id)
where review_score = 5 and payment_type = "credit_card";

-- KPI 3: Average number of days taken for order_delivered_customer_date for pet_shop
select avg(order_delivered_customer_date) as "Avg days taken",(select product_category_name 
from olist_products_dataset where product_category_name = "Pet_shop" group by product_category_name) as "Product category name"
from olist_orders_dataset join olist_order_items_dataset using (order_id)
join olist_products_dataset using (product_id);

-- KPI 4: Average price and payment value from customers of Sao Paulo city
select avg(price), avg(payment_value), (select customer_city 
from olist_customers_dataset 
where customer_city ="sao paulo"group by customer_city)
from olist_order_items_dataset left join  olist_order_payments_dataset using (order_id)
left join olist_orders_dataset using (order_id)
left join olist_customers_dataset using (customer_id);

-- KPI 5: Relationship between Shipping days vs Review score
select  abs(order_delivered_customer_date-order_purchase_timestamp) as Shipping_days, order_purchase_timestamp, order_delivered_customer_date, review_score
from olist_orders_dataset inner join olist_order_reviews_dataset using (order_id)
order by Shipping_days desc;
