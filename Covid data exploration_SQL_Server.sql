select *
from PortfolioProject..CovidDeaths
order by 3, 4;

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4;

-- Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2;

-- Looking at the total cases vs total deaths

-- shows the likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2;

-- for india
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2;

--Looking at the total cases vs the population

select location, date, population, total_cases, (total_cases/population)*100 as Infected_Percentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2;


-- what country has the highest infection rates? compared with its population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as Infected_Percentage
from PortfolioProject..CovidDeaths
-- where location like '%states%'
group by location,population
order by Infected_Percentage desc;

-- Showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc;

select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3, 4;

-- LETS BREAK THINGS DOWN BY CONTINENT

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc; -- when we put location in select and where continent is not null, we get the countries in the output so to check the continent more accurately we 
-- use location in seclect and where continent is null, only in this condition the location takes up the continents name if you take a look at the dataset, we could maybe solve this if we updated and populated the location value to the place where continet is null  


-- this wont get the right results
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc;


-- showing the continets with highest death counts

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- Global numbers across the world by date

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2; 

-- global numbers across the world like the total. 
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
-- group by date
order by 1,2; 


-- Looking at total population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date)	as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3;



-- Use CTE

with PopvsVac (Continent, Location, Date, Population, NewVaccinations, RollingPeopleVaccinated) as 
(
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercent
from PopvsVac;

-- but one catch is that alex used dea.location in order by again purly out of habit to match his primary query layout,
-- slight redudant, works but actually is a bit bad habit

with PopvsVac (Continent, Location, Date, Population, NewVaccinations, RollingPeopleVaccinated) as 
(
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date)	as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercent
from PopvsVac;


-- Temp Table 

drop table if exists #PercentPopulationVaccinated -- keep this when youre planning on making any alterations, could drop the table, and sleect everything and create a new one, comes in handy
create table #PercentPopulationVaccinated -- the hastag here represents as "temporary" therefore a temporary table
(
Continent nvarchar(255), 
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
	
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.date)	as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
-- where dea.continent is not null 

select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercent
from #PercentPopulationVaccinated;


-- creating views to store data for later visualizations
go

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

-- we can use that view anywhere can be used for vizualization now, a view is just a saved sql script shortcut 
go
select *
from PercentPopulationVaccinated
