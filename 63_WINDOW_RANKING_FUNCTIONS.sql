-- WINDOW RANKING FUNCTION : 
-- ROW_NUMBER() : --> assign a unique no. to each row --> It doesn't handle ties
-- RANK() : --> Assign a rank toeach row --> It handles ties --> It leaves gaps in ranking
-- DENSERANK() : --> Assign a rank to each row -->It handles ties --> It leaves gaps in ranking


-- Rank the orders based on their sales from highest to lowest 
SELECT 
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) Sales_Rank_Row,
	RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_DENSE

FROM Sales.Orders		


-- USE CASE : TOP-N Analysis : Analysis the top performers to do targeted marketing
SELECT *
FROM (
	SELECT
		OrderID,
		ProductID
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales) SalesRank
	FROM Sales.Orders
) t WHERE SalesRank = 1

-- BOTTOM N analysis : 
-- Find the lowest two customer based on their total sales 
SELECT * 
FROM (
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
) t WHERE RankCustomers <= 2

-- Assign unique ID's : Helps to assign unique identifier for each row to help paginating(The process of breaking down a large data into smaller more managable chunks)
-- Assign unique ID's to the rows of the OrdersArchive table
SELECT 
ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
*
FROM Sales.OrdersArchive

-- IDentify Duplicates : Identify and remove duplicates rows to improve data quality
-- Identify duplicate rows in the table ordersarchive and return clean data without duplicate rows
SELECT * FROM (
SELECT 
ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) RN,
*
FROM Sales.OrdersArchive
) t WHERE RN = 1
-- WHERE RN > 1 : BAD DATA

-- NTILE() : Divides the rows into a specified no. of approx equal groups(Buckets)
-- SQL RULE : Larger groups come first
-- Bucket size = no. of rows / no.of bucket
SELECT
OrderID,
Sales,
NTILE(1) OVER(ORDER BY Sales DESC) OneBucket,
NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket,
NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket,
NTILE(4) OVER(ORDER BY Sales DESC) FourBucket
FROM Sales.Orders

-- USECASE : DATA SEGMENTAION 
-- Segment all orders into 3 categories : High , medium and low sales
SELECT *,
CASE WHEN Buckets = 1 THEN 'High'
	 WHEN Buckets = 2 THEN 'Medium'
	 WHEN Buckets = 3 THEN 'Low'
END SalesSegmentation
FROM (
	SELECT 
		OrderID,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) Buckets
	FROM Sales.orders
) t

-- DAta ENGG USE CASE : EQUALIZING LOAD : In order to export data divide the orders into two groups. 
SELECT
NTILE(2) OVER(ORDER BY OrderID) Buckets,
*
FROM Sales.Orders

-- PERCENTAGE BASED Ranking functions
-- CUME_DIST : Cumulative distribution cal the distibution of data points within a window
-- PERCENT_RANK : CAL. the relative position of each row

-- Find the products that fall within the highest 40% of the prices
SELECT *,
CONCAT(DistRank * 100, '%') DistRankPerc
FROM(
SELECT 
	Product,
	Price,
	CUME_DIST() OVER(ORDER BY Price DESC) DistRank
	-- PERCENT_RANK() OVER(ORDER BY Price DESC) DistPERRank
FROM Sales.Products
) t 
WHERE DistRank <= 0.4