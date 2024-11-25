-- Otazka 1
CREATE OR REPLACE VIEW v_km_salary_grow AS
SELECT 
    industry,
    average_salary AS last_year_salary,
    LAG(average_salary, 12) OVER (PARTITION BY industry ORDER BY year) AS first_year_salary,
    (average_salary - LAG(average_salary, 12) OVER (PARTITION BY industry ORDER BY year)) AS difference
FROM 
    t_karel_minarcik_project_sql_primary_final
WHERE 
    industry IS NOT null
GROUP BY
    average_salary;

SELECT * 
FROM v_km_salary_grow
WHERE difference IS NOT NULL; 

-- Otazka 2
SELECT 
    year,
    average_salary,
    food,
    avearage_year_price,
    ROUND(average_salary / avearage_year_price) AS total_products_for_salary
FROM 
    t_karel_minarcik_project_sql_primary_final tkmpspf
WHERE 
    locality IS NULL
    AND year IN (2006, 2018)
    AND (food = 'mléko polotučné pasterované' OR food = 'chléb konzumní kmínový')
    AND industry IS NULL
ORDER BY 
    year, food;

--Otazka 3
WITH price_changes AS (
    SELECT 
        food,
        year,
        average_year_price,
        LAG(average_year_price) OVER (PARTITION BY food ORDER BY year) AS previous_year_price,
        ROUND(
            (average_year_price - LAG(average_year_price) OVER (PARTITION BY food ORDER BY year)) 
            / LAG(average_year_price) OVER (PARTITION BY food ORDER BY year) * 100, 
            2
        ) AS percentage_change
    FROM 
        t_karel_minarcik_project_sql_primary_final
)
, average_price_growth AS (
    SELECT 
        food,
        AVG(percentage_change) AS avg_percentage_growth
    FROM 
        price_changes
    WHERE 
        percentage_change IS NOT NULL -- Exclude rows where there is no previous year
    GROUP BY 
        food
)
SELECT 
    food, 
    avg_percentage_growth
FROM 
    average_price_growth
ORDER BY 
    avg_percentage_growth ASC
LIMIT 1;

-- Otazka 4
WITH food_percentage_change AS (
    SELECT 
        food,
        year,
        average_year_price,
        locality,
        LAG(average_year_price, 1) OVER (PARTITION BY food ORDER BY year) AS previous_year_price,
        ROUND(
            (average_year_price - LAG(average_year_price, 1) OVER (PARTITION BY food ORDER BY year)) 
            / LAG(average_year_price, 1) OVER (PARTITION BY food ORDER BY year) * 100, 
            2
        ) AS percentage_change
    FROM 
        t_karel_minarcik_project_sql_primary_final tkmpspf
),
food_avg_change AS (
    SELECT 
        year,
        AVG(percentage_change) AS avg_percentage_change_per_year
    FROM 
        food_percentage_change
    WHERE 
        locality IS NULL
        AND percentage_change IS NOT NULL
        AND percentage_change <> 0
    GROUP BY 
        year
),
payroll_percentage_change AS (
    SELECT 
        year,
        average_salary,
        LAG(average_salary, 1) OVER (ORDER BY year) AS previous_year_salary,
        ROUND(
            (average_salary - LAG(average_salary, 1) OVER (ORDER BY year)) 
            / LAG(average_salary, 1) OVER (ORDER BY year) * 100, 
            2
        ) AS payroll_percentage_change
    FROM 
        t_karel_minarcik_project_sql_primary_final
    WHERE 
        industry IS null
    group by year
)
SELECT 
    fac.year,
    fac.avg_percentage_change_per_year AS food_percentage_change,
    ppc.payroll_percentage_change,
    ABS(fac.avg_percentage_change_per_year - ppc.payroll_percentage_change) AS difference_food_vs_payroll
FROM 
    food_avg_change fac
LEFT JOIN 
    payroll_percentage_change ppc
ON 
    fac.year = ppc.year
ORDER BY 
    fac.year;

-- Otazka 5
CREATE OR REPLACE VIEW correl AS
WITH food_percentage_change AS (
    SELECT 
        food,
        year,
        average_year_price,
        locality,
        LAG(average_year_price, 1) OVER (PARTITION BY food ORDER BY year) AS previous_year_price,
        ROUND(
            (average_year_price - LAG(average_year_price, 1) OVER (PARTITION BY food ORDER BY year)) 
            / LAG(average_year_price, 1) OVER (PARTITION BY food ORDER BY year) * 100, 
            2
        ) AS percentage_change
    FROM 
        t_karel_minarcik_project_sql_primary_final
),
food_avg_change AS (
    SELECT 
        year,
        AVG(percentage_change) AS avg_percentage_change_per_year
    FROM 
        food_percentage_change
    WHERE 
        locality IS NULL
        AND percentage_change IS NOT NULL
        AND percentage_change <> 0
    GROUP BY 
        year
),
payroll_percentage_change AS (
    SELECT 
        year,
        average_salary,
        LAG(average_salary, 1) OVER (ORDER BY year) AS previous_year_salary,
        ROUND(
            (average_salary - LAG(average_salary, 1) OVER (ORDER BY year)) 
            / LAG(average_salary, 1) OVER (ORDER BY year) * 100, 
            2
        ) AS payroll_percentage_change
    FROM 
        t_karel_minarcik_project_sql_primary_final
    WHERE 
        industry IS NULL
),
gdp_change AS (
    SELECT 
        year,
        GDP,
        LAG(GDP, 1) OVER (ORDER BY year) AS previous_GDP,
        ROUND(
            (GDP - LAG(GDP, 1) OVER (ORDER BY year)) 
            / LAG(GDP, 1) OVER (ORDER BY year) * 100, 
            2
        ) AS GDP_percentage_change
    FROM 
        t_karel_minarcik_project_sql_secondary_final
    WHERE 
        country = 'Czech Republic'
)
SELECT 
    fac.year AS year,
    fac.avg_percentage_change_per_year AS food_percentage_change,
    ppc.payroll_percentage_change,
    gc.GDP_percentage_change
