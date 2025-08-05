drop table if exists zepto;

create table zepto(
sku_id serial primary key,
Category varchar(145),
name varchar(140) not null,
mrp numeric(8,2),
distcountPercent numeric(8,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStack boolean,
quantity integer
);

select * from zepto;

---DATA EXPLORATION
--- COUNT OF ROWS 
SELECT COUNT(*) FROM zepto;

--sample data showing of first 10 rows

select * from zepto
limit 10;

-- is there any null values?
select * from zepto 
where name is Null
or
category is null
or
mrp is Null
or
distcountpercent is Null
or
availablequantity is Null
or
discountedsellingprice is Null
or
weightingms is null
or
outofstack is null
or
quantity is null;

-- different categories
select distinct category from zepto
order by  category;

--products in stock vs out of stock
select outofStack, count(sku_id) from zepto
group by outofstack;
--here 3279 is in stock and 453 is out of stock

--product names present multiple times
select name, count(sku_id) as "number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) DESC;

----data cleaning

--product price might be zero
select * from zepto
where mrp = 0 or discountedsellingprice = 0;
-- we deleted where mrp = 0 because mrp can't be zero
delete from zepto 
where mrp = 0;

--convert paise to rupees
update Zepto
set mrp = mrp/100.0,discountedsellingprice = discountedsellingprice/100.0;

--lets check it is change or not
select mrp,discountedsellingprice from zepto;

----Find the top 10 best-value products based on the discount percentage?

select distinct name,mrp,distcountpercent
from zepto
order by distcountpercent desc
limit 10;
---What are the Products with High MRP but Out of Stock?

select distinct name, mrp
from zepto
where outofstack =  True and mrp > 300
order by mrp desc;

--Q3. Calculate Estimated Revenue for each category. 

select category, sum(discountedsellingprice * availablequantity) as total_revenue
from zepto
group by category
order  by total_revenue;

--Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%. 

select distinct name,mrp,distcountpercent 
from zepto 
where mrp > 500 and distcountpercent < 10
order by mrp desc, distcountpercent desc;

--Q5. Identify the top 5 categories offering the highest average discount percentage.

select category , round(avg(distcountpercent),2) as avg_dis
from zepto
group by category
order by avg_dis Desc
limit 5;

--Q6. Find the price per gram for products above 100g and sort by best value. 

select distinct name, weightingms,discountedsellingprice,
round(discountedsellingprice/weightingms,3) as price_per_gram
from zepto
where weightingms >= 100
order by price_per_gram;

--Q7. Group the products into categories like Low, Medium, Bulk. 

select distinct name, weightingms,
case when weightingms < 1000 then 'low'
     when weightingms < 5000 then 'medium'
	 else 'bulk'
	 end as weight_category
from zepto;

--Q8. What is the Total Inventory Weight Per Category? 

select category , sum(weightingms * availablequantity) as total_weight
from zepto
group by category
order by total_weight;