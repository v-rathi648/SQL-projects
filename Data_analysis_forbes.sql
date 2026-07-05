-- 📌 Exploratory Data Analysis on forbes_200_companies_2026 Dataset

-- 🔍View full dataset 
SELECT * 
FROM forbes_2026 ;

-- Changing column_name
ALTER TABLE forbes_2026
RENAME COLUMN ï»¿Rank TO comp_rank ;

ALTER TABLE forbes_2026
RENAME COLUMN `Sales ($B)` TO comp_sales ;

ALTER TABLE forbes_2026
RENAME COLUMN `Profit ($B)` TO comp_profit ;

ALTER TABLE forbes_2026
RENAME COLUMN `Assets ($B)` TO Assets ;

ALTER TABLE forbes_2026
RENAME COLUMN `Market Value ($B)` TO Market_value ;

-- 🔍Finding Duplicates

SELECT * ,
ROW_NUMBER() OVER(PARTITION BY Company, Headquarters, Industry, comp_sales, comp_profit, Assets, Market_value ) as Row_num
FROM forbes_2026 ;

WITH double_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY Company, Headquarters, Industry, comp_sales, comp_profit, Assets, Market_value ) as Row_num
FROM forbes_2026 
)
SELECT * 
FROM double_cte 
WHERE Row_num > 1;  -- No Duplicates


-- 🔍View Industries 
SELECT Industry
FROM forbes_2026
GROUP BY Industry ;

-- 🔍Viewing Industries and their average sales, average profit, average assets, average market value 
SELECT Industry, AVG(comp_sales) avg_sales, AVG(comp_profit) avg_profit, AVG(Assets) avg_assets, AVG(Market_value) avg_market_value
FROM forbes_2026
GROUP BY Industry ;

SELECT Industry, AVG(comp_sales) avg_sales, AVG(comp_profit) avg_profit, AVG(Assets) avg_assets, AVG(Market_value) avg_market_value
FROM forbes_2026
GROUP BY Industry 
ORDER BY 3 DESC;

SELECT Industry, AVG(comp_sales) avg_sales, AVG(comp_profit) avg_profit, AVG(Assets) avg_assets, AVG(Market_value) avg_market_value
FROM forbes_2026
GROUP BY Industry 
ORDER BY 3 DESC;

WITH double_cte AS
(
SELECT Industry, AVG(comp_sales) avg_sales, AVG(comp_profit) avg_profit, AVG(Assets) avg_assets, AVG(Market_value) avg_market_value
FROM forbes_2026
GROUP BY Industry 
ORDER BY 3 DESC
)
SELECT Industry, 
MAX(avg_profit) OVER() AS max_avg_profit
FROM double_cte 
LIMIT 1;          -- Hence the Semiconductor industry earns the Maximum Average Profit


WITH industry_avg AS
(
SELECT Industry, AVG(comp_sales) avg_sales, 
				 AVG(comp_profit) avg_profit, 
                 AVG(Assets) avg_assets, 
                 AVG(Market_value) avg_market_value
FROM forbes_2026
GROUP BY Industry  
)
SELECT Industry, avg_market_value
FROM industry_avg
ORDER BY avg_market_value ASC 
LIMIT 1; 			-- Hence it gives the Minimum Average Market Value and the Industry with Minimum Average Market Value


-- 🔍View Industry and Companies grouped according to Industries
SELECT Industry, Company,
ROW_NUMBER() OVER(PARTITION BY Industry) as row_num
FROM forbes_2026 ;


-- 🔍Viewing Number of Companies in each Industry
WITH total_row as 
(
SELECT Industry, Company,
ROW_NUMBER() OVER(PARTITION BY Industry) as row_num
FROM forbes_2026 
)
SELECT Industry, COUNT(row_num) as total_num_companies
FROM total_row
GROUP BY Industry ; 


-- 🔍Viewing data of the Company which has missing or null value of industry 
SELECT *
FROM forbes_2026 
WHERE Industry LIKE '' OR null ;

-- 🔍Viewing companies and their Headquarters
SELECT Headquarters
FROM forbes_2026
GROUP BY Headquarters ;

SELECT Company, MAX(Assets)
FROM forbes_2026
GROUP BY Company 
LIMIT 3 ;    -- Top 3 Companies with Maximum Assets 

-- 🔍Viewing Companies with High Profit 
SELECT Company, comp_sales,
CASE
	WHEN comp_sales > 100 THEN 'High Profit'
END AS Profit_analysis
FROM forbes_2026 ;


-- 🔍Viewing if there're Comapnies with same rank 
SELECT comp_rank, Company,
ROW_NUMBER() OVER(PARTITION BY comp_rank) 
FROM forbes_2026 ;

WITH company_rank AS
(
SELECT comp_rank, Company,
ROW_NUMBER() OVER(PARTITION BY comp_rank) row_num
FROM forbes_2026 
)
SELECT * 
FROM company_rank 
WHERE row_num > 1; 	-- Hence this shows that there are many companies with same ranks

-- 🔍Viewing how many Indian Comapnies are there in this dataset 
SELECT *
FROM forbes_2026
WHERE Headquarters LIKE '%India' ;

WITH indian_comp AS 
(
SELECT *
FROM forbes_2026
WHERE Headquarters LIKE '%India' 
),
industry_cte as
(
SELECT Industry, AVG(comp_profit)
FROM indian_comp
GROUP BY Industry 
)
SELECT * 
FROM indian_comp
JOIN industry_cte 
	ON indian_comp.Industry = industry_cte.Industry ;
    
-- 🔍Viewing Top 3 Indian Companies with Maximum sales 

WITH top_comp AS
(
SELECT *
FROM forbes_2026
WHERE Headquarters LIKE '%India' 
)
SELECT * 
FROM top_comp
ORDER BY comp_sales DESC
LIMIT 3 ;
