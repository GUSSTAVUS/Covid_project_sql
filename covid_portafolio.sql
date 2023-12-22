
/* Select Databases that we are going to be using
Seleccionamos las bases de datos con la que vamos a trabajar
*/

SELECT *
FROM  portafolioproject.coviddeaths
ORDER BY 1,2;

SELECT *
FROM portafolioproject.country_vaccinations
ORDER BY 1,2 ;


/*Covid_deaths vs Total Deaths
Shows the percentage of dying due to covid-19 in Mexico in relation to the number of deaths.

Muestra el porcentaje de que la causa de muerte haya sido por covid-19 en México 
relacionandolo con el total de muertes.
*/

SELECT country,start_date,end_date, covid_deaths, total_deaths,(covid_deaths/ total_deaths)*100 AS DeathPercentage
FROM portafolioproject.coviddeaths
WHERE country  like '%mexico%'
ORDER BY DeathPercentage DESC;

/* Look at covid deaths vs  population
Examinemos el porcentaje de la población que murio a causa de covid-19
*/

SELECT country,population,start_date,end_date, covid_deaths,(covid_deaths/ population)*100 AS DeathPercentage
FROM portafolioproject.coviddeaths
/*WHERE country  like '%mexico%'*/
ORDER BY 1,start_date DESC;

/* Showing countries with highest  death count per population
veamos el total de decesos por pais a causa de covid-19
*/
SELECT country,population, MAX(covid_deaths) AS TotalCovidDeaths
FROM portafolioproject.coviddeaths
GROUP BY country, population
ORDER BY TotalCovidDeaths DESC;

/*Global Numbers
Datos mundiales */

/* total vaccinations vs people vaccinated |*/
SELECT dea.country,dea.population,vac.date,vac.total_vaccinations, SUM(vac.total_vaccinations)  
OVER ( PARTITION BY dea.country ORDER BY dea.country,vac.date)AS People_vaccinated,
(People_vaccinated/dea.population)*100 as percentage_of_people_vaccinated
FROM portafolioproject.coviddeaths AS dea
JOIN portafolioproject.country_vaccinations AS vac
ON dea.country = vac.country  AND dea.start_date=vac.date;

/*Using CTE to perform Calculation on Partition By in previous query
Uso de la clausula expresion de tabla comun para hacer algunos calculos sobre la particion de query anterior*/
with PopvsVac (country,population,date,total_vaccinations,People_vaccinated)
as(
SELECT dea.country,dea.population,vac.date,vac.total_vaccinations, SUM(vac.total_vaccinations) 
 OVER ( PARTITION BY dea.country ORDER BY dea.country,vac.date)AS People_vaccinated
FROM portafolioproject.coviddeaths AS dea
JOIN portafolioproject.country_vaccinations AS vac
ON dea.country = vac.country  AND dea.start_date=vac.date
)
SELECT * FROM PopvsVac;

/* Temporal table
   Tabla temporal
*/
CREATE TEMPORARY TABLE PercentPopulationVaccinated
as(
SELECT dea.country,dea.population,vac.date,vac.total_vaccinations, SUM(vac.total_vaccinations)  OVER ( PARTITION BY dea.country ORDER BY dea.country,vac.date)AS People_vaccinated
FROM portafolioproject.coviddeaths AS dea
JOIN portafolioproject.country_vaccinations AS vac
ON dea.country = vac.country  AND dea.start_date=vac.date
);
SELECT * FROM PercentPopulationVaccinated;
SELECT count(*) FROM coviddeaths;


/* Creating view
Se usa la sentencia con la finalidad de crear tablas virtuales
*/
USE portafolioproject;
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.country,dea.population,vac.date,vac.total_vaccinations, SUM(vac.total_vaccinations)  OVER ( PARTITION BY dea.country ORDER BY dea.country,vac.date)AS People_vaccinated
FROM portafolioproject.coviddeaths AS dea
JOIN portafolioproject.country_vaccinations AS vac
ON dea.country = vac.country  AND dea.start_date=vac.date;