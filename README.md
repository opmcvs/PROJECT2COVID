Overview
This SQL script analyzes COVID-19 data from two tables: covidvaccinationscsv and coviddeathscsv in the project1 database. It computes various metrics such as death percentage, percentage of population infected, and vaccination statistics. Additionally, it creates views for later visualization and analysis.

Database and Tables
Database: project1
Tables:
covidvaccinationscsv: Contains data related to COVID-19 vaccinations.
coviddeathscsv: Contains data related to COVID-19 cases and deaths.
Views
TOTALVAC View:

Combines data from covidvaccinationscsv and coviddeathscsv.
Calculates the total number of vaccinations per location over time.
Calculates the percentage of population vaccinated.
TOTALDEATHCOUNT View:

Aggregates data from coviddeathscsv to compute the total death count per continent.
Queries
Death Percentage and Population Infection:

Calculates death percentage and percentage of population infected by COVID-19.
Country with Highest Infection Rate:

Identifies the country with the highest infection rate compared to its population.
Countries with Highest Death Count per Population:

Lists countries with the highest death count per population.
Global COVID-19 Numbers:

Aggregates global COVID-19 cases and deaths over time.
JOIN Query:

Joins coviddeathscsv and covidvaccinationscsv tables based on location and date.
Total Population vs. Vaccinations:

Compares total population with new vaccinations administered.
Temporary Table or CTE for Vaccination Analysis:

Utilizes a temporary table or Common Table Expression (CTE) to compute vaccination percentages.
Views for Visualization
