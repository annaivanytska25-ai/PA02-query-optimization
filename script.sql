-- Practice Assignment 2

-- Non-optimized query
explain analyze
select
	c.name || ' ' || c.surname as top_client,
	count(*) as total_orders_category2
from opt_orders o
join opt_clients c on o.client_id = c.id
join opt_products p on o.product_id = p.product_id
where o.order_date >= date '2022-10-08' and c.status = 'active'
	and p.product_category = 'Category2'
group by c.name, c.surname
order by total_orders_category2 desc
limit 10;


-- Optimized query
explain analyze
with filtered_orders as (
	select
		o.client_id,
		o.product_id
	from opt_orders o
	where o.order_date >= date '2022-10-08'
),
active_clients as (
	select id
	from opt_clients
	where status = 'active'
),
category2_products as (
select product_id
from opt_products
where product_category = 'Category2'
)
select
	c.name || ' ' || c.surname as top_clients,
	count(*) as total_orders_category2
from filtered_orders fo
join active_clients ac on fo.client_id = ac.id
join category2_products cp on fo.product_id = cp.product_id
join opt_clients c on fo.client_id = c.id
group by c.name, c.surname
order by total_orders_category2 desc
limit 10;


-- Indexes

create index idx_opt_orders_order_date
on opt_orders(order_date);

create index idx_opt_orders_client_id
on opt_orders(client_id);

create index idx_opt_orders_product_id
on opt_orders(product_id);

create index idx_opt_clients_status
on opt_clients(status);

create index idx_opt_products_category
on opt_products(product_category);
