use Sprints

--growth volume table grouped by dates for only Sprint scooters--
with cte as(
  --using the common table expression--
  select 
    CONVERT(
      date, sales_transaction_date, 101
    ) as sales_date, 
    --creating a column for only dates extracted from the sales transaction date column--
    COUNT(customer_id) as num_of_sales, 
    --counting the no:of customer_id to get total sales of each day--
    sum (
      COUNT(customer_id)
    ) over (
      order by 
        CONVERT(
          date, sales_transaction_date, 101
        ) rows unbounded preceding
    ) cumul_sales, 
    --using the sum function with over to get the running totals in a column, cumul_sales--
    sum(
      COUNT(customer_id)
    ) over (
      order by 
        CONVERT(
          date, sales_transaction_date, 101
        ) rows between 6 preceding 
        and current row
    ) as current_period_sales, 
    --using gain the sum and over functions for 7 day period sales which will give the cumulative sum of the last 7 days from any given days--
    row_number() over(
      order by 
        CONVERT(
          date, sales_transaction_date, 101
        )
    ) as rn1 --using the row number to assign each row with a unique value like 1,2,3,..--
  from 
    dbo.sales 
  where 
    product_id = 7  --calculating for only the Sprint scooters--
	and CONVERT(
      date, sales_transaction_date, 101
    ) >='2016-10-10'
	and CONVERT(          --limiting the results for the first 3 weeks from launch--
      date, sales_transaction_date, 101
    ) <='2016-10-31'
  group by 
    --grouping the data by sales date to get the total sales--
    CONVERT(
      date, sales_transaction_date, 101
    )
) --end of the CTE and starting the auto query in the next line--
select 
  t1.sales_date, 
  t1.num_of_sales, 
  t1.cumul_sales, 
  t1.current_period_sales, 
  round(
    coalesce(
      (
        t1.current_period_sales - t2.current_period_sales
      )* 1.0 --the 1.0 is to avoid integer division--
      / t2.current_period_sales, 
      0
    )* 100, 2) as growth_percent --this is the formula for the growth percentage, coalesce is to change the first value of the row to 0 from Null--
 --and the round function will round up the result upto 2 decimal places--
from 
  cte as t1 --aliasing the cte as t1--
  left join cte as t2 on t1.rn1 = t2.rn1 + 1;
--doing a left join to the cte aliased as t2 with rn1 as primary key, the'+1' will offset the rows so that they can join correctly--


--growth volume table grouped by dates for only Sprint Limited Edition scooters--
with cte as(
  --using the common table expression--
  select 
    CONVERT(
      date, sales_transaction_date, 101
    ) as sales_date, 
    --creating a column for only dates extracted from the sales transaction date column--
    COUNT(customer_id) as num_of_sales, 
    --counting the no:of customer_id to get total sales of each day--
    sum (
      COUNT(customer_id)
    ) over (
      order by 
        CONVERT(
          date, sales_transaction_date, 101
        ) rows unbounded preceding
    ) cumul_sales, 
    --using the sum function with over to get the running totals in a column, cumul_sales--
    sum(
      COUNT(customer_id)
    ) over (
      order by 
        CONVERT(
          date, sales_transaction_date, 101
        ) rows between 6 preceding 
        and current row
    ) as current_period_sales, 
    --using gain the sum and over functions for 7 day period sales which will give the cumulative sum of the last 7 days from any given days--
    row_number() over(
      order by 
        CONVERT(
          date, sales_transaction_date, 101
        )
    ) as rn1 --using the row number to assign each row with a unique value like 1,2,3,..--
  from 
    dbo.sales 
  where 
    product_id = 8 
	and CONVERT(
      date, sales_transaction_date, 101
    ) >='2017-02-15'
	and CONVERT(          --limiting the results for the first 3 weeks from launch--
      date, sales_transaction_date, 101
    ) <='2017-03-08'--calculating for only the Sprint Limited Edition scooters--
  group by 
    --grouping the data by sales date to get the total sales--
    CONVERT(
      date, sales_transaction_date, 101
    )
) --end of the CTE and starting the auto query in the next line--
select 
  t1.sales_date, 
  t1.num_of_sales, 
  t1.cumul_sales, 
  t1.current_period_sales, 
  round(
    coalesce(
      (
        t1.current_period_sales - t2.current_period_sales
      )* 1.0 --the 1.0 is to avoid integer division--
      / t2.current_period_sales, 
      0
    )* 100, 2) as growth_percent --this is the formula for the growth percentage, coalesce is to change the first value of the row to 0 from Null--
 --and the round function will round up the result upto 2 decimal places--
from 
  cte as t1 --aliasing the cte as t1--
  left join cte as t2 on t1.rn1 = t2.rn1 + 1;
--doing a left join to the cte aliased as t2 with rn1 as primary key, the'+1' will offset the rows so that they can join correctly--



 --Joining the sales and products table for analysis--
select 
  s.sales_transaction_date, 
  CONVERT(
    date, sales_transaction_date, 101
  ) as sales_date, 
  DATEPART(year, sales_transaction_date) as years, 
  DATEPART(week, sales_transaction_date) as week_num, 
  p.base_price, 
  s.customer_id, 
  p.model, 
  p.product_id, 
  p.product_type 
from 
  dbo.sales as s --aliasing the sales table as s--
  JOIN dbo.products as p on s.product_id = p.product_id;  --aliasing the products table as p and joing it with the sales table with product_id as the primary key--


