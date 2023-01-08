--Data Preparation and Understanding
--Q1) Begin
Select Count(customer_Id) from  dbo.Customer
union all
Select Count(Transaction_id) from Transactions
Union all
Select Count(Prod_Cat_Code) from prod_cat_info;
/*5647 rows in customer table
23053 rows in Transactions table
23 rows in Prod_cat_info*/
 
 --End

--Q2) Begin
Select Count(transaction_id) as Count_of_Transactions from Transactions where Qty < 0;

--End

--Q3) Begin
Select Convert(nvarchar,DOB,105) , * from Customer;
Select Convert(nvarchar,tran_date,105) as [Trandate], * from Transactions;

ALTER TABLE Customer
ALTER COLUMN DOB date;

ALTER TABLE Transactions
ALTER COLUMN tran_date date;

--End
--Q4) Begin

Select DateDiff(Day,Min(tran_date),Max(tran_date)) as [Days], DateDiff(Month,Min(tran_date),Max(tran_date)) as [Months], DateDiff(YEAR,Min(tran_date),Max(tran_date)) as [Years] from Transactions

--End
--Q5) Begin

Select prod_cat
from prod_cat_info
Where prod_subcat = 'DIY';

--End

--Data Analysis

--Q1) Begin

Select Top 1 Store_type, Count(Store_type) as No_of_tran_by_Store_type 
from Transactions
Group by Store_type
Order by No_of_tran_by_Store_type Desc;
--End

--Q2) Begin

Select Gender, Count(Gender)
from Customer
Group by Gender;
--End


--Q3) Begin

SELECT Top 1 City_code, COUNT(City_Code) AS CountOfCC
FROM Customer
GROUP BY City_code
Order by CountofCC Desc;
--End


--Q4) Begin

Select Count(prod_subcat)
From prod_cat_info
Where prod_cat = 'Books';
--End

--Q5) Begin
--Acc to prod cat and prod sub cat
Select prod_cat_code,prod_subcat_code, Max(Qty)
From Transactions
Where Qty>0
Group by Prod_cat_code, prod_subcat_code
order by Max(Qty) Desc;

--or now overall
Select Max(Qty)
From Transactions
Where Qty > 0;
--End

--Q6) Begin

Select Round(Sum(Total_amt),2) as Tot_Rev_El_books
From Transactions
Where prod_cat_code = '3' or prod_cat_code = '5';

--End
--Q7) Begin
Select cust_id, Count(Transaction_id) as Countoftran
From Transactions
Where Qty>0
Group by cust_id
Having Count(Transaction_id) > 10;
--End

--Q8) Begin
Select Count(Total_amt) as Comb_Rev_Elec_Clothing
from Transactions
where  prod_cat_code in (1,3) and Store_type = 'Flagship Store';

--End

--Q9) Begin
Select prod_subcat_code ,Round(Sum(Total_Amt),2) as MTotRev
from
Transactions T Inner Join Customer C on T.cust_id=C.customer_Id
where prod_cat_code = '3' and Gender = 'M'
Group by prod_subcat_code
Order by MTotRev Desc;
--End

--Q10) Begin

SELECT Top 5 prod_subcat_code,
(SUM(CASE 
WHEN total_amt > 0 
THEN total_amt 
END)/sum(total_amt))*100 AS Sales_Percentage,
(SUM(CASE 
WHEN total_amt < 0 
THEN total_amt 
END)/sum(total_amt))*100 AS Return_Percentage
FROM Transactions
GROUP BY prod_subcat_code
Order by Sales_Percentage Desc;
--End


--Q11) Begin

SELECT 
SUM(total_amt) [NET TOTAL REVENUE]
FROM (Select t.*, Max(T.tran_date) over () as lasttransdate from Transactions t)
T JOIN Customer C ON T.cust_id = C.customer_Id

WHERE t.tran_date >= DATEADD(day, -30, t.lasttransdate) AND t.tran_date >= DATEADD(YEAR, 25, c.DOB) AND t.tran_date < DATEADD(YEAR, 31, c.DOB);

--End
 
--Q12) Begin
Select Top 1 prod_cat_code,Round(Sum(Total_amt),2) as Tot_Ret
From Transactions
Where tran_date >= DATEADD(Month,-3,'2014-02-28') and total_amt < 0
Group by prod_cat_code
Order by Tot_Ret;
----END

--Q13) Begin

Select Top 1 Store_type, Round(Sum(total_amt),2) as Tot_Amt, Sum(Qty) as Tot_Qty
From Transactions
Group by Store_type
Order by Tot_Amt Desc, Tot_Qty Desc;
--END

--Q14) Begin

SELECT p.prod_cat, AVG(T.total_amt) AS [avg] 
FROM (SELECT t.*, AVG(T.total_amt) OVER () as ovr_avg FROM Transactions T) T JOIN prod_cat_info P 
ON T.prod_cat_code = P.prod_cat_code
GROUP BY p.prod_cat, ovr_avg
HAVING AVG(T.total_amt) > ovr_avg
Order by [avg] desc;
------END
 
---Q15) Begin
SELECT TOP 5 MAX(Qty) AS Quantity, AVG(total_amt) AS 'Avg_Rvn', SUM(total_amt) as 'Tot_Rvn',prod_cat as 'Product Category',prod_subcat as 'Product Sub Category'
FROM Transactions T LEFT JOIN prod_cat_info P ON P.prod_sub_cat_code=T.prod_subcat_code
GROUP BY prod_subcat,prod_cat
ORDER BY MAX(Qty) desc,AVG(total_amt) desc ,SUM(total_amt) desc;


---END






Select * from Customer
Select * from Transactions
Select * from prod_cat_info
