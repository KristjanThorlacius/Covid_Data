use [Portfolio Project]
select location, date, total_cases, new_cases, total_deaths, population from [Portfolio Project]..CovidDeaths$
order by 1,2
GO

--total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Ratio from [Portfolio Project]..CovidDeaths$
where location like '%states%'
order by 1,2
Go

--total cases vs population
select location, date, population, total_cases, (total_cases/population)*100 as Population_Cases_Ratio from [Portfolio Project]..CovidDeaths$
where location like '%states%'
order by 1,2
GO

--highest infection rate compared to population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population)*100) as HighestCaseRatio from [Portfolio Project]..CovidDeaths$
group by population, location
order by HighestCaseRatio desc
go
--countries with highest death count per population
select location, max(cast(total_deaths as int)) as Death_Amount from [Portfolio Project]..CovidDeaths$
where continent is not null
group by location
order by Death_Amount desc
go
--showing continents with highest death count
select location, max(cast(total_deaths as int)) as Death_Amount from [Portfolio Project]..CovidDeaths$
where continent is null
and location != 'world'
group by location
order by Death_Amount desc
go
--global numbers
select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Ratio from [Portfolio Project]..CovidDeaths$
where continent is not null
--group by date
order by 1,2
go
--total popuation vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinations from [Portfolio Project]..CovidDeaths$ dea
join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
go
--use CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinations)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinations from [Portfolio Project]..CovidDeaths$ dea
join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinations/Population)*100 from PopvsVac

GO
-- temp table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
rollingpeoplevaccinations numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinations from [Portfolio Project]..CovidDeaths$ dea
join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinations/Population)*100 as PercentVaccinated from #PercentPopulationVaccinated
GO
--creating view to store data for later visualization

select * from [dbo].[PercentPopulationVaccinated]
