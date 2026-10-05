create database saas_analytics;
use saas_analytics;

#3
select count(*) as total_cuatomers from customers;

#4
select distinct segment from customers;

#5
select distinct industry from customers;

#6
select city,count(*) as customer_count
from customers
group by city
order by customer_count Desc;

#7
select min(signup_Date) as frist_signup,
max(signup_Date) as latest_signup from customers;

#8
select customer_ID,count(*) as duplicate_count
from customers
group by customer_ID
having count(*)>1;

#9
select
sum(case when customer_ID is null then 1 else 0 end)as null_customer_id,
sum(case when customer_ID is null then 1 else 0 end)as null_Name,
sum(case when customer_ID is null then 1 else 0 end)as null_city,
sum(case when customer_ID is null then 1 else 0 end)as null_segment,
sum(case when customer_ID is null then 1 else 0 end)as null_Industry,
sum(case when customer_ID is null then 1 else 0 end)as null_signup_Date from customers;

#10
select 
segment,count(*) as customer_count,
round(count(*) *100.0/(select count(*) from customers),2)as percentage
from customers
group by segment
order by customer_count desc;

#11
select*from plans;

#12
select count(*) as total_plans
from plans;

#13
select *from plans
order by Monthly_Price desc
limit 1;

#14
select *from plans
order by Monthly_Price 
limit 1;

#15
select *from subscriptions
limit 10;

#16
select count(*) as total_subscrptions from subscriptions;

#17
select status,count(*) as subscribtion_count
from subscriptions
group by status;

#18
select Billing_cycle,count(*) as subscribtion_count
from subscriptions
group by Billing_cycle;

#19
select plan_ID,count(distinct customer_ID) as customer_count
from subscriptions
group by plan_ID
order by customer_count desc;

#20
select count(*) as Active_subscription from subscriptions
where status ="Active"; 

#21
select distinct customer_ID from subscriptions
where status="Active";

#22
select count(distinct customer_ID) from subscriptions
where status="Active";

#23
select count(*) as cancelled_sub from subscriptions
where status="Cancelled";

#24
select plan_ID ,count(*) as sub_count
from subscriptions
group by plan_ID
order by sub_count desc;

#25
select plan_ID ,count(*) as sub_count
from subscriptions
group by plan_ID
order by sub_count desc
limit 1;

#26
select c.customer_ID,c.customer_Name,s.plan_ID from customers c
join subscriptions as s
on c.customer_ID=s.customer_ID
limit 10;

#27
select c.customer_Name,p.plan_Name from customers c
join subscriptions as s
on c.customer_ID=s.customer_Id
join plans as p
on s.plan_ID=p.plan_Id
limit 10;

#28
select p.plan_Name,count(distinct s.customer_ID)as customer_count
from subscriptions s
join plans p on s.plan_ID =p.plan_ID
group by p.plan_Name
order by customer_count desc;

#29
select c.customer_Name,p.plan_Name from customers c
join subscriptions as s
on c.customer_ID=s.customer_Id
join plans as p
on s.plan_ID=p.plan_Id
where s.status="Active"
limit 10;

#30
select c.customer_ID,c.customer_Name,c.city,p.plan_Name from customers c
join subscriptions as s
on c.customer_ID=s.customer_Id
join plans as p
on s.plan_ID=p.plan_Id
where p.plan_Name="Enterprise";

#31
select*from invoices;

#32
select sum(Amount) as total_invoice_revenue from invoices
where status <>"cancelled";

#33
SELECT 
    ROUND(AVG(Amount), 2) AS Average_Invoice_Amount
FROM invoices
WHERE Status <> 'Cancelled';

#34
SELECT 
    Status,
    SUM(Amount) AS Total_Amount
FROM invoices
GROUP BY Status
ORDER BY Total_Amount DESC;

#35
SELECT COUNT(*) AS Overdue_Invoices
FROM invoices
WHERE Status = 'Overdue';

#36
SELECT DISTINCT Customer_ID
FROM invoices
WHERE Status = 'Overdue';

