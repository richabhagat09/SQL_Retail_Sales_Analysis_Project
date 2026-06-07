-- ----------------------------------------------Retail Sales Anlysis------------------------------------------------------- 
create database project_1_retail_store;
use project_1_retail_store;
 -- ----------------------------------------------Create tables---------------------------------------------------------------
 drop table if exists retail_sales;
 create table retail_sales 
 ( 
 transactions_id int primary key,
 sale_date	date,
 sale_time time,
 customer_id int,
 gender varchar(15),
 age int,
 category varchar(15),
 quantiy int,
 price_per_unit float,
 cogs float,
 total_sale float
 );
select * from retail_sales;

-- ---------------------------------------------Data Cleaning)------------------------------------------------------------------ 

select count(*) from retail_sales;
select transactions_id, count(*)
from retail_sales
group by transactions_id
having count(*)>1;
select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where
     transactions_id is null
     or
     sale_date is null
     or
     sale_time is null
     or
     customer_id is null
     or
     gender is null
     or
     age is null
     or
     category is null
     or
     quantiy is null
     or
     price_per_unit is null
     or
     cogs is null
     or
     total_sale is null;
     
select * from retail_sales;
     
delete from retail_sales
where 
     transactions_id is null
     or
     sale_date is null
     or
     sale_time is null
     or
     customer_id is null
     or
     gender is null
     or
     age is null
     or
     category is null
     or
     quantiy is null
     or
     price_per_unit is null
     or
     cogs is null
     or
     total_sale is null;
     
select count(*) from retail_sales;

-- -------------------------------------------Data EXploration------------------------------------------------------
-- Q1. How many sales we have ?
select count(*) as total_sales from retail_sales;

-- Q2. How many customers we have?
select count(*) as total_customers from retail_sales; 
-- However we want to count our customer and there can be duplicate entries as well, so we will count using customer_id.
select count(customer_id) as total_customers from retail_sales;
-- However in this as well we are just counting customer ids but there can we duplicate records so we use distinct so it will count unique customer ids.
select count(distinct customer_id) as total_customers from retail_sales;

-- Q.3 How many categories do we have?
select count(distinct category) as total_categories from retail_sales;
select distinct category as total_categories from retail_sales;

-- ----------------------------------------------Data Analysis & Business Key Problems & Answers -------------------------------------------  
-- ------------------------------------------------My Analysis and Findings ----------------------------------------------------------------
 
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
select * from retail_sales 
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022.
select * from retail_sales
where category = 'Clothing';

select min(sale_date), max(sale_date) from retail_sales;

select count(*) from retail_sales 
where category = 'Clothing'; -- This gives the sum of all the clothing category rows.

select date_format(sale_date, '%y-%m') from retail_sales
order by 1;-- to check if we have date 2022-11

select count(*) from retail_sales
where
     category = 'Clothing'
     and
     date_format(sale_date, '%y-%m')='2022-11';
     
select category, sum(quantiy) from retail_sales
where category = 'Clothing' group by category; -- This gives the sum of all the quantities together. ( We don't require thhis.)

select * from retail_sales
where category = 'Clothing' and  quantiy>= 4 and date_format(sale_date, '%y-%m')= '2022-11';

-- Q3. Write a SQL query to calculate the **total sales (`total_sale`)** for each category.
select category, sum(total_sale), count(*) as total_orders from retail_sales
group by category;

-- Q4.  Write a SQL query to find the **average age** of customers who purchased items from the **'Beauty'** category.
select category, avg(age) from retail_sales
where category = 'Beauty' 
group by category;

select category, round(avg(age), 2) as rounded_avg_age from retail_sales
where category = 'Beauty'
group by category;

-- Q5. Write a SQL query to find all transactions where the **total_sale is greater than 1000**.
select * from retail_sales 
where total_sale >1000;

select count(*) from retail_sales where total_sale > 1000;

-- Q6. Write a SQL query to find the **total number of transactions (`transaction_id`)** made by each gender in each category.
select category, count(transactions_id)from retail_sales
group by category;

select gender, count(transactions_id) from retail_sales
group by gender;

select category, gender, count(transactions_id) from retail_sales
group by category, gender order by 1;

-- Q7. Write a SQL query to calculate the **average sale for each month**. Find out the **best-selling month in each year**.
select year(sale_date) as year, month(sale_date) as month, sum(total_sale) as total_sale
from retail_sales
group by 1,2; -- to extract year from the sale_date the formula is "year(column_name)" and for "month(column_name)".

select 
    year(sale_date) as year, 
    month(sale_date) as month, 
    round(avg(total_sale), 2) 
as avg_sale 
from retail_sales
group by 1, 2 
order by 1, 3 desc;

-- option 1 
with monthly_avg as (
    select
        year(sale_date) as year,
        month(sale_date) as month,
        round(avg(total_sale), 2) as avg_sale
    from retail_sales
    group by year(sale_date), month(sale_date)
)
select *,
       rank() over(
           partition by year
           order by avg_sale desc
       ) as rank_num
from monthly_avg; -- option 1

-- option 2
select *, -- Select all columns from the temporary table t.
       rank() over(
           partition by year
           order by avg_sale desc
       ) as rank_
from (
    select
        year(sale_date) as year,
        month(sale_date) as month,
        round(avg(total_sale), 2) as avg_sale
    from retail_sales
    group by year(sale_date), month(sale_date)
) t; -- option 2

select
 year,
 month,
 avg_sale
from 
(select *, -- Select all columns from the temporary table t.
       rank() over(
           partition by year
           order by avg_sale desc
       ) as rank_
from (
    select
        year(sale_date) as year,
        month(sale_date) as month,
        round(avg(total_sale), 2) as avg_sale
    from retail_sales
    group by year(sale_date), month(sale_date)
) t
) as t1
where rank_ = 1;

-- Q8. Write a SQL query to find the **top 5 customers** based on the **highest total sales**.
select 
    customer_id,
    sum(total_sale)
from retail_sales
group by 1
order by 2 desc
limit 5;

-- **Q.9** Write a SQL query to find the **number of unique customers** who purchased items from each category.
select 
    count(customer_id) as no_of_customers, 
    category
from retail_sales
group by 2;

-- **Q.10** Write a SQL query to create each **shift** and find the **number of orders** in each shift. ( Example Morning <=12, Afternoon between 12 & 17, Evening > 17)
select * from retail_sales;
select *, 
   case 
     when hour(sale_time) < 12 then 'Morning'
     when hour(sale_time) between 12 and 17 then 'Afternoon'
     else 'Evening'
    end as shift
from retail_sales
order by shift;

select count(transactions_id) as number_of_orders,
   (case 
      when hour(sale_time) < 12 then 'Morning'
      when hour(sale_time) between 12 and 17 then 'Afternoon'
      else 'Evening'
   end) as shift
from retail_sales
group by shift;

-- ----------------------------------------------------------------End Of Project------------------------------------------------------------------
















































































CREATE DATABASE IF NOT EXISTS project_1_retail_store;
 USE project_1_retail_store;     
