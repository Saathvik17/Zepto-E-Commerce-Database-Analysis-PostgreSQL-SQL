
create table zepto(
sku_id serial primary key,
category varchar(120),
name varchar(150),
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);
-- data exploration
select count(*) from zepto;

-- null
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- different products categoreis

select distinct category from zepto
order by category ;

-- products in stock vs outofstock

select outOfStock,count(sku_id)
from zepto
group by outOfStock;

-- multiple name sin product
select name,count(sku_id)
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;


--- data cleaning

--- products with price 0

select * from zepto
where mrp =0 or discountedSellingPrice=0;
-- deleye data

delete from zepto
where mrp=0;

--change the mrp paise to rupee
update zepto
set mrp = mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

-- top10 productrs based on discountpercnetage

select distinct name,mrp,discountPercent 
from zepto
order by discountPercent desc
limit 10;

--what are products with high mrp but out of stock
select distinct name,mrp,outOfStock
from zepto
where outOfStock = TRUE
order by mrp desc
limit 5;

-- cal est revenue for each category

select distinct category,
sum(discountedSellingPrice * availableQuantity ) as total_rev
from zepto
group by category
order by total_rev

--find producrts where mrp is great than 500 but discount is less than 10%

select distinct name,mrp,discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp;

--identify top 5 category offering highest avg discount percentage

select category,
avg(discountPercent) as avg_discountPercent
from zepto
group by category
order by avg_discountPercent desc
limit 5;

-- find the price per gram for products above 100g and sort by best value

select distinct name,weightInGms,discountedSellingPrice,
discountedSellingPrice/weightInGms as price_per_gram
from zepto
where weightInGms>100
order by price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;


--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