#37
SELECT 
    p.Plan_Name,
    SUM(i.Amount) AS Total_Revenue
FROM invoices i
JOIN subscriptions s
    ON i.Subscription_ID = s.Subscription_ID
JOIN plans p
    ON s.Plan_ID = p.Plan_ID
WHERE i.Status <> 'Cancelled'
GROUP BY p.Plan_Name
ORDER BY Total_Revenue DESC;

#38
SELECT 
    Customer_ID,
    SUM(Amount) AS Total_Revenue
FROM invoices
WHERE Status <> 'Cancelled'
GROUP BY Customer_ID
ORDER BY Total_Revenue DESC
LIMIT 10;

#39
SELECT 
    Customer_ID,
    SUM(Amount) AS Total_Revenue
FROM invoices
WHERE Status <> 'Cancelled'
GROUP BY Customer_ID
ORDER BY Total_Revenue DESC
LIMIT 1;

#40
SELECT 
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS Revenue_Month,
    SUM(Amount) AS Monthly_Revenue
FROM invoices
WHERE Status <> 'Cancelled'
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY Revenue_Month;

#41
SELECT Customer_ID, SUM(Amount) AS Total_Revenue
FROM invoices
WHERE Status <> 'Cancelled'
GROUP BY Customer_ID
HAVING SUM(Amount) > (
    SELECT AVG(Customer_Revenue)
    FROM (
        SELECT Customer_ID, SUM(Amount) AS Customer_Revenue
        FROM invoices
        WHERE Status <> 'Cancelled'
        GROUP BY Customer_ID
    ) AS x
)
ORDER BY Total_Revenue DESC;

#42
SELECT c.Customer_ID, c.Customer_Name
FROM customers c
WHERE c.Customer_ID NOT IN (
    SELECT Customer_ID
    FROM subscriptions
    WHERE Status = 'Active'
);

#43
SELECT c.Customer_ID, c.Customer_Name
FROM customers c
WHERE c.Customer_ID IN (
    SELECT Customer_ID
    FROM invoices
    WHERE Status = 'Overdue'
);

#44
WITH Customer_Revenue AS (
    SELECT Customer_ID,
           SUM(Amount) AS Total_Revenue
    FROM invoices
    WHERE Status <> 'Cancelled'
    GROUP BY Customer_ID
)
SELECT *
FROM Customer_Revenue
ORDER BY Total_Revenue DESC;

#45
WITH Customer_Revenue AS (
    SELECT Customer_ID,
           SUM(Amount) AS Total_Revenue
    FROM invoices
    WHERE Status <> 'Cancelled'
    GROUP BY Customer_ID
)
SELECT *
FROM Customer_Revenue
ORDER BY Total_Revenue DESC
LIMIT 10;

#46
SELECT Customer_ID,
       SUM(Amount) AS Total_Revenue,
       RANK() OVER (ORDER BY SUM(Amount) DESC) AS Revenue_Rank
FROM invoices
WHERE Status <> 'Cancelled'
GROUP BY Customer_ID;

#47
SELECT p.Plan_Name,
       SUM(i.Amount) AS Total_Revenue,
       RANK() OVER (ORDER BY SUM(i.Amount) DESC) AS Revenue_Rank
FROM invoices i
JOIN subscriptions s
    ON i.Subscription_ID = s.Subscription_ID
JOIN plans p
    ON s.Plan_ID = p.Plan_ID
WHERE i.Status <> 'Cancelled'
GROUP BY p.Plan_Name;

#48
SELECT Customer_ID,
       Subscription_ID,
       ROW_NUMBER() OVER (
           PARTITION BY Customer_ID
           ORDER BY Start_Date
       ) AS Subscription_Number
FROM subscriptions;

#49
WITH Monthly_Revenue AS (
    SELECT DATE_FORMAT(Invoice_Date, '%Y-%m') AS Revenue_Month,
           SUM(Amount) AS Revenue
    FROM invoices
    WHERE Status <> 'Cancelled'
    GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
)
SELECT Revenue_Month,
       Revenue,
       LAG(Revenue) OVER (ORDER BY Revenue_Month) AS Previous_Month_Revenue
