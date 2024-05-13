SELECT o.order_date,
	ct.category_name,
	p.product_name,
	p.product_price,
	o.order_qty,
	p.product_price * o.order_qty AS total_sales,
	cs.email,
	cs.city
FROM orders o
JOIN customers cs ON cs.cust_id = o.cust_id
JOIN products p ON p.product_id = o.product_id
JOIN category ct ON ct.product_cat = p.product_cat
ORDER BY o.order_date ASC