USE  foodie_fi;
SELECT * FROM PLANS_CSV;
select * from subscription_CSV;


/*Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.
Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!*/

SELECT subscription_CSV.customer_id,plans_CSV.plan_name,subscription_CSV.start_date
from subscription_CSV
join plans_CSV on subscription_CSV.plan_id = plans_CSV.plan_id;

/*1.How many customers has Foodie-Fi ever had?*/

select count(distinct customer_id) as number_of_customers
from subscription_CSV;

/*2.What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value*/

select month(start_date) as months,count(customer_id) as count_of_customer from subscription_CSV group by months order by months;

/*3.What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name*/

select plans_csv.plan_id,plans_csv.plan_name,count(*) as count_of_events from subscription_csv join plans_csv on plans_csv.plan_id = subscription_csv.plan_id where year(subscription_csv.start_date) > '2020'group by plans_csv.plan_id, plans_csv.plan_name order by plans_csv.plan_id;

/*4.What is the customer count and percentage of customers who have churned rounded to 1 decimal place?*/

select count(*) as count_of_churned, round(count(*)*100/(select count(distinct customer_id)from subscription_csv),1) as percentage_of_churned from subscription_csv where plan_id=4;

/*5.How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?*/

with temp_churn as (select * , lag(plan_id,1) over (partition by customer_id order by plan_id) as Previous_plan from subscription_csv)
select count(Previous_plan) AS count_churn , round(count(*)*100/(select count(distinct customer_id) from subscription_csv) ,0) as percentage_churn from temp_churn
where plan_id =4 and previous_plan = 0;

/*6.What is the number and percentage of customer plans after their initial free trial?*/

with temp_plan as (select * , lead(plan_id,1) over (partition by customer_id order by plan_id) as next_plan from subscription_csv)
select next_plan, count(*) AS count_customers , round(count(*)*100/(select count(distinct customer_id) from subscription_csv) ,1) as percentage_next_plan from temp_plan
where next_plan is not null and plan_id =0 group by next_plan order by next_plan;

/*7.What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?*/


/*8.How many customers have upgraded to an annual plan in 2020?*/

select count(customer_id) as Count_Of_Customer from subscription_csv where plan_id = 3 and year(Start_date) <= '2020';

/*9.How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?*/

with  annual_plan as(select customer_id, start_date as annual_date from subscription_csv where plan_id=3) ,trail_plan as ( select customer_id, start_date as trail_date from subscription_csv where plan_id = 0)
select round(avg(datediff (annual_date,trail_date)),0) as Average_upgrade from annual_plan join trail_plan on annual_plan.customer_id = trail_plan.customer_id;

/*10.Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)*/

with  annual_plan as(select customer_id, start_date as annual_date from subscription_csv where plan_id=3) ,trail_plan as ( select customer_id, start_date as trail_date from subscription_csv where plan_id = 0),
date_diff as(select datediff (annual_date,trail_date) as diff from trail_plan  left join annual_plan  on trail_plan.customer_id = annual_plan.customer_id where annual_date is not null),
bins as (select *, floor(diff/30) as bins from date_diff) select concat((bins * 30) +1,'-',(bins + 1)*30, 'days') as days, count(diff) as total from bins group by bins order by bins;

/*11.How many customers downgraded from a pro monthly to a basic monthly plan in 2020?*/

with lead_cte as(select customer_id, plan_id,start_date,lead(plan_id,1) over( partition by customer_id order by plan_id) as next_plan from subscription_csv)
select count(*) as downgrade from lead_cte where year(start_date) <= '2020' and plan_id =2 and next_plan =1;