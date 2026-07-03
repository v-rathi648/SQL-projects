select * 
from layoff_staging3 ;

select max(total_laid_off)
from layoff_staging3 ;

select max(total_laid_off) , max(percentage_laid_off)
from layoff_staging3 ;

select * 
from layoff_staging3
where percentage_laid_off = 1
order by total_laid_off desc ;

select company, sum(total_laid_off)
from layoff_staging3 
group by company 
order by 2 desc;

select min(`date`), max(`date`)
from layoff_staging3 ;

select industry, sum(total_laid_off)
from layoff_staging3 
group by industry 
order by 2 desc;

select country, sum(total_laid_off)
from layoff_staging3 
group by country 
order by 2 desc;

select Year(`date`), sum(total_laid_off)
from layoff_staging3 
group by Year(`date`) 
order by 1 desc;

select stage, sum(total_laid_off)
from layoff_staging3 
group by stage
order by 2 desc;

select substring(`date`,1,7) Month , sum(total_laid_off)
from layoff_staging3
where substring(`date`,1,7)is not null
group by `Month` 
order by 1 asc;

with rolling_total as 
(
select substring(`date`,1,7) Month , sum(total_laid_off) as t_layoff
from layoff_staging3
where substring(`date`,1,7)is not null
group by `Month` 
order by 1 asc
)
select  `Month` , t_layoff
, sum(t_layoff) over(order by `Month`) as Rolling_total
from rolling_total ;

select company, Year(`date`), sum(total_laid_off)
from layoff_staging3
group by company, Year(`date`)
order by company asc ;

select company, Year(`date`), sum(total_laid_off)
from layoff_staging3
group by company, Year(`date`)
order by company asc ;

with company_year(company, years, total_laid_off) as 
(
select company, Year(`date`), sum(total_laid_off)
from layoff_staging3
group by company, Year(`date`)
),
company_year_rank as
(
select * , dense_rank() over(partition by years order by total_laid_off desc) as rank_num
from company_year 
where years is not null 
)
select *
from company_year_rank 
where rank_num <=5 ;

-- Removing duplicates --

select * ,
row_number() over(partition by company , location , industry, total_laid_off, percentage_laid_off, `date`, stage, country,  funds_raised_millions)as row_num
from layoff_staging3 ; 

with double_cte as 
(
select * ,
row_number() over(partition by company , location , industry, total_laid_off, percentage_laid_off, `date`, stage, country,  funds_raised_millions)as row_num
from layoff_staging3
)
select * 
from double_cte 
where row_num > 1;

CREATE TABLE `layoff_staging4` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoff_staging4 
select * ,
row_number() over(partition by company , location , industry, total_laid_off, percentage_laid_off, `date`, stage, country,  funds_raised_millions)as row_num
from layoff_staging3 ;

select * from 
layoff_staging4 ;

select * 
from layoff_staging4 
where row_num > 1 ;

delete
from layoff_staging4 
where row_num > 1 ;

select * 
from layoff_staging4 ;

select company, sum(total_laid_off)
from layoff_staging4
group by company 
order by 2 desc;

select industry, sum(total_laid_off)
from layoff_staging4
group by industry 
order by 2 desc;

select country, sum(total_laid_off)
from layoff_staging4 
group by country 
order by 2 desc;

select Year(`date`), sum(total_laid_off)
from layoff_staging4
group by Year(`date`) 
order by 1 desc;

select stage, sum(total_laid_off)
from layoff_staging4 
group by stage
order by 2 desc;

select substring(`date`,1,7) Month , sum(total_laid_off)
from layoff_staging4
where substring(`date`,1,7)is not null
group by `Month` 
order by 1 asc;

with rolling_total as 
(
select substring(`date`,1,7) Month , sum(total_laid_off) as t_layoff
from layoff_staging4
where substring(`date`,1,7)is not null
group by `Month` 
order by 1 asc
)
select  `Month` , t_layoff
, sum(t_layoff) over(order by `Month`) as Rolling_total
from rolling_total ;

select company, Year(`date`), sum(total_laid_off)
from layoff_staging4 
group by company, Year(`date`)
order by 3 desc ;

with company_year(company, years, total_laid_off) as 
(
select company, Year(`date`), sum(total_laid_off)
from layoff_staging4
group by company, Year(`date`)
), company_year_rank as 
(
select * , dense_rank() over(partition by years order by total_laid_off desc) as ranking 
from company_year
where years is not null 
)
select * 
from company_year_rank
where ranking <= 5;

select company , avg(percentage_laid_off) as avg_percentage 
from layoff_staging4
where percentage_laid_off is not null
group by company ;