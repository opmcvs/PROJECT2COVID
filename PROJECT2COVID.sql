SELECT * FROM project1.covidvaccinationscsv;
use project1;


SELECT Location,date,total_cases,total_deaths,(total_deaths /total_cases) *100 AS DEATH_PERCENTAGE
FROM project1.coviddeathscsv
ORDER BY 1,2;

-- Show the percentage of population got Covid.
SELECT Location,date,total_cases,population,(total_cases /population) *100 AS PERCENTAGE_POPULATION_INFECTED
FROM project1.coviddeathscsv
ORDER BY 1,2;







-- Country that has the highest infection rate compared to population.
SELECT Location,population, max(total_cases) AS HighestInfectionCount  ,MAX((total_cases /population)) *100 AS PERCENTAGE_POPULATION_INFECTED
FROM project1.coviddeathscsv
GROUP BY location,population
ORDER BY PERCENTAGE_POPULATION_INFECTED DESC;

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION.
SELECT Location, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
FROM project1.coviddeathscsv
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

SELECT location, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
FROM project1.coviddeathscsv
WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY TotalDeathCount DESC;

-- --Take note the max is giving incorrect data because its NVarchar 
-- not int for aggregate funtion need to change it using CAST.

SELECT * FROM project1.coviddeathscsv;

-- Global Numbers
SELECT date,SUM(new_cases) AS TOTALCASES, SUM(new_deaths)AS TOTALDEATHS,sum(new_deaths)/sum(new_cases) *100
AS DEATHPERCENTAGE
FROM project1.coviddeathscsv
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- JOIN
SELECT * FROM project1.coviddeathscsv AS Dea
INNER JOIN project1.covidvaccinationscsv AS Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date;

-- --LOOKING AT TOTAL POPULATION VS VACCINATIONS
SELECT Dea.continent,Dea.location,Dea.date,Dea.population ,Vac.new_vaccinations
FROM project1.coviddeathscsv AS Dea
INNER JOIN project1.covidvaccinationscsv AS Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 1,2,3;

-- --ADDING THE NEW VACCINATIONS 
SELECT Dea.continent,Dea.location,Dea.date,Dea.population ,Vac.new_vaccinations,
SUM(Vac.new_vaccinations) OVER (partition by Dea.location ORDER BY Dea.location,Dea.date) 
AS TOTALVAC 
FROM project1.coviddeathscsv AS Dea
INNER JOIN project1.covidvaccinationscsv AS Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3;

-- you can't just use a column new created to aggregate it ex. TOTALVAC NEW COLUMN   
-- YOU CAN USE A TEMP TABLE OR CTE
-- 1.uSING cte
WITH PopsVac (continent,location,date,population,new_vaccinations,TOTALVAC)
AS
(SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vac.new_vaccinations,
SUM(new_vaccinations) OVER (partition by Dea.location ORDER BY Dea.location,Dea.date)
AS TOTALVAC
FROM project1.coviddeathscsv AS Dea
INNER JOIN project1.covidvaccinationscsv AS Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3)
SELECT *,(TOTALVAC/population) *100 AS PERCENTAGEVAC FROM PopsVac;

-- USING TEMP TABLE 
DROP TABLE if exists TOTALVAC;
CREATE  TEMPORARY TABLE TOTALVAC 
(continent varchar(50),
location varchar(50),
date DATETIME,
population int,
new_vaccinations int,
TOTALVAC int);
INSERT INTO TOTALVAC 
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
       SUM(Vac.new_vaccinations) OVER (PARTITION BY Dea.location ORDER BY Dea.location, Dea.date) AS TOTALVAC
FROM project1.coviddeathscsv AS Dea
INNER JOIN project1.covidvaccinationscsv AS Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2, 3;


SELECT *,(TOTALVAC/population) *100 AS PERCENTAGEVAC FROM TOTALVAC;

-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
-- 1.
CREATE VIEW TOTALVAC AS
SELECT Dea.continent,Dea.location,Dea.date,Dea.population ,Vac.new_vaccinations,
SUM(Vac.new_vaccinations) OVER (partition by Dea.location ORDER BY Dea.location,Dea.date) 
AS TOTALVAC 
FROM project1.coviddeathscsv AS Dea
INNER JOIN project1.covidvaccinationscsv AS Vac
ON Dea.location = Vac.location AND Dea.date = Vac.date;
-- WHERE Dea.continent IS NOT NULL

--   2.
CREATE VIEW TOTALDEATHCOUNT AS
    SELECT continent,max(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
FROM project1.coviddeathscsv
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;



