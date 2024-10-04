-- potraviny
create table potraviny(
select 	cpc.name potravina,
		cp.value cena,
		cpc.price_value mnozstvi,
		cpc.price_unit jednotka,
		cr.name lokalita,
		cr.code kod_lokality,
		cp.date_from datum_od,
		cp.date_to datum_do,
		YEAR(cp.date_from) AS year,
	    CASE 
	        WHEN MONTH(cp.date_from) BETWEEN 1 AND 3 THEN 1
	        WHEN MONTH(cp.date_from) BETWEEN 4 AND 6 THEN 2
	        WHEN MONTH(date_from) BETWEEN 7 AND 9 THEN 3
	        WHEN MONTH(date_from) BETWEEN 10 AND 12 THEN 4
	    END AS quarter
from czechia_price cp 
left join czechia_price_category cpc 
	on cp.category_code = cpc.code 
left join czechia_region cr 
	on cp.region_code = cr.code);

-- modifikace data na dva sloupce year and quarter
SELECT 
    YEAR(datum_od) AS year,
    CASE 
        WHEN MONTH(datum_od) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(datum_od) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(datum_od) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(datum_od) BETWEEN 10 AND 12 THEN 4
    END AS quarter
FROM potraviny p ;

	
-- platy

-- prumerny pocet zamestnancu
select *
from czechia_payroll cp 
join czechia_payroll_calculation cpc 
	on cp.calculation_code = cpc.code 
left join czechia_payroll_industry_branch cpib 
	on cp.industry_branch_code = cpib.code 
left join czechia_payroll_value_type cpvt 
	on cp.value_type_code = cpvt.code 
left join czechia_payroll_unit cpu 
	on cp.unit_code = cpu.code 
where cpvt.code = 316 and cp.value is not null;

-- prumerna mzda
select *
from czechia_payroll cp 
join czechia_payroll_calculation cpc 
	on cp.calculation_code = cpc.code 
left join czechia_payroll_industry_branch cpib 
	on cp.industry_branch_code = cpib.code 
left join czechia_payroll_value_type cpvt 
	on cp.value_type_code = cpvt.code 
left join czechia_payroll_unit cpu 
	on cp.unit_code = cpu.code 
where cp.value_type_code = 5958 and cp.value is not null;

-- other
select *
from czechia_payroll cp 
join czechia_payroll_calculation cpc 
	on cp.calculation_code = cpc.code 
left join czechia_payroll_industry_branch cpib 
	on cp.industry_branch_code = cpib.code 
left join czechia_payroll_value_type cpvt 
	on cp.value_type_code = cpvt.code 
left join czechia_payroll_unit cpu 
	on cp.unit_code = cpu.code 




-- vyber konkretni potraviny - Chléb konzumní kmínový
select *
from potraviny 
-- where potravina = "Jakostní víno bílé"
order by lokalita, datum_od;











