# World Life Expectancy Project (Exploratory Data Analysis)

# Viewing the full dataset for exploratory analysis
SELECT * 
FROM world_life_expectancy_data
;


# Calculating the increase in Life expectancy over 15 years for each country
SELECT Country,
MIN(`Life expectancy`),
MAX(`LIFE expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy_data
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;


# Calculating the average life expectancy for each year
SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy_data
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;


# Rechecking the dataset
SELECT * 
FROM world_life_expectancy_data
;


# Comparing average Life expectancy and GDP for each country
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy_data
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;


# Analyzing Life expectancy diferences between high and low GDP countries 
SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy_data
;


# Viewing the dataset for cross-verification during analysis
SELECT * 
FROM world_life_expectancy_data
;


# Analyzing avaerage Life expectancy based on Development Status
SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy_data
GROUP BY Status
;


# Counting countries per Status and calculating their average Life expectancy
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy_data
GROUP BY Status
;


# Comparing Life expectancy and BMI averages by country
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy_data
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;


# Calculating the cumulative Adult Mortality over the years for countries with "United" in their names
SELECT Country,
year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy_data
WHERE Country LIKE '%United%'
;