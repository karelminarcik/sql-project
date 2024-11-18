
# Poznámky k projektu

## Potraviny dle kvartálu
```sql
CREATE OR REPLACE VIEW potraviny_dle_kvartalu AS
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
FROM 
    czechia_price cp
LEFT JOIN 
    czechia_price_category cpc ON cp.category_code = cpc.code
LEFT JOIN 
    czechia_region cr ON cp.region_code = cr.code;
```

## Potraviny dle let
```sql
CREATE OR REPLACE VIEW potraviny_dle_let AS
SELECT 
    potravina,
    AVG(cena) AS prumerna_cena_za_rok,
    mnozstvi,
    jednotka,
    lokalita,
    year
FROM 
    potraviny_dle_kvartalu
GROUP BY 
    potravina, year, lokalita
ORDER BY 
    potravina, year, lokalita;

SELECT * FROM potraviny_dle_let;
```

## Průměrná mzda
```sql
CREATE OR REPLACE VIEW prumerna_mzda_quartal AS
SELECT 
    cpib.name AS obor,
    cp.value AS prumerna_mzda,
    cpu.name AS Kc,
    cp.payroll_year AS year,
    cp.payroll_quarter AS kvartal
FROM 
    czechia_payroll cp
JOIN 
    czechia_payroll_calculation cpc ON cp.calculation_code = cpc.code
LEFT JOIN 
    czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
LEFT JOIN 
    czechia_payroll_value_type cpvt ON cp.value_type_code = cpvt.code
LEFT JOIN 
    czechia_payroll_unit cpu ON cp.unit_code = cpu.code
WHERE 
    cp.value_type_code = 5958 AND cp.value IS NOT NULL;
```

## Tvorba tabulek
### Primární tabulka
```sql
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
FROM 
    potraviny_dle_let pdl
LEFT JOIN 
    prumerna_mzda_roky pmr ON pmr.year = pdl.year;
```

### Sekundární tabulka
```sql
CREATE OR REPLACE TABLE t_karel_minarcik_project_sql_secondary_final AS
WITH all_economies AS (
    SELECT 
        country,
        year,
        GDP,
        population,
        gini
    FROM 
        economies
    WHERE 
        year BETWEEN 2006 AND 2018
),
europian_region AS (
    SELECT 
        country,
        region
    FROM 
        religions
    WHERE 
        region = 'Europe'
)
SELECT 
    ae.country,
    ae.year,
    ae.GDP,
    ae.population,
    ae.gini
FROM 
    all_economies ae
RIGHT JOIN 
    europian_region er ON er.country = ae.country
WHERE 
    er.region IS NOT NULL
GROUP BY 
    ae.year, er.country
ORDER BY 
    er.country, ae.year;
```

## Výzkumné otázky
1. **Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**  
   **Výsledek:** Ano, mzdy ve všech odvětvích rostou.

2. **Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období?**  
   **Výsledek:**  
   - 2006: 1192 ks chleba, 1331 l mléka  
   - 2018: 1300 ks chleba, 1590 l mléka.

3. **Která kategorie potravin zdražuje nejpomaleji?**  
   **Výsledek:** Cukr krystalový (0.000772 % ročně).

4. **Existuje rok, kdy nárůst cen potravin byl výrazně vyšší než růst mezd?**  
   **Výsledek:** Ne.

5. **Má HDP vliv na změny ve mzdách a cenách potravin?**  
   **Výsledek:** Korelace:  
   - HDP vs. ceny potravin: 0.34  
   - HDP vs. mzdy: 0.48  
   **Interpretace:** Slabší až střední pozitivní korelace.
