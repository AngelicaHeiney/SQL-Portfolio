SELECT *
FROM project.amazon;

SELECT `Order Date`
FROM amazon;

SELECT `Order Date`,
    STR_TO_DATE(`Order Date`, '%m/%d/%Y') as Converted_Date
FROM amazon;

UPDATE amazon
SET `Order Date` = STR_TO_DATE(`Order Date`, '%m/%d/%Y');

ALTER TABLE amazon
MODIFY COLUMN `Order Date` DATE;

SELECT `Order ID`, COUNT(`Order ID`)
FROM amazon
GROUP BY `Order ID`
HAVING COUNT(`Order ID`) >1;

SELECT `Ship Date`,
    STR_TO_DATE(`Ship Date`, '%m/%d/%Y') as Converted_Date
FROM amazon;

UPDATE amazon
SET `Ship Date` = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');

ALTER TABLE amazon
MODIFY COLUMN `Ship Date` DATE;

SELECT Geography, 
SUBSTRING_INDEX(Geography, ',',1) AS Country,
SUBSTRING_INDEX(SUBSTRING_INDEX(Geography, ',',-2), ',', 1) AS City,
SUBSTRING_INDEX(Geography, ',',-1) AS State
FROM amazon;

ALTER TABLE amazon
ADD COLUMN Country VARCHAR (50) AFTER Geography,
ADD COLUMN City VARCHAR (50) AFTER Country,
ADD COLUMN State VARCHAR (50) AFTER City;

UPDATE amazon
SET Country = SUBSTRING_INDEX(Geography, ',',1),
City = SUBSTRING_INDEX(SUBSTRING_INDEX(Geography, ',',-2), ',', 1),
State = SUBSTRING_INDEX(Geography, ',',-1);

SELECT *
FROM (
	SELECT `Order Date`, ROW_NUMBER() OVER (PARTITION BY `Order ID` ORDER BY `Order ID`) AS row_num
FROM amazon) AS subquery
WHERE row_num > 1;

SELECT Sales,
CAST(Sales AS DECIMAL(10,2)) AS Converted_Sales,
Profit,
CAST(Profit AS DECIMAL(10,2)) AS Converted_Profit,
Quantity,
CAST(Quantity AS SIGNED) AS Converted_Quantity
FROM amazon;

ALTER TABLE amazon
MODIFY COLUMN Sales DECIMAL(10,2),
MODIFY COLUMN Quantity INT,
MODIFY COLUMN Profit DECIMAL(10,2);

SELECT `Order Date`, SUBSTRING_INDEX(`Order Date`, '-',1) as Year
FROM amazon;

ALTER TABLE amazon
ADD COLUMN Year VARCHAR (50);

UPDATE amazon
SET Year = SUBSTRING_INDEX(`Order Date`, '-',1);

SELECT `Order Date`, SUBSTRING_INDEX(SUBSTRING_INDEX(`Order Date`, '-',-2),'-',1) as Month
FROM amazon;

ALTER TABLE amazon
ADD COLUMN Month VARCHAR (50);

UPDATE amazon
SET Month = SUBSTRING_INDEX(SUBSTRING_INDEX(`Order Date`, '-',-2),'-',1);

#ANALYSIS 

##PROFIT BY YEAR 

SELECT Year, SUM(Profit)
FROM amazon
GROUP BY Year
ORDER BY SUM(Profit) desc;

##SALES BY YEAR
SELECT Year, SUM(Sales)
FROM amazon
GROUP BY Year
ORDER BY SUM(Sales) desc;

SELECT Country
FROM amazon
WHERE Country <> 'United States';

##LIST OF STATES

SELECT state
FROM amazon
group by state;

SELECT state, SUM(sales), SUM(profit)
FROM amazon
GROUP BY state
ORDER BY SUM(Profit) DESC;

###THERE ARE THREE STATES WITH NEGATIVE PROFIT (OR, AZ, CO)

##WHICH CATEOGIRES HAVE MORE QUANTITY ORDERS: BLINDERS
SELECT Category, SUM(Quantity)
FROM amazon
GROUP BY Category
ORDER BY SUM(Quantity) DESC;


## CATEGORIES BY PROFIT
SELECT Category, avg(Profit)
FROM amazon
GROUP BY Category
ORDER BY AVG(Profit) DESC;

##CATEGORIES PER PROFIT PER YEAR
SELECT Category, SUM(Profit), Year
FROM amazon
GROUP BY Year, Category
ORDER BY AVG(Profit) DESC;

## TOP 10 ORDER ID WITH MORE QUANTITY
SELECT `Order ID`, SUM(Quantity)
FROM amazon
GROUP BY `Order ID`
ORDER BY SUM(Quantity) DESC
LIMIT 10;


##TOP 10 BUYERS

SELECT EmailID, SUM(Quantity) 
FROM amazon
GROUP BY EmailID
ORDER BY SUM(Quantity)DESC;

##CITIES WITH MORE SELLS
SELECT City, State, SUM(Sales)
FROM project.amazon
GROUP BY City, State
ORDER BY SUM(Sales) desc;

#PRODUCT NAME BY PROFIT
SELECT `Product Name`, SUM(Profit)
FROM amazon
GROUP BY`Product Name`
ORDER BY SUM(Profit) desc
LIMIT 10;

#IS THERE A BETTER MONTH?

SELECT Month, Year, SUM(Sales)
FROM project.amazon
GROUP BY Month, Year
ORDER BY  SUM(Sales) DESC;

SELECT Category,
    AVG(DATEDIFF(`Ship Date`, `Order Date`)) AS average_shipping_time
FROM amazon
GROUP BY Category;

##AVG SALES QUANTITIY PER PRODUCT
SELECT`Product Name`, AVG(Sales)
FROM project.amazon
GROUP BY `Product Name`
ORDER BY AVG(Sales) DESC;

##Are there products that are frequently bought together

SELECT 
    a.`Product Name` AS Product_A, 
    b.`Product Name` AS Product_B, 
    COUNT(*) AS frequency_bought_together
FROM 
    amazon a
JOIN 
    amazon b 
ON 
    a.`Order ID` = b.`Order ID`
    AND a.`Product Name` < b.`Product Name`
GROUP BY 
    a.`Product Name`, 
    b.`Product Name`
ORDER BY 
    frequency_bought_together DESC;