FROM Monthly_Revenue;

#50
WITH Monthly_Revenue AS (
    SELECT DATE_FORMAT(Invoice_Date, '%Y-%m') AS Revenue_Month,
           SUM(Amount) AS Revenue
    FROM invoices
    WHERE Status <> 'Cancelled'
    GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
),
Revenue_Comparison AS (
    SELECT Revenue_Month,
           Revenue,
           LAG(Revenue) OVER (ORDER BY Revenue_Month) AS Previous_Revenue
    FROM Monthly_Revenue
)
SELECT Revenue_Month,
       Revenue,
       Previous_Revenue,
       ROUND(
           (Revenue - Previous_Revenue) * 100.0 /
           Previous_Revenue, 2
       ) AS Growth_Percentage
FROM Revenue_Comparison;

#51
SELECT COUNT(DISTINCT Customer_ID) AS Cancelled_Customers
FROM cancellations;

#52
SELECT
    ROUND(
        COUNT(DISTINCT c.Customer_ID) * 100.0 /
        (SELECT COUNT(*) FROM customers),
        2
    ) AS Churn_Rate
FROM cancellations c;

#53
SELECT c.Segment,
       COUNT(DISTINCT ca.Customer_ID) AS Churned_Customers
FROM cancellations ca
JOIN customers c
    ON ca.Customer_ID = c.Customer_ID
GROUP BY c.Segment
ORDER BY Churned_Customers DESC;

#54
SELECT p.Plan_Name,
       COUNT(DISTINCT ca.Customer_ID) AS Churned_Customers
FROM cancellations ca
JOIN subscriptions s
    ON ca.Customer_ID = s.Customer_ID
JOIN plans p
    ON s.Plan_ID = p.Plan_ID
GROUP BY p.Plan_Name
ORDER BY Churned_Customers DESC;

#55
SELECT Customer_ID,
       COUNT(*) AS Ticket_Count
FROM support_tickets
GROUP BY Customer_ID
HAVING COUNT(*) >= 3
ORDER BY Ticket_Count DESC;

#56
SELECT DISTINCT ca.Customer_ID
FROM cancellations ca
JOIN product_usage pu
    ON ca.Customer_ID = pu.Customer_ID
WHERE pu.Total_Users > 10;

#57
SELECT Customer_ID,
       SUM(Amount) AS Total_Revenue
FROM invoices
WHERE Status <> 'Cancelled'
GROUP BY Customer_ID
HAVING SUM(Amount) > 50000
ORDER BY Total_Revenue DESC;

#58
SELECT DISTINCT Customer_ID
FROM invoices
WHERE Status = 'Overdue'

UNION

SELECT DISTINCT Customer_ID
FROM cancellations;

#59
SELECT p.Plan_Name,
       COUNT(DISTINCT s.Customer_ID) AS Customers,
       SUM(i.Amount) AS Total_Revenue
FROM plans p
JOIN subscriptions s
    ON p.Plan_ID = s.Plan_ID
JOIN invoices i
    ON s.Subscription_ID = i.Subscription_ID
WHERE i.Status <> 'Cancelled'
GROUP BY p.Plan_Name
ORDER BY Total_Revenue DESC
LIMIT 1;

#60
SELECT
    p.Plan_Name,
    COUNT(DISTINCT s.Customer_ID) AS Customers,
    COUNT(DISTINCT s.Subscription_ID) AS Subscriptions,
    SUM(CASE
        WHEN i.Status <> 'Cancelled' THEN i.Amount
        ELSE 0
    END) AS Total_Revenue
FROM plans p
LEFT JOIN subscriptions s
    ON p.Plan_ID = s.Plan_ID
LEFT JOIN invoices i
    ON s.Subscription_ID = i.Subscription_ID
GROUP BY p.Plan_Name
ORDER BY Total_Revenue DESC;













select *from subscriptions;
select*from plans;
select *from customers;
