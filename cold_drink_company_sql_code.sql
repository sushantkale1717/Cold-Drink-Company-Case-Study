CREATE DATABASE case_study;

USE case_study;

CREATE TABLE sales_data (
    SalesDate DATE,
    Region VARCHAR(50),
    Product VARCHAR(50),
    Customer_Segment VARCHAR(50),
    Units_Sold INT,
    Revenue DECIMAL(10, 2),
    Promotion VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/six_week_sales_data.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM sales_data;

UPDATE sales_data
SET Region =
    CASE 
        WHEN Region = "South" THEN "South India (Chennai)"
        WHEN Region = "West" THEN "West India (Mumbai)"
        WHEN Region = "North" THEN "North India (Delhi)"
        WHEN Region = "East" THEN "East India (Kolkata)"
        ELSE region
    END
WHERE Region IN ("South","West","North","East");

# Cheking NULL Values
SELECT 
    COUNT(*) AS 'NULL_COUNT'
FROM
    sales_data
WHERE
    SalesDate IS NULL OR Region IS NULL
    OR Product IS NULL
    OR Customer_Segment IS NULL
    OR Units_Sold IS NULL
    OR Revenue IS NULL
    OR Promotion IS NULL;

# Exploratory Data Analysis
SELECT 
    COUNT(*) AS 'Total_Records',
    COUNT(DISTINCT Region) AS 'Total_Regions',
    COUNT(DISTINCT Product) AS 'Total_Product',
    COUNT(DISTINCT Customer_Segment) AS 'Customer_Segment',
    SUM(Units_Sold) AS 'Total_Units_Sold',
    ROUND(AVG(Revenue),2) AS 'Average_Revenue'
FROM
    sales_data;

# Sales Trend Analysis
SELECT 
    DATE(SalesDate) AS 'Date',
    DAYNAME(SalesDate) AS 'Day_Name',
    SUM(Units_Sold) AS 'Total_Units_Sold',
    SUM(Revenue) AS 'Total_Revenue'
FROM
    sales_data
GROUP BY SalesDate;

# Product Performance Analysis
SELECT 
    Product,
    SUM(Units_Sold) AS 'Total_Units_Sold',
    SUM(Revenue) AS 'Total_Revenue'
FROM
    sales_data
GROUP BY Product
ORDER BY Total_Revenue DESC;

# Regional Analysis
SELECT 
    Region,
    SUM(Units_Sold) AS 'Total_Units_Sold',
    SUM(Revenue) AS 'Total_Revenue'
FROM
    sales_data
GROUP BY Region
ORDER BY Total_Revenue DESC;

# Customer Segment Analysis
SELECT 
    Customer_Segment,
    SUM(Units_Sold) AS TotalUnitsSold,
    SUM(Revenue) AS TotalRevenue
FROM sales_data
GROUP BY Customer_Segment
ORDER BY TotalRevenue DESC;

# Promotion Effectiveness
SELECT 
    Promotion,
    SUM(Revenue) AS "TotalRevenue", 
    SUM(Units_Sold) AS "Total_Units_Sold",
    ROUND(SUM(Revenue) / SUM(Units_Sold), 2) AS "AvgRevenuePerUnit"
FROM sales_data
GROUP BY Promotion;

-- # Day with Highest Sales for Diet Cola in South Region
-- WITH CTE AS (
--     SELECT Region, DAYNAME(SalesDate) AS "Day", 
--     DENSE_RANK() OVER (PARTITION BY Region ORDER BY SUM(Revenue) DESC) AS Revenue_Rank 
--     FROM sales_data
--     WHERE Product = "Diet Cola"
--     GROUP BY Region, DAYNAME(SalesDate)
-- ) 
-- SELECT * FROM CTE WHERE Region = "South India (Chennai)" AND Revenue_Rank <= 3; 