--summary table to calculate CTR and opening rate for sprint scooters--
with cte_sent as (
  select 
    COUNT(e.customer_id) as num_of_sent, 
    CONVERT(date, sent_date, 101) as date --using the count function to calculate the total no:of sent emails--
  from 
    dbo.emails as e --aliasing the emails table as e
    join dbo.sales as s on e.customer_id = s.customer_id --aliasing the sales table as s and joining it to the emails table with the customer_id as the primary key--
  where 
    product_id = 7 
    and CONVERT(date, sent_date, 101) >= '2016-09-01' --filtering the search results based on the sent_date between 01-09-2016 and 31-10-2016 i.e, 3 months before the Sprints launch--
    and CONVERT(date, sent_date, 101) <= '2016-10-31' 
  group by 
    --grouping the search results by sent_date of the emails table--
    CONVERT(date, sent_date, 101)
), 
cte_bounces as (
  select 
    COUNT(e.customer_id) as num_of_bounces, 
    CONVERT(date, sent_date, 101) as date, 
    --using the count function to calculate the total no:of sales--
    e.bounced 
  from 
    dbo.emails as e --aliasing the emails table as e
    join dbo.sales as s on e.customer_id = s.customer_id --aliasing the sales table as s and joining it to the emails table with the customer_id as the primary key--
  where 
    product_id = 7 
    and bounced = '1' 
    and CONVERT(date, sent_date, 101) >= '2016-09-01' --filtering the search results based on the sent_date between 01-09-2016 and 31-10-2016 i.e, 3 months before the Sprints launch--
    and CONVERT(date, sent_date, 101) <= '2016-10-31' 
  group by 
    --grouping the search results by bounced column of the emails table--
    e.bounced, 
    CONVERT(date, sent_date, 101)
), 
cte_opens as (
  select 
    COUNT(e.customer_id) as num_of_opens, 
    CONVERT(date, sent_date, 101) as date, 
    --using the count function to calculate the total no:of sales--
    e.opened 
  from 
    dbo.emails as e --aliasing the emails table as e
    join dbo.sales as s on e.customer_id = s.customer_id --aliasing the sales table as s and joining it to the emails table with the customer_id as the primary key--
  where 
    product_id = 7 
    and opened = '1' 
    and CONVERT(date, sent_date, 101) >= '2016-09-01' --filtering the search results based on the sent_date between 01-09-2016 and 31-10-2016 i.e, 3 months before the Sprints launch--
    and CONVERT(date, sent_date, 101) <= '2016-10-31' 
  group by 
    --grouping the search results by opened column of the emails table--
    e.opened, 
    CONVERT(date, sent_date, 101)
), 
cte_clicks as(
  select 
    COUNT(e.customer_id) as num_of_clicks, 
    CONVERT(date, sent_date, 101) as date, 
    --using the count function to calculate the total no:of sales--
    e.clicked 
  from 
    dbo.emails as e --aliasing the emails table as e
    join dbo.sales as s on e.customer_id = s.customer_id --aliasing the sales table as s and joining it to the emails table with the customer_id as the primary key--
  where 
    product_id = 7 
    and e.clicked = '1' 
    and CONVERT(date, sent_date, 101) >= '2016-09-01' --filtering the search results based on the sent_date between 01-09-2016 and 31-10-2016 i.e, 3 months before the Sprints launch--
    and CONVERT(date, sent_date, 101) <= '2016-10-31' 
  group by 
    --grouping the search results by bounced column of the emails table--
    e.clicked, 
    CONVERT(date, sent_date, 101)
) 
select 
  cte_bounces.num_of_bounces, 
  cte_opens.num_of_opens, 
  cte_sent.num_of_sent,
  cte_clicks.num_of_clicks,
  round(
    (cte_opens.num_of_opens * 1.0)/(
      cte_sent.num_of_sent - cte_bounces.num_of_bounces
    ), 
    2
  ) as open_rate, 
  round(
    (cte_clicks.num_of_clicks * 1.0)/(
      cte_sent.num_of_sent - cte_bounces.num_of_bounces
    ), 
    2
  ) as click_rate 
from 
  cte_sent 
  left join cte_opens on cte_opens.date = cte_sent.date 
  left join cte_bounces on cte_bounces.date = cte_sent.date 
  left join cte_clicks on cte_clicks.date = cte_sent.date;



--joining the the emails, email_subject and the sales table--
select 
  e.customer_id, 
  s.product_id, 
  CONVERT(
    date, sales_transaction_date, 101
  ) as transaction_date, 
  --extracting just the dates fron the sales_transaction_date column into transaction_date column--
  e.opened, 
  e.clicked, 
  e.bounced, 
  CONVERT(date, sent_date, 101) as sent_email_date, 
  --extracting dates from sent_date,clicked_date,opened_date into the 101 format and making new columns for each--
  CONVERT(date, clicked_date, 101) as clicked_email_date, 
  CONVERT(date, opened_date, 101) as opened_email_date, 
  e.email_subject_id, 
  es.email_subject 
from 
  dbo.emails as e -- aliasing the emails table as e--
  join dbo.email_subject as es on e.email_subject_id = es.email_subject_id --aliasing the email_subject tables as es and joining it to the email table with email_subject_id as the primary key--
  join dbo.sales as s on e.customer_id = s.customer_id --aliasing the sales table as s and joining it to the emails table with customer_id as the primary key--
where 
  product_id = 7 
  and CONVERT(date, sent_date, 101) >= '2016-09-01' --filtering the search results based on the sent_date between 01-09-2016 and 31-10-2016 i.e, 3 months before the Sprints launch--
  and CONVERT(date, sent_date, 101) <= '2016-10-31' 
order by   --sorting the results by sent_date in ascending order--
  CONVERT(date, sent_date, 101);
  
 

