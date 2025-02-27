-- Queries
SELECT *FROM layoffs;

-- 1. Remove Duplicates
CREATE TABLE processing_layoffs LIKE layoffs;
SELECT *FROM processing_layoffs;

INSERT processing_layoffs 
SELECT * FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions ) AS row_num
FROM processing_layoffs;

WITH Duplicate_CTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions ) AS row_num
FROM processing_layoffs
) SELECT *FROM Duplicate_CTE WHERE row_num >1;

-- Deleting Duplicates
WITH Duplicate_CTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions ) AS row_num
FROM processing_layoffs
) DELETE FROM Duplicate_CTE WHERE row_num >1;


SELECT *FROM processing_layoffs2;

INSERT INTO processing_layoffs2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions ) AS row_num
FROM processing_layoffs;

SELECT *FROM processing_layoffs2 WHERE row_num>1;
DELETE FROM processing_layoffs2 WHERE row_num>1;



-- 2. Standardize The Data thus spelling and ...
SELECT company, TRIM(company) FROM processing_layoffs2;
UPDATE processing_layoffs2 SET company =  TRIM(company);

SELECT DISTINCT industry FROM processing_layoffs2
ORDER BY 1;

SELECT *FROM processing_layoffs2
WHERE industry LIKE 'Crypto%';

UPDATE processing_layoffs2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE processing_layoffs2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- OR

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM processing_layoffs2 ORDER BY 1;
UPDATE processing_layoffs2 SET country =  TRIM(TRAILING '.' FROM country) 
WHERE country LIKE "United States%";

SELECT DISTINCT country 
FROM processing_layoffs2 ORDER BY 1;

-- Changing STRING to DATE
SELECT `date`, STR_TO_DATE(`date`, "%m/%d/%Y") AS new_date
FROM processing_layoffs2;

UPDATE processing_layoffs2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT *FROM processing_layoffs2;
ALTER TABLE processing_layoffs2
MODIFY COLUMN `date` DATE;

-- 3. NULL Values or Blank Values 
SELECT *FROM processing_layoffs2 WHERE industry IS NULL OR industry = '';
SELECT *FROM processing_layoffs2 WHERE company ='Airbnb';

SELECT * FROM processing_layoffs2 t1
JOIN processing_layoffs2 t2 
	ON t1.company = t2.company AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry= '') AND t2.industry IS NOT NULL;
    
SELECT t1.industry, t2.industry FROM processing_layoffs2 t1
JOIN processing_layoffs2 t2 
	ON t1.company = t2.company AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry= '') AND t2.industry IS NOT NULL;
    
UPDATE processing_layoffs2
SET industry = NULL
WHERE industry = '';

UPDATE processing_layoffs2 t1
JOIN processing_layoffs2 t2
	ON t1.company = t2.company AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

SELECT *FROM processing_layoffs2 WHERE industry IS NULL OR industry = '';

-- 4. Remove Any Columns OR Rows
SELECT * FROM processing_layoffs2
WHERE percentage_laid_off IS NULL AND total_laid_off IS NULL;

DELETE FROM processing_layoffs2 
WHERE percentage_laid_off IS NULL AND total_laid_off IS NULL;

SELECT *FROM processing_layoffs2;
ALTER TABLE processing_layoffs2
DROP COLUMN row_num;

