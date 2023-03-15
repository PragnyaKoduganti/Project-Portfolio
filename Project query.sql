select *
from CovidDeaths$
where continent is not null 
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
where continent is not null 
order by 3,4

--Looking at total cases VS Total deaths in United States
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location like '%States%'
and continent is not null 
order by 1,2

--Looking at Total cases VS Population
select location, date, total_cases, population, (total_cases/population)*100 as PopulationInfected
from CovidDeaths$
where location like '%States%'
and continent is not null
order by 1,2

--Looking at countries with Highest Infected rate compared to population
select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentagePopulationInfected
from CovidDeaths$
Group by location, population
order by PercentagePopulationInfected desc

--Showing countries with Highest death count 
select location, population, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths$
where continent is not null
Group by location, population
order by TotalDeathCount desc

--Showing continent with highest death count per population
select continent, population, MAX(total_deaths) as TotalDeaths, MAX(total_deaths/population)*100 as TotalDeathCount
from CovidDeaths$
group by continent, population
order by TotalDeathCount desc

--Showing Global numbers
select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths$
where continent is not null
order by 1,2

--Joining deaths and vaccinations tables
select *
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
on dea.location = vac.location
and dea.date = vac.date

--Looking at total population VS Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Use CTE
with PopVsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null)
select * , (RollingPeopleVaccinated/population)*100
from PopVsVac

--Temp table
drop table if exists #PercentagePeopleVaccinated
create table #PercentagePeopleVaccinated
(continent nvarchar(255), location nvarchar(255), Date datetime, population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric)
insert into #PercentagePeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
on dea.location = vac.location
and dea.date = vac.date
select * , (RollingPeopleVaccinated/population)*100
from #PercentagePeopleVaccinated

-- Creating view to store data for visualisation
create View PercentagePeopleVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * , (RollingPeopleVaccinated/population)*100
from #PercentagePeopleVaccinated














