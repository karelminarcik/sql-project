-- Question 1
CREATE OR REPLACE VIEW salary_grow AS
SELECT 
    obor,
    rok,
    prumerna_mzda AS posledni_rok_mzda,
    LAG(prumerna_mzda, 12) OVER (PARTITION BY obor ORDER BY rok) AS prvni_rok_mzda,
    (prumerna_mzda - LAG(prumerna_mzda, 12) OVER (PARTITION BY obor ORDER BY rok)) AS difference
FROM 
    t_karel_minarcik_project_sql_primary_final
WHERE 
    obor IS NOT NULL
GROUP BY
    prumerna_mzda
ORDER BY 
    obor, rok;

SELECT * 
FROM salary_grow
WHERE difference IS NOT NULL;

-- Question 2
SELECT 
    rok,
    prumerna_mzda,
    potravina,
    prumerna_cena_za_rok,
    ROUND(prumerna_mzda / prumerna_cena_za_rok) AS pocet_produktu_za_mzdu
FROM 
    t_karel_minarcik_project_sql_primary_final tkmpspf
WHERE 
    lokalita IS NULL
    AND rok IN (2006, 2018)
    AND (potravina = 'mléko polotučné pasterované' OR potravina = 'chléb konzumní kmínový')
    AND obor IS NULL
ORDER BY 
    rok, potravina;

--Question 3
WITH price_changes AS (
    SELECT 
        potravina,
        rok,
        prumerna_cena_za_rok,
        LAG(prumerna_cena_za_rok) OVER (PARTITION BY potravina ORDER BY rok) AS previous_year_price,
        ROUND(
            (prumerna_cena_za_rok - LAG(prumerna_cena_za_rok) OVER (PARTITION BY potravina ORDER BY rok)) 
            / LAG(prumerna_cena_za_rok) OVER (PARTITION BY potravina ORDER BY rok) * 100, 
            2
        ) AS percentage_change
    FROM 
        t_karel_minarcik_project_sql_primary_final tkmpspf
)
, average_price_growth AS (
    SELECT 
        potravina,
        AVG(percentage_change) AS avg_percentage_growth
    FROM 
        price_changes
    WHERE 
        percentage_change IS NOT NULL -- Exclude rows where there is no previous year
    GROUP BY 
        potravina
)
SELECT 
    potravina, 
    avg_percentage_growth
FROM 
    average_price_growth
ORDER BY 
    avg_percentage_growth ASC
LIMIT 1;

-- Question 4
WITH food_percentage_change AS (
    SELECT 
        potravina,
        rok,
        prumerna_cena_za_rok,
        lokalita,
        LAG(prumerna_cena_za_rok, 1) OVER (PARTITION BY potravina ORDER BY rok) AS previous_year_price,
        ROUND(
            (prumerna_cena_za_rok - LAG(prumerna_cena_za_rok, 1) OVER (PARTITION BY potravina ORDER BY rok)) 
            / LAG(prumerna_cena_za_rok, 1) OVER (PARTITION BY potravina ORDER BY rok) * 100, 
            2
        ) AS percentage_change
    FROM 
        t_karel_minarcik_project_sql_primary_final tkmpspf
),
food_avg_change AS (
    SELECT 
        rok,
        AVG(percentage_change) AS avg_percentage_change_per_year
    FROM 
        food_percentage_change
    WHERE 
        lokalita IS NULL
        AND percentage_change IS NOT NULL
        AND percentage_change <> 0
    GROUP BY 
        rok
),
payroll_percentage_change AS (
    SELECT 
        year AS rok,
        prumerna_mzda,
        LAG(prumerna_mzda, 1) OVER (ORDER BY year) AS previous_year_salary,
        ROUND(
            (prumerna_mzda - LAG(prumerna_mzda, 1) OVER (ORDER BY year)) 
            / LAG(prumerna_mzda, 1) OVER (ORDER BY year) * 100, 
            2
        ) AS payroll_percentage_change
    FROM 
        prumerna_mzda_roky
    WHERE 
        obor IS NULL
)
SELECT 
    fac.rok,
    fac.avg_percentage_change_per_year AS food_percentage_change,
    ppc.payroll_percentage_change,
    ABS(fac.avg_percentage_change_per_year - ppc.payroll_percentage_change) AS difference_food_vs_payroll
FROM 
    food_avg_change fac
LEFT JOIN 
    payroll_percentage_change ppc
ON 
    fac.rok = ppc.rok
ORDER BY 
    fac.rok;

-- Question 5
CREATE OR REPLACE VIEW correl AS
WITH food_percentage_change AS (
    SELECT 
        potravina,
        rok,
        prumerna_cena_za_rok,
        lokalita,
        LAG(prumerna_cena_za_rok, 1) OVER (PARTITION BY potravina ORDER BY rok) AS previous_year_price,
        ROUND(
            (prumerna_cena_za_rok - LAG(prumerna_cena_za_rok, 1) OVER (PARTITION BY potravina ORDER BY rok)) 
            / LAG(prumerna_cena_za_rok, 1) OVER (PARTITION BY potravina ORDER BY rok) * 100, 
            2
        ) AS percentage_change
    FROM 
        t_karel_minarcik_project_sql_primary_final tkmpspf
),
food_avg_change AS (
    SELECT 
        rok,
        AVG(percentage_change) AS avg_percentage_change_per_year
    FROM 
        food_percentage_change
    WHERE 
        lokalita IS NULL
        AND percentage_change IS NOT NULL
        AND percentage_change <> 0
    GROUP BY 
        rok
),
payroll_percentage_change AS (
    SELECT 
        year AS rok,
        prumerna_mzda,
        LAG(prumerna_mzda, 1) OVER (ORDER BY year) AS previous_year_salary,
        ROUND(
            (prumerna_mzda - LAG(prumerna_mzda, 1) OVER (ORDER BY year)) 
            / LAG(prumerna_mzda, 1) OVER (ORDER BY year) * 100, 
            2
        ) AS payroll_percentage_change
    FROM 
        prumerna_mzda_roky
    WHERE 
        obor IS NULL
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
    fac.rok AS rok,
    fac.avg_percentage_change_per_year AS food_percentage_change,
    ppc.payroll_percentage_change,
    gc.GDP_percentage_change
FROM 
    food_avg_change fac
LEFT JOIN 
    payroll_percentage_change ppc ON fac.rok = ppc.rok
LEFT JOIN 
    gdp_change gc ON fac.rok = gc.year
ORDER BY 
    fac.rok;

SELECT * FROM correl;

-- Correl payroll
WITH correL_data_prepared AS (
    SELECT 
        rok,
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

-- Correl food
WITH correL_food_data_prepared AS (
    SELECT 
        rok,
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

-- Correl shifted

-- Shifted data
CREATE OR REPLACE VIEW shifted_data AS
    SELECT 
        rok,
        GDP_percentage_change,
        LAG(payroll_percentage_change) OVER (ORDER BY rok) AS shifted_payroll_percentage_change,
        LAG(food_percentage_change) OVER (ORDER BY rok) AS shifted_food_percentage_change
    FROM 
        correl;

SELECT * FROM shifted_data;

-- Correl shifted payroll
WITH correL_shifted_data_prepared AS (
    SELECT 
        rok,
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

-- Correl shifted food
WITH correL_shifted_food_data_prepared AS (
    SELECT 
        rok,
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