FROM 
    food_avg_change fac
LEFT JOIN 
    payroll_percentage_change ppc ON fac.year = ppc.year
LEFT JOIN 
    gdp_change gc ON fac.year = gc.year
where payroll_percentage_change
ORDER BY 
    fac.year;

SELECT * FROM correl;

-- Korelace platy
WITH correL_data_prepared AS (
    SELECT 
        year,
        payroll_percentage_change,
        avg_payroll,
        payroll_percentage_change - avg_payroll AS avg_payroll_diff,
        GDP_percentage_change,
        avg_gdp,
        GDP_percentage_change - avg_gdp AS avg_gdp_diff
    FROM 
        correl,
        (SELECT 
             AVG(payroll_percentage_change) AS avg_payroll, 
             AVG(GDP_percentage_change) AS avg_gdp 
         FROM 
             correl) AS avg_values
)
SELECT 
    SUM(avg_payroll_diff * avg_gdp_diff) / 
    SQRT(SUM(POWER(avg_gdp_diff, 2)) * SUM(POWER(avg_payroll_diff, 2)))
FROM 
    correL_data_prepared;

-- Korelace potraviny
WITH correL_food_data_prepared AS (
    SELECT 
        year,
        food_percentage_change,
        avg_food,
        food_percentage_change - avg_food AS avg_food_diff,
        GDP_percentage_change,
        avg_gdp,
        GDP_percentage_change - avg_gdp AS avg_gdp_diff
    FROM 
        correl,
        (SELECT 
             AVG(food_percentage_change) AS avg_food, 
             AVG(GDP_percentage_change) AS avg_gdp 
         FROM 
             correl) AS avg_values
)
SELECT 
    SUM(avg_food_diff * avg_gdp_diff) / 
    SQRT(SUM(POWER(avg_gdp_diff, 2)) * SUM(POWER(avg_food_diff, 2)))
FROM 
    correL_food_data_prepared;

-- Korelace posunuta

-- Posunuta data
CREATE OR REPLACE VIEW shifted_data AS
    SELECT 
        year,
        GDP_percentage_change,
        LAG(payroll_percentage_change) OVER (ORDER BY year) AS shifted_payroll_percentage_change,
        LAG(food_percentage_change) OVER (ORDER BY year) AS shifted_food_percentage_change
    FROM 
        correl;

SELECT * FROM shifted_data;

-- korelace posunuta platy
WITH correL_shifted_data_prepared AS (
    SELECT 
        year,
        shifted_payroll_percentage_change,
        avg_payroll,
        shifted_payroll_percentage_change - avg_payroll AS avg_payroll_diff,
        GDP_percentage_change,
        avg_gdp,
        GDP_percentage_change - avg_gdp AS avg_gdp_diff
    FROM 
        shifted_data,
        (SELECT 
             AVG(shifted_payroll_percentage_change) AS avg_payroll, 
             AVG(GDP_percentage_change) AS avg_gdp 
         FROM 
             shifted_data) AS avg_values
)
SELECT 
    SUM(avg_payroll_diff * avg_gdp_diff) / 
    SQRT(SUM(POWER(avg_gdp_diff, 2)) * SUM(POWER(avg_payroll_diff, 2)))
FROM 
    correL_shifted_data_prepared;

-- Korelace posunuta potraviny
WITH correL_shifted_food_data_prepared AS (
    SELECT 
        year,
        shifted_food_percentage_change,
        avg_food,
        shifted_food_percentage_change - avg_food AS avg_food_diff,
        GDP_percentage_change,
        avg_gdp,
        GDP_percentage_change - avg_gdp AS avg_gdp_diff
    FROM 
        shifted_data,
        (SELECT 
             AVG(shifted_food_percentage_change) AS avg_food, 
             AVG(GDP_percentage_change) AS avg_gdp 
         FROM 
             shifted_data) AS avg_values
)
SELECT 
    SUM(avg_food_diff * avg_gdp_diff) / 
    SQRT(SUM(POWER(avg_gdp_diff, 2)) * SUM(POWER(avg_food_diff, 2)))
FROM 
    correL_shifted_food_data_prepared;
