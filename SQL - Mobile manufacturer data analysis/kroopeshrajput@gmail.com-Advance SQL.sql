--SQL Advance Case Study


--Q1--BEGIN 


Select Distinct [State] 
from DIM_CUSTOMER C Join FACT_TRANSACTIONS T on  C.IDCustomer=T.IDCustomer
Join DIM_LOCATION L on T.IDLocation=L.IDLocation
Where [Date]  > '01-01-2005'

--Q1--END

--Q2--BEGIN

Select Top 1 Sum(T.Quantity) as Tot_Sal,L.[State] 
from 
FACT_TRANSACTIONS T join DIM_MODEL M on T.IDModel=M.IDModel
Join DIM_LOCATION L on T.IDLocation=L.IDLocation
Where M.IDManufacturer = 12 and L.Country = 'US'
Group by L.[State]
Order by Tot_Sal desc;


--Q2--END

--Q3--BEGIN      
	
Select ZipCode, L.[State], COUNT(T.Quantity) as No_of_Transactions
from FACT_TRANSACTIONS T Join DIM_LOCATION L on T.IDLocation=L.IDLocation
Group by ZipCode, L.[State]



--Q3--END

--Q4--BEGIN

Select Top 1 Ma.Manufacturer_Name,Mo.Model_Name,Unit_price
from DIM_MODEL MO Join DIM_MANUFACTURER MA on MO.IDManufacturer=MA.IDManufacturer
Order by Unit_price;

--Q4--END


--Q5--BEGIN

SELECT TOP 5 Manufacturer_Name, AVG(TOTALPRICE) as AVG_RATE, SUM(QUANTITY) as SALES_QUANTITY
FROM FACT_TRANSACTIONS T LEFT JOIN DIM_MODEL M ON T.IDModel=M.IDModel
INNER JOIN DIM_MANUFACTURER MA ON M.IDManufacturer=MA.IDManufacturer
GROUP BY Manufacturer_Name
ORDER BY SALES_QUANTITY DESC


--Q5--END

--Q6--BEGIN

Select C.Customer_Name, AVG(T.TotalPrice)  as Avg2009spend   
from FACT_TRANSACTIONS T Join DIM_CUSTOMER C on T.IDCustomer=C.IDCustomer
Where  Datepart(Year,T.[Date])= 2009
Group by C.Customer_Name
Having AVG(T.TotalPrice)>500
Order by Avg2009spend Desc;


--Q6--END
	
--Q7--BEGIN  
------------
SELECT Model
From (SELECT TOP (5) DIM_MODEL.Model_Name as model
FROM  DIM_MODEL INNER JOIN
      FACT_TRANSACTIONS ON DIM_MODEL.IdModel = FACT_TRANSACTIONS.IdModel
GROUP BY DIM_MODEL.Model_Name, YEAR(FACT_TRANSACTIONS.Date)
HAVING (YEAR(FACT_TRANSACTIONS.Date) = '2008')
ORDER BY SUM(FACT_TRANSACTIONS.Quantity) DESC) as A
INTERSECT
SELECT Model
From (SELECT TOP (5) DIM_MODEL.Model_Name as model
FROM  DIM_MODEL INNER JOIN
      FACT_TRANSACTIONS ON DIM_MODEL.IdModel = FACT_TRANSACTIONS.IdModel
GROUP BY DIM_MODEL.Model_Name, YEAR(FACT_TRANSACTIONS.Date)
HAVING (YEAR(FACT_TRANSACTIONS.Date) = '2009')
ORDER BY SUM(FACT_TRANSACTIONS.Quantity) DESC) as B 
INTERSECT
SELECT Model
From (SELECT TOP (5) DIM_MODEL.Model_Name as model
FROM  DIM_MODEL INNER JOIN
      FACT_TRANSACTIONS ON DIM_MODEL.IdModel = FACT_TRANSACTIONS.IdModel
GROUP BY DIM_MODEL.Model_Name, YEAR(FACT_TRANSACTIONS.Date)
HAVING (YEAR(FACT_TRANSACTIONS.Date) = '2010')
ORDER BY SUM(FACT_TRANSACTIONS.Quantity) DESC) as C

--Q--END	
--Q8--BEGIN

WITH RANK_2 AS 
    (SELECT MANUFACTURER_NAME,YEAR(DATE) AS YEAR,DENSE_RANK() OVER (PARTITION BY YEAR(DATE) ORDER BY SUM(TOTALPRICE)DESC) AS RANK
     FROM FACT_TRANSACTIONS AS T1
     INNER JOIN DIM_MODEL AS T2 ON T1.IDMODEL = T2.IDModel
     INNER JOIN DIM_MANUFACTURER AS T3 ON T3.IDManufacturer = T2.IDManufacturer
     GROUP BY Manufacturer_Name, YEAR(DATE))
SELECT YEAR, MANUFACTURER_NAME
FROM RANK_2
WHERE YEAR IN ('2009','2010') AND RANK='2'

--Q8--END
--Q9--BEGIN


Select Distinct Mf.Manufacturer_Name
From FACT_TRANSACTIONS T Full Join DIM_MODEL M on T.IDModel=M.IDModel
Join DIM_MANUFACTURER MF on M.IDManufacturer= MF.IDManufacturer
Where DATEPART(Year,T.[Date]) = 2010
Except
Select Distinct Mf.Manufacturer_Name
From FACT_TRANSACTIONS T Full Join DIM_MODEL M on T.IDModel=M.IDModel
Join DIM_MANUFACTURER MF on M.IDManufacturer= MF.IDManufacturer
Where DATEPART(Year,T.[Date]) = 2009

--Q9--END

--Q10--BEGIN

   SELECT 
    T1.Customer_Name, T1.Year, T1.Avg_Price,T1.Avg_Qty,
    CASE
        WHEN T2.Year IS NOT NULL
        THEN FORMAT(CONVERT(DECIMAL(8,2),(T1.Avg_Price-T2.Avg_Price))/CONVERT(DECIMAL(8,2),T2.Avg_Price),'p') ELSE NULL 
        END AS 'YEARLY_%_CHANGE'
    FROM
        (SELECT t2.Customer_Name, YEAR(t1.DATE) AS YEAR, AVG(t1.TotalPrice) AS Avg_Price, AVG(t1.Quantity) AS Avg_Qty FROM FACT_TRANSACTIONS AS t1 
        left join DIM_CUSTOMER as t2 ON t1.IDCustomer=t2.IDCustomer
        where t1.IDCustomer in (select top 100 IDCustomer from FACT_TRANSACTIONS group by IDCustomer order by SUM(TotalPrice) desc)
        group by t2.Customer_Name, YEAR(t1.Date)
        )T1
    left join
        (SELECT t2.Customer_Name, YEAR(t1.DATE) AS YEAR, AVG(t1.TotalPrice) AS Avg_Price, AVG(t1.Quantity) AS Avg_Qty FROM FACT_TRANSACTIONS AS t1 
        left join DIM_CUSTOMER as t2 ON t1.IDCustomer=t2.IDCustomer
        where t1.IDCustomer in (select top 100 IDCustomer from FACT_TRANSACTIONS group by IDCustomer order by SUM(TotalPrice) desc)
        group by t2.Customer_Name, YEAR(t1.Date)
        )T2
        on T1.Customer_Name=T2.Customer_Name and T2.YEAR=T1.YEAR-1
--Q10--END

