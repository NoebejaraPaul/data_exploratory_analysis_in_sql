-- EDA (Exploratory Data Analysis) process 

SELECT *
FROM layoffs_staging2;

-- Look Maximum  total laid off and highest percentage laid off

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Look at company at that has high funding and has high percentage laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Look date range of this data
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2; -- results says is from 2020-03-22 to 2023-03-06

-- Look at company that has highent total layoffs FROM 2020-03-22 to 2023-03-06
SELECT company, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_off DESC;

-- Look at industry that has highent total layoffs FROM 2020-03-22 to 2023-03-06
SELECT industry, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_off DESC; -- Amazon lost many people

-- Look at country that has highent total layoffs FROM 2020-03-22 to 2023-03-06
SELECT country, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_off DESC; -- United States lost many people

-- Look at year that has highent total layoffs FROM 2020-03-22 to 2023-03-06
SELECT year(`date`), SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY year(`date`)
ORDER BY 2 DESC; -- 2022 was realy a hard year

-- Rooling total of layoffs
SELECT SUBSTRING(`date`, 1,7) AS `MONTH` , SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;

WITH Rolling_Total AS (
	SELECT SUBSTRING(`date`, 1,7) AS `MONTH` , SUM(total_laid_off) AS total_off
	FROM layoffs_staging2
	WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
	GROUP BY `MONTH`
	ORDER BY 1
)

SELECT `MONTH`, total_off, 
SUM(total_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- look at rank of each company lost per year

SELECT company, YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year(company, years, total_laid_off) AS(
	SELECT company, YEAR(`date`) , SUM(total_laid_off)
	FROM layoffs_staging2
	GROUP BY company, YEAR(`date`)
),Company_Rank_Year AS(
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS rankings
	FROM Company_Year
	WHERE years IS NOT NULL
)
SELECT *
FROM Company_Rank_Year
WHERE rankings <= 5
;









