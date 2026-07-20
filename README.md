# Covid-19 Peak Data Exploration Analysis

## Project Overview
This project performs an end-to-end data analysis of global COVID-19 metrics spanning from **January 2020 to April 2021** (sourced from [Our World in Data](https://ourworldindata.org/covid-deaths)). To really analyze peaks around different countries and what was really going on around the world.

But also to clean raw data, perform exploratory data analysis (EDA) using **SQL Server Management Studio (SSMS)**, extract query outputs into modular datasets, and construct an **Tableau Public** dashboard with visual forecasting.

* **Data Timeframe:** January 2020 – April 2021
* **My Tableau Dashboard:** [Covid-Peak Analysis](https://public.tableau.com/views/Covid-PeakAnalysis/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## Workflow

1. **Excel (Data Preprocessing):** Cleaned raw datasets, handled missing values, and separated the raw data into `CovidDeaths.xlsx` and `CovidVaccinations.xlsx`.
2. **SQL Server Management Studio (SSMS):** Executed DQL queries using **Joins, Aggregate Functions, CTEs, Temporary Tables, Window Functions, and Views**.
3. **Tableau Public:** Exported query results to 4 separate Excel tables (`Tableau Table 1` to `4`) to build an interactive dashboard featuring a global map, continent bar charts, KPI cards, and trend line forecasting.

---

## Key Dashboard Metrics & Visuals

* **Global KPIs:** Displays **150,574,977** Total Cases, **3,180,206** Total Deaths, and a **2.11%** Global Fatality Rate.
* **Total Death Count Per Continent:** Ranked bar chart showing Europe with the highest death count, followed by North America, South America, Asia, Africa, and Oceania.
* **Infection Rate World Map:** Visualizes population infection percentages across countries, scaling up to **17.13%**.
* **Infection Trends & Forecast:** A time-series line graph tracking historical infection trajectories per country (e.g., US reaching **8.93%** by March 2021) along with predictive forecasting estimates extending into late 2021.

---

## SQL Query Breakdown & Data Logic

### 1. Data Exploration Script (`Covid data exploration_SQL_Server.sql`)
* **Infection vs. Mortality Rates:** Calculated likelihood of death upon contracting COVID-19 globally and specifically for countries like India and the US.
* **Continent Data Logic:** In this dataset, when `continent` is `NULL`, the continent name itself is populated inside the `location` column. To get accurate continent totals and avoid getting country-level outputs, queries filtered for `WHERE continent IS NULL GROUP BY location`.
* **Vaccination Tracking:** Joined death and vaccination datasets on `location` and `date`, using `SUM() OVER(PARTITION BY location ORDER BY date)` window functions to calculate cumulative rolling vaccination counts.
* **CTEs, Temp Tables & Views:** Used `PopvsVac` CTEs and `#PercentPopulationVaccinated` temp tables to compute derived percentages, saving final scripts as reusable Database Views.

### 2. Tableau Visualization Extract Script (`Tableau Covid Peak Viz SQL Queries.sql`)
* **Table 1:** Extracts global summary metrics (Total Cases, Total Deaths, Death Percentage).
* **Table 2:** Pulls total death counts per continent, filtering out non-geographic categories (`World`, `European Union`, `International`).
* **Table 3:** Measures peak infection counts and highest infection percentages per population by country.
* **Table 4:** Tracks country infection rates over time grouped by date to power Tableau's time-series charts and forecasting models.

---

## Repository Structure
* `/Data`: The 2 main Excel files (`CovidDeaths.xlsx`, `CovidVaccinations.xlsx`) and exported SQL tables (`Tableau Table 1` through `4`) used for Tableau visualizations.
* `/SQL`: The `.sql` scripts containing full data exploration queries and visualization extract queries.
* `/Tableau Visualization`: File of my Tableau Viz Dashboard.

## Connect with me!
* If you're interested with my work, feel free to reach out!
* [<img src="https://cdn-icons-png.flaticon.com/512/174/174857.png" width="20" height="20" style="vertical-align:middle"> saideepmacherla](https://www.linkedin.com/in/saideepmacherla)
* [<img src="https://cdn.worldvectorlogo.com/logos/tableau-software.svg" width="20" height="20" style="vertical-align:middle"> Saideep Macherla - Vizzes](https://public.tableau.com/app/profile/saideep.macherla/vizzes)

---
