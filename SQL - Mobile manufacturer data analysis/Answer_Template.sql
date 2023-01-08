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
Select IDModel from(
Select Top 5 IDModel,
Sum(Quantity) Over (Order by Quantity) as Sumofsales
From FACT_TRANSACTIONS
Where DATEPART(YEAR,([Date]))in ('2008') 
Group by IDModel,Quantity) as T1
Intersect
Select IDModel from (
Select Top 5 IDModel,
Sum(Quantity) Over (Order by Quantity) as Sumofsales
From FACT_TRANSACTIONS
Where DATEPART(YEAR,([Date]))in ('2009') 
Group by IDModel,Quantity) as T2
Intersect
Select IDModel from (
Select Top 5 IDModel,
Sum(Quantity) Over (Order by Quantity) as Sumofsales
From FACT_TRANSACTIONS
Where DATEPART(YEAR,([Date]))in ('2010')
Group by IDModel,Quantity) as T3


--Q--END	
--Q8--BEGIN
Select * from 
(Select Sum(T.Quantity) as Sales,MF.Manufacturer_Name
From FACT_TRANSACTIONS T Join DIM_MODEL M on T.IDModel=M.IDModel
Join DIM_MANUFACTURER MF on M.IDManufacturer=MF.IDManufacturer
Where DATEPART(Year,(T.[Date])) in ('2009')
Group by MF.Manufacturer_Name
Order by Sales Desc
Offset 1 Row
Fetch next 1 Row only) as T1 Union 
Select * 
from
(Select Sum(T.Quantity) as Sales,MF.Manufacturer_Name
From FACT_TRANSACTIONS T Join DIM_MODEL M on T.IDModel=M.IDModel
Join DIM_MANUFACTURER MF on M.IDManufacturer=MF.IDManufacturer
Where DATEPART(Year,(T.[Date])) in ('2010')
Group by MF.Manufacturer_Name
Order by Sales Desc
Offset 1 Row
Fetch next 1 Row only) as T2


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
	
Select Top 100 T.TotalPrice,T.Quantity,C.Customer_Name, DATEPART(Year, T.[Date]) as [Year] ,AVG(T.TotalPrice) as AVG_SPEND, AVG(T.Quantity) as AvgQty
From FACT_TRANSACTIONS T join DIM_CUSTOMER C on T.IDCustomer=C.IDCustomer
Group By DATEPART(Year, T.[Date]), T.TotalPrice,T.Quantity,C.Customer_Name
Order by AVG_SPEND Desc, AVGQty Desc, [Year];

--Q10--END
	