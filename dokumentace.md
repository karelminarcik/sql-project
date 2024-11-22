# Dokumentace projektu

## Úvod
Tento dokument popisuje proces zpracování dat, vytvoření tabulek a výstupy projektu zaměřeného na analýzu dostupnosti potravin a příjmů.

---

## 1. Vytvořené tabulky

### Tabulka `t_{jmeno}_{prijmeni}_project_SQL_primary_final`
- **Popis:** Sjednocená data o mzdách a cenách potravin v ČR.
- **Zdrojová data:** `czechia_payroll`, `czechia_price`.
- **Klíčové sloupce:**
  - `obor`: Odvětví.
  - `prumerna_mzda`: Průměrná mzda (v CZK)
  - `rok`: Rok.
  - `potravina`: Druh potraviny
  - `prumerna_cena_za_rok`: Průměrná cena potraviny za daný rok (v CZK)
  - `mnozstvi`: Množtví 
  - `jednotka`: Jednotka v jaké je potravina vedena (kg, l, g, ks)
  - `lokalita`: Lokalita  


### Tabulka `t_{jmeno}_{prijmeni}_project_SQL_secondary_final`
- **Popis:** Makroekonomická data evropských států.
- **Zdrojová data:** `economies`, `religions`.
- **Klíčové sloupce:**
  - `country`: Název státu.
  - `year`: Rok.
  - `GDP`: HDP na hlavu.
  - `population`: Počet obyvatel.
  - `gini`: GINI koeficient.

## 2. SQL dotazy


Viz soubor `queries.sql` v tomto repozitáři.

---

## 3. Výzkumné otázky

1. **Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**  
   **Výsledek:** Ano, mzdy ve všech odvětvích rostou.

2. **Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období?**  
   **Výsledek:**  
   - 2006: 1192 ks chleba, 1331 l mléka  
   - 2018: 1300 ks chleba, 1590 l mléka.

3. **Která kategorie potravin zdražuje nejpomaleji?**  
   **Výsledek:** Cukr krystalový (0.000772 % ročně).

4. **Existuje rok, kdy nárůst cen potravin byl výrazně vyšší než růst mezd (o více než 10%) ?**  
   **Výsledek:** Ne. I když v roce 2009 se hraniční hodnotě 10% s hodnotou 9.39% přiblížil.

5. **Má HDP vliv na změny ve mzdách a cenách potravin v témže roce?**  
   **Výsledek korelace:** 
   
   - HDP vs. ceny potravin: 0.34  
   - HDP vs. mzdy: 0.49 
    
   **Interpretace:** Slabší až střední pozitivní korelace.
   HDP má pozitivní vliv na změny cen potravin i mezd ve stejném roce. Tento vliv je však u cen potravin slabý a u mezd středně silný. Růst HDP tedy pravděpodobně více podporuje růst mezd než růst cen potravin.

   **Má HDP vliv na změny ve mzdách a cenách potravin v nasledujicím roce?**  
   **Výsledek korelace:** 

   - HDP vs. ceny potravin: -0.54  
   - HDP vs. mzdy: -0.23  

   **Interpretace:** Slabší až střední negativní korelace. 
   HDP má výraznější vliv na ceny potravin než na mzdy, ale v obou případech jde o negativní vztah. To znamená, že růst HDP obecně spíše snižuje ceny potravin a má jen mírný, téměř zanedbatelný vliv na snižování mezd.
   
   **Závěr:** Vztah naznačený korelací však nemusí být nutně příčinný – na obě proměnné mohou mít vliv další faktory, například inflace, produktivita nebo vládní politika.


