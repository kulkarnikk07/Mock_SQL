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

-- 1070 Product Sales Analysis III 05/05/2024

select product_id, year as 'first_year', quantity, price
from Sales
where (product_id, year) in (
    select product_id, min(year) from Sales group by product_id 
)

-- 1159 Market Analysis II 05/12/2024

with CTE as(
select o.seller_id, o.item_id, i.item_brand, rank() over (partition by o.seller_id order by o.order_date) as 'rnk'
from Orders o
    left join items i
    on i.item_id = o.item_id
    )
, CTE1 as(
    select * from CTE where rnk = 2
)
   
    select u.user_id, if(u.favorite_brand = c.item_brand,'yes','no') as '2nd_item_fav_brand'
    from Users u 
    left join CTE1 c
    on c.seller_id = u.user_id

-- 1194 Tournament Winners 05/12/2024

select group_id, player_id
from (
select p.player_id,p.group_id, rank() over (partition by p.group_id order by sum(
    case 
    when p.player_id = m.first_player then m.first_score
    else m.second_score
    end
) desc, p.player_id asc
    ) as rnk
from Players p
left join Matches m
on p.player_id IN (m.first_player, m.second_player)
group by p.player_id,p.group_id
) t
where rnk =1