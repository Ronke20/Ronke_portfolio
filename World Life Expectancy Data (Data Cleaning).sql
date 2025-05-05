# World Life Expectancy Project (Data Cleaning)

# Viewing the entire dataset to understand its structure
SELECT * 
FROM world_life_expectancy_data
;


# Checking for duplicate records based on Country and Year
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy_data
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;


# Identifying the duplicate rows with row Numbers greater than 1
SELECT *
FROM (
SELECT Row_ID,
CONCAT(Country, Year),
ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
FROM world_life_expectancy_data
) AS Row_table
WHERE Row_Num > 1
;


# Deleting duplicate rows
DELETE FROM world_life_expectancy_data
WHERE 
     Row_ID IN (
     SELECT Row_ID
FROM (
     SELECT Row_ID,
     CONCAT(Country, Year),
     ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
     FROM world_life_expectancy_data
     ) AS Row_table
WHERE Row_Num > 1
)
;


# Finding records where the Status field is empty
SELECT *
FROM world_life_expectancy_data
WHERE Status = ''
;


# Viewing all distinct non-empty Status values
SELECT DISTINCT (Status)
FROM world_life_expectancy_data
WHERE Status <> ''
;


# Listing countries classifies as "Developing"
SELECT DISTINCT (Country)
FROM world_life_expectancy_data
WHERE Status = 'Developing'
;

# Updating missing Status to "Developing" based on matching countries
UPDATE world_life_expectancy_data t1
JOIN world_life_expectancy_data t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;


# Inspecting records specifically for the USA
SELECT *
FROM world_life_expectancy_data
WHERE Country = 'United States of America'
;

# Updating missing Status to "Developed" based on matching countries
UPDATE world_life_expectancy_data t1
JOIN world_life_expectancy_data t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;


# Checking for completely NULL Status values
SELECT *
FROM world_life_expectancy_data
WHERE Status IS NULL
;


# Rechecking the full dataset after cleaning Status issues
SELECT *
FROM world_life_expectancy_data
;
 
 
# Finding entries where Life expectancy is missing
SELECT *
FROM world_life_expectancy_data
WHERE `Life expectancy` = ''
;


# Listing countries and years with missing Life expectancy data
SELECT Country,Year, `Life expectancy`
FROM world_life_expectancy_data
WHERE `Life expectancy` = ''
;


# Calculating mising Life expectancy by averaging neighboring years
SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy_data t1
JOIN world_life_expectancy_data t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy_data t3
    ON t1.Country = t3.Country
     AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;


# Filling missing Life expectancy values with the calculated averages
UPDATE world_life_expectancy_data t1
JOIN world_life_expectancy_data t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy_data t3
    ON t1.Country = t3.Country
	AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3. `Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;

# Verifying if missing Life expectancy values have been filled
SELECT Country,Year, `Life expectancy`
FROM world_life_expectancy_data
WHERE `Life expectancy` = ''
;


# Final check of the dataset after all cleaning steps
SELECT *
FROM world_life_expectancy_data
;