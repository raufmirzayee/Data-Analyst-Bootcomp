
-- Exploratory Data Analsis 

SELECT MAX(total_laid_off) FROM processing_layoffs2;

SELECT company, MAX(total_laid_off) FROM processing_layoffs2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, SUM(total_laid_off) FROM processing_layoffs2
GROUP BY company
ORDER BY 2 DESC;


SELECT MIN(`date`) AS Started, MAX(`date`) AS Finished FROM processing_layoffs2
;

SELECT industry, SUM(total_laid_off) FROM processing_layoffs2
GROUP BY industry
ORDER BY 2 DESC;


SELECT country, SUM(total_laid_off) FROM processing_layoffs2
GROUP BY country
ORDER BY 2 DESC;

SELECT SUM(total_laid_off) FROM processing_layoffs2 WHERE country='Brazil';

SELECT *FROM processing_layoffs2;

SELECT country, MAX(funds_raised_millions) AS max_fund, SUM(funds_raised_millions) AS sum_fund FROM processing_layoffs2 
GROUP BY country
ORDER BY 2 DESC;

SELECT `date` , SUM(total_laid_off) FROM processing_layoffs2
GROUP BY `date` 
ORDER BY 2 DESC;


SELECT YEAR(`date`) , SUM(total_laid_off) FROM processing_layoffs2
GROUP BY YEAR(`date`) 
ORDER BY 2 DESC;

SELECT stage , SUM(total_laid_off) FROM processing_layoffs2
GROUP BY stage 
ORDER BY 2 DESC;

WITH Rolling_Total AS(
SELECT SUBSTRING(`date`, 1, 7) AS `month` , SUM(total_laid_off) AS total_off
 FROM processing_layoffs2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
)
SELECT `month`, total_of, SUM(total_off) OVER(ORDER BY `month`) AS ROLLING_TOTAL 
FROM Rolling_total;

SELECT company, YEAR(`date`), SUM(total_laid_off) FROM processing_layoffs2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_Yearly(Company, Years, Total_laid_off) AS(
SELECT company, YEAR(`date`) AS YEARS, SUM(total_laid_off) FROM processing_layoffs2
GROUP BY company, YEAR(`date`)
), Company_Ranking AS(
SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_laid_off DESC) AS Rankings 
FROM Company_Yearly
WHERE Years IS NOT NULL AND Total_laid_off IS NOT NULL
)
SELECT *FROM Company_Ranking
WHERE Rankings <= 5 
;
 