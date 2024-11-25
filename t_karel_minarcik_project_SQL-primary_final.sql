-- Potraviny dle let
CREATE OR REPLACE VIEW v_km_food AS
SELECT  
    cpc.name AS food,
    AVG(cp.value) AS average_year_price,
    cpc.price_value AS amounth,
    cpc.price_unit AS unit,
    cr.name AS locality,
    YEAR(cp.date_from) AS year
FROM czechia_price cp 
LEFT JOIN czechia_price_category cpc 
    ON cp.category_code = cpc.code 
LEFT JOIN czechia_region cr 
    ON cp.region_code = cr.code
GROUP BY food, year, locality, amounth, unit
ORDER BY food, year, locality;



-- Prumerna mzda za jednotlive roky
CREATE OR REPLACE VIEW v_km_salary AS
SELECT 
    cpib.name AS industry,
    AVG(cp.value) AS average_salary, 
    cpu.name AS currency,
    cp.payroll_year AS year
FROM czechia_payroll cp 
JOIN czechia_payroll_calculation cpc 
    ON cp.calculation_code = cpc.code 
LEFT JOIN czechia_payroll_industry_branch cpib 
    ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_value_type cpvt 
    ON cp.value_type_code = cpvt.code 
LEFT JOIN czechia_payroll_unit cpu 
    ON cp.unit_code = cpu.code 
WHERE cp.value_type_code = 5958 AND cp.value IS NOT null
GROUP BY industry, year;


-- Vysledek: create table t_karel_minarcik_project_SQL_primary_final
CREATE OR REPLACE TABLE t_karel_minarcik_project_SQL_primary_final AS
SELECT 
    industry,
    average_salary,
    vks.year AS year,
    food,
    average_year_price,
    amounth,
    unit,
    locality
FROM v_km_food vkf
LEFT JOIN v_km_salary vks
    ON vks.year = vkf.year;
