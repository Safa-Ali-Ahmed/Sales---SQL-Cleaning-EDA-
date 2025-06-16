use BikeStores
-------------display all the tables---------------------------------------------------------------------------------
select * from production.brands
select * from production.categories
select * from production.products
select * from production.stocks
select * from sales.customers
select * from sales.order_items
select * from sales.orders
select * from sales.staffs
select * from sales.stores
--check duplicates--------------------------------------------------------------------------------------------------
--------production.stocks--------------
select store_id ,count(*)
from production.stocks
group by store_id 
having count(*)>1 
--------production.products-------------
select product_id ,count(*)
from production.products
group by product_id 
having count(*)>1 
--------sales.customers-----------------
select customer_id,count(*)
from sales.customers
group by customer_id 
having count(*)>1 
--------sales.orders--------------------
select order_id,customer_id,count(*)
from sales.orders 
group by order_id,customer_id
having  count(*)>1 
--------sales.order_items---------------
select order_id,item_id,count(*)
from sales.order_items
group by order_id,item_id
having count(*)>1 
---------------------------------------Data Cleaning Process-------------------------------------------------------------------------------------
--------------standarize data--------------------------------------------------------------
--------production.products-------------
select distinct product_name
from production.products
order by 1

update production.products
set product_name=TRIM(product_name)

update production.products
set product_name=TRIM(trailing '.' from product_name)
--------sales.customers-----------------
select distinct city
from sales.customers
order by 1

select distinct state
from sales.customers
order by 1

select distinct street
from sales.customers
order by 1
-------------------check nulls--------------------------------------
--------sales.customers-----------------
select * 
from sales.customers
where phone is null

alter table sales.customers drop column phone

select * 
from sales.customers
--------sales.orders-----------------
select * 
from sales.orders
where shipped_date is null
--------sales.staffs-----------------
select * 
from sales.staffs
where manager_id is null

select * 
from sales.staffs
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------Answer Questions--------------------------------------------------------------------------------
--1) Which bike is most expensive? What could be the motive behind pricing this bike at the high price? 
select top (1) *
from production.products 
order by list_price desc

select * from production.brands
select * from production.categories
select * from production.products
--the high price maybe because the brand name and model year
--2) How many total customers does BikeStore have? 
select count(distinct customer_id)
from sales.customers
--Would you consider people with order status 3 as customers substantiate your answer?
--if we not consider status 3 and count the rest then the total is/only depend on your case
select count(c.customer_id) as #cutomers
from sales.customers c inner join sales.orders o
on c.customer_id=o.customer_id
where o.order_status != 3
--3) How many stores does BikeStore have? 
select count(distinct store_id) as #stores
from sales.stores
--4) What is the total price spent per order? Hint: total price = [list_price] *[quantity]*(1-[discount])
select o.order_id ,sum(i.list_price*i.quantity*(1-i.discount)) as total_price
from sales.orders o join sales.order_items i
on o.order_id=i.order_id
group by  o.order_id 
--5) What’s the sales/revenue per store? Hint: Sales revenue = ([list_price] *[quantity]*(1-[discount]))
select s.store_id ,sum(i.list_price*i.quantity*(1-i.discount)) as total_price
from sales.stores s join sales.order_items i
on s.store_id=i.order_id
group by  s.store_id 
--6)  Which category is most sold? 
select top (1) c.category_name,
count(p.category_id) times_category_sold,
sum(p.list_price) #sales
from production.categories c 
join production.products p on c.category_id=p.category_id
join sales.order_items i on p.product_id = i.product_id
join  sales.orders o on i.order_id=o.order_id
where o.order_status=4
group by c.category_name
order by times_category_sold desc 
--7) Which category rejected more orders?
select  top(1) c.category_name,
count(p.category_id) times_category_rejected,
sum(p.list_price) #sales
from production.categories c 
join production.products p on c.category_id=p.category_id
join sales.order_items i on p.product_id = i.product_id
join  sales.orders o on i.order_id=o.order_id
where o.order_status=3
group by c.category_name
order by times_category_rejected desc
--8) Which bike is the least sold?
select  top(2) p.product_name,
count(p.product_id) times_product_sold,
sum(p.list_price) #sales
from production.products p 
join sales.order_items i on p.product_id=i.product_id
join sales.orders o on i.order_id=o.order_id
where o.order_status=4 
group by p.product_name
having count(p.product_id)=1
order by #sales
--9) What’s the full name of a customer with ID 259? 
select first_name + ' ' + last_name full_name
from sales.customers
where customer_id=259
--10) What did the customer on question 9 buy and when?What’s the status of this order? 
select c.first_name + ' ' + c.last_name full_name,i.quantity,o.order_date,o.shipped_date,o.order_status,p.product_name
from sales.customers c
join sales.orders o on c.customer_id=o.customer_id
join sales.order_items i on o.order_id=i.order_id
join production.products p on i.product_id=p.product_id
where c.customer_id = 259
--11) Which staff processed the order of customer 259?And from which store?
select f.*,o.customer_id,s.store_name
from sales.orders o 
join sales.staffs f on o.staff_id=f.staff_id
join sales.stores s on f.store_id=s.store_id
where o.customer_id=259 
--12) How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore? 
select count(distinct f.staff_id) #staff
from sales.staffs f

