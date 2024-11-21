-- Potraviny dle kvartalu
CREATE OR REPLACE VIEW v_km_potraviny_dle_kvartalu AS
SELECT  
    cpc.name AS potravina,
    cp.value AS cena,
    cpc.price_value AS mnozstvi,
    cpc.price_unit AS jednotka,
    cr.name AS lokalita,
    cr.code AS kod_lokality,
    cp.date_from AS datum_od,
    cp.date_to AS datum_do,
    YEAR(cp.date_from) AS year,
    CASE 
        WHEN MONTH(cp.date_from) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(cp.date_from) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(cp.date_from) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(cp.date_from) BETWEEN 10 AND 12 THEN 4
    END AS quarter
FROM czechia_price cp 
LEFT JOIN czechia_price_category cpc 
    ON cp.category_code = cpc.code 
LEFT JOIN czechia_region cr 
    ON cp.region_code = cr.code;

-- Potraviny dle let
CREATE OR REPLACE VIEW potraviny_dle_let AS
SELECT 
    potravina,
    AVG(cena) AS prumerna_cena_za_rok,
    mnozstvi,
    jednotka,
    lokalita,
    year
FROM v_km_potraviny_dle_kvartalu p 
GROUP BY potravina, year, lokalita, mnozstvi, jednotka
ORDER BY potravina, year, lokalita;

SELECT * FROM potraviny_dle_let;

-- Prumerna mzda kvartal
CREATE OR REPLACE VIEW prumerna_mzda_quartal AS
SELECT 
    cpib.name AS obor,
    cp.value AS prumerna_mzda, 
    cpu.name AS kc,
    cp.payroll_year AS year,
    cp.payroll_quarter AS kvartal
FROM czechia_payroll cp 
JOIN czechia_payroll_calculation cpc 
    ON cp.calculation_code = cpc.code 
LEFT JOIN czechia_payroll_industry_branch cpib 
    ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_value_type cpvt 
    ON cp.value_type_code = cpvt.code 
LEFT JOIN czechia_payroll_unit cpu 
    ON cp.unit_code = cpu.code 
WHERE cp.value_type_code = 5958 AND cp.value IS NOT NULL;

-- Prumerna mzda za dostupne roky
CREATE OR REPLACE VIEW prumerna_mzda_roky AS
SELECT 
    obor,
    AVG(prumerna_mzda) AS prumerna_mzda,
    year
FROM prumerna_mzda_quartal
GROUP BY obor, year;

-- Vysledek: create table t_karel_minarcik_project_SQL_primary_final
CREATE OR REPLACE TABLE t_karel_minarcik_project_SQL_primary_final AS
SELECT 
    obor,
    prumerna_mzda,
    pmr.year AS rok,
    potravina,
    prumerna_cena_za_rok,
    mnozstvi,
    jednotka,
    lokalita
FROM potraviny_dle_let pdl
LEFT JOIN prumerna_mzda_roky pmr
    ON pmr.year = pdl.year;
