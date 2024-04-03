
create database RETAIL_CASE_1;
Use RETAIL_CASE_1;
select * from customer;
select * from Prod_cat_info;
select * from transactions;
-------------------------------------------------QUESTIONS-----------------------------------------------------------------------------------------
--DATA PREPARATION AND UNDERSTANDING----
--Q1. 
select COUNT(customer_id) as CUSTOMER_ROW_COUNT from Customer;
select COUNT(prod_cat_code) as PROD_CAT_INFO_ROW_COUNT from prod_cat_info;
select COUNT(transaction_id) as TRANSACTION_ROW_NUMBER from transactions;

--Q2.
select count(*) as RETURNED_TRANSACTION from (select * from transactions where qty < 0) as A

--Q3.
-- We did the trasformation the dates in desired format while importing the data in SQL server.

--Q4.
select MAX(tran_date) as CURRENT_TRAN_DATE, MIN(tran_date) as START_TRAN_DATE ,
datediff(year,min(tran_date) , max(tran_date)) as YEAR_TRAN_RANGE ,
datediff(MONTH,min(tran_date) , max(tran_date)) as MONTH_TRAN_RANGE ,
datediff(day,min(tran_date) , max(tran_date)) as DAY_TRAN_RANGE 
from transactions;

--Q5.
select prod_cat, Prod_subcat from prod_Cat_info where prod_subcat = 'DIY'


-----------------------------------------DATA ANALYSIS-----------------------------------------------------
--Q1.
select top 1 store_type, COUNT(store_type) as FREQNT_TRAN from transactions  group by store_type order by COUNT(store_type)desc

--Q2.
select gender, COUNT(gender) as customer_count from Customer  where gender in ('F','M') group by gender

--Q3.
select top 1 city_code, COUNT(city_code) as Cust_Count from Customer group by city_code order by COUNT(city_code) desc

--Q4.
select prod_cat ,COUNT(prod_subcat) as SUBCAT_COUNT from prod_cat_info where prod_cat= 'Books' group by prod_cat

--Q5.
select max(qty) as MAX_PROD_ORDERED from Transactions

--Q6.
select SUM(total_amt) as REVENUE from Transactions where prod_cat_code in (3,5)

--Q7
select COUNT(transaction_id) as TRAN_Count,cust_id  from Transactions where Qty > 0 group by cust_id having COUNT(transaction_id) >10 

--Q8.
select prod_cat,SUM(total_amt) as REVENUE from Transactions inner join prod_cat_info on 
Transactions.prod_cat_code=prod_cat_info.prod_cat_code and Transactions.prod_subcat_code = prod_cat_info.prod_sub_cat_code
where prod_cat in ('electronics','clothing') and Store_type = 'Flagship store'
group by prod_cat;



--Q9.
select prod_subcat,SUM(total_amt) as TOTAL_REVENUE from Transactions 
inner join Customer  
on Transactions.cust_Id=Customer.customer_Id 
inner join prod_cat_info
on Transactions.prod_cat_code=prod_cat_info.prod_cat_code and Transactions.prod_subcat_code = prod_cat_info.prod_sub_cat_code
 where Gender = 'M' and prod_cat = 'Electronics'
group by prod_subcat

--Q10.
Select Top 5 prod_subcat_code,
Sum(Case When total_amt > 0 Then total_amt Else 0 end ) as Sales,
Sum(Case When total_amt < 0 Then total_amt Else 0 end ) as [Returns],
Sum(Case When total_amt < 0 Then total_amt Else 0 end )* 100/Sum(Case When total_amt > 0 Then total_amt Else 0 end ) as [Return%],
100+Sum(case When total_amt < 0 Then total_amt Else 0 end)* 100/Sum(Case When total_amt > 0 Then total_amt Else 0 end) as [Sales %]
from Transactions
group by prod_subcat_code 
Order By [Sales %]




--Q11.
select SUM(total_amt) as REVENUE from  Transactions T
left Join Customer C on T.cust_id = C.customer_Id
where tran_date>= DATEADD(DAY,-30,(select max(tran_date) from Transactions ))
and
tran_date >= DATEADD(year,25,C.DOB) and
tran_date <= DATEADD(year,35,C.DOB)


--Q12.
select top 1 P.prod_cat from Transactions T
left join prod_cat_info P on  
T.prod_cat_code=p.prod_cat_code and T.prod_subcat_code = p.prod_sub_cat_code
where total_amt <0 and 
tran_date>= DATEADD(MONTH,-3,(select max(tran_date) from Transactions ))
group by P.prod_cat
order by sum(total_amt);



--Q13.
select top 1 STORE_TYPE,SUM(total_amt) as GRAND_AMT,COUNT(QTY) as QTY_CNT from Transactions
group by STORE_TYPE
order by SUM(total_amt) desc,COUNT(QTY) desc



--Q14.

select prod_cat_code, avg(total_amt) as GRAND_AMT from Transactions
group by prod_cat_code
having AVg(total_amt) > (select avg(total_amt)  from Transactions)

--Q15.
select  prod_subcat,AVG(total_amt) as AVG_AMT,SUM(Total_AMT) as GRAND_TOTAL from Transactions T
inner join prod_cat_info P on T.prod_cat_code= P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where T.prod_cat_code in 
(select top 5 prod_cat_code from Transactions
where Qty>0 and total_amt >0
group by prod_cat_code
order by SUM(Qty) desc)
group by  prod_subcat

