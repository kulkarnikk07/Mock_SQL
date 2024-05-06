-- 1407. Top Travellers 04/28/2024
select u.name, ifnull(sum(r.distance),0) as travelled_distance
from users u
left join rides r
on u.id = r.user_id
group by u.id, 
order by  sum(r.distance) desc, name asc


-- 1445. Apples & Oranges 04/28/2024
WITH CTE AS (
  SELECT sale_date, sold_num    
  FROM sales
  WHERE fruit = 'apples'
  ORDER BY sale_date
),
CTE1 AS (
  SELECT sale_date, sold_num    
  FROM sales
  WHERE fruit = 'oranges'
  ORDER BY sale_date
)

SELECT CTE.sale_date,CTE.sold_num - CTE1.sold_num diff 
    FROM CTE 
    left join CTE1
    on CTE.sale_date = CTE1.sale_date
    order by CTE.sale_date;


-- 1045. Customers Who Bought All Products 05/05/2024

select customer_id
from customer
group by customer_id
having count(distinct product_key) = (select count(*) from product)

-- Product Sales Analysis III 05/05/2024

select product_id, year as 'first_year', quantity, price
from Sales
where (product_id, year) in (
    select product_id, min(year) from Sales group by product_id 
)