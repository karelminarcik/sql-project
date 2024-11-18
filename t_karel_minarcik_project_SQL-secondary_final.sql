-- Druhá tabulka

CREATE OR REPLACE TABLE t_karel_minarcik_project_sql_secondary_final AS (
    WITH all_economies AS (
        SELECT 
            country,
            year,
            GDP,
            population,
            gini
        FROM economies e
        WHERE year BETWEEN 2006 AND 2018
    ),
    european_region AS (
        SELECT 
            country,
            region
        FROM religions
        WHERE region = 'Europe'
    )
    SELECT 
        ae.country,
        ae.year,
        ae.GDP,
        ae.population,
        ae.gini
    FROM all_economies ae
    RIGHT JOIN european_region er
        ON er.country = ae.country
    WHERE er.region IS NOT NULL
    GROUP BY ae.year, er.country
    ORDER BY er.country, ae.year
);