select *
from sales.staffs f
where manager_id is null
--13) Which brand is the most liked?
select top(1) b.brand_name , count(b.brand_id) times_brand_sold , sum(i.quantity) #quantities
from production.brands b
join production.products p on b.brand_id=p.brand_id
join sales.order_items i on p.product_id=i.product_id
join sales.orders o on i.order_id=o.order_id
group by b.brand_name
order by times_brand_sold desc
--14) How many categories does BikeStore have, and which one is the least liked? 
select count(distinct c.category_id) #catagories
from production.categories c

select top(1) c.category_name,count(i.quantity) #num_quantities
from production.categories c
join production.products p on c.category_id=p.category_id
join sales.order_items i on p.product_id=i.product_id
group by c.category_name,i.quantity
order by #num_quantities 
--15)  Which store still have more products of the most liked brand? 
select  top(1) st.store_id,s.store_name,sum(st.quantity) #quantities
from production.stocks st
join production.products p on st.product_id=p.product_id
join production.brands b on p.brand_id=b.brand_id
join sales.stores s on st.store_id=s.store_id
where b.brand_name='Electra'
group by st.store_id,s.store_name
order by #quantities desc
--16) Which state is doing better in terms of sales? 
select top(1) c.state,sum(i.list_price) #sales
from sales.customers c
join sales.orders o on c.customer_id=o.customer_id
join sales.order_items i on o.order_id=i.order_id
where o.order_status=4
group by c.state
order by #sales desc
--17) What’s the discounted price of product id 259? 
select i.product_id,i.discount
from sales.order_items i
where i.product_id=259

select i.product_id,sum(i.discount) #discount
from sales.order_items i
where i.product_id=259
group by  i.product_id
--18)  What’s the product name, quantity, price, category, model year and brand name of product number 44? 
select p.product_name,p.list_price,p.model_year,b.brand_name,c.category_name,sum(i.quantity) #quantities
from production.products p 
join sales.order_items i  on p.product_id=i.product_id
join production.brands b on p.brand_id=b.brand_id
join production.categories c on p.category_id=c.category_id
where p.product_id=44
group by p.product_name,p.list_price,p.model_year,b.brand_name,c.category_name
--19) What’s the zip code of CA? 
select c.zip_code
from sales.customers c 
where c.state='CA'
group by c.zip_code
--20) How many states does BikeStore operate in? 
select count(distinct c.state) #states
from sales.customers c
--21) How many bikes under the children category were sold in the last 8 months?
select min(o.order_date) starting_date,max(o.order_date) last_date,DATEADD(MONTH,-8,MAX(o.order_date)) 
from sales.orders o

select c.category_name,count(p.product_id) #bikes
from production.products p
join production.categories c on p.category_id=c.category_id
join sales.order_items i on  p.product_id=i.product_id
join sales.orders o on i.order_id=o.order_id
where c.category_name like'children%' 
and o.order_status=4 
and o.order_date>='2018-04-28'
group by c.category_name
--22) What’s the shipped date for the order from customer 523 
select o.shipped_date ,c.customer_id
from sales.orders o
join sales.customers c on o.customer_id=c.customer_id
where c.customer_id=523
--23) How many orders are still pending? 
select count(o.order_id) #orders
from sales.orders o
where o.order_status=1
--24) What’s the names of category and brand does "Electra white water 3i - 2018" fall under? 
select c.category_name,b.brand_name
from production.products p
join production.categories c on p.category_id=c.category_id
join production.brands b on p.brand_id=b.brand_id
where p.product_name='Electra white water 3i - 2018'
