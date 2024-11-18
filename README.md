# Analýza dostupnosti základních potravin na základě příjmů

## Úvod do projektu

Tento projekt je zaměřen na zodpovězení výzkumných otázek týkajících se dostupnosti základních potravin široké veřejnosti v České republice. Cílem je připravit robustní datové podklady, které umožní analyzovat vztah mezi příjmy a cenami potravin, a porovnat je s makroekonomickými indikátory, jako je HDP a GINI koeficient, ve vybraném časovém období.

---

## Výzkumné otázky

1. **Mzdy podle odvětví:**
   - Rostou mzdy ve všech odvětvích, nebo v některých klesají?
   
2. **Dostupnost potravin:**
   - Kolik litrů mléka a kilogramů chleba je možné koupit za první a poslední dostupné období v datech?

3. **Nejpomalejší zdražování:**
   - Která kategorie potravin zdražuje nejpomaleji (s nejnižším meziročním nárůstem cen)?

4. **Nerovnováha růstu:**
   - Existuje rok, kdy byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (o více než 10 %)?

5. **HDP a jeho vliv:**
   - Má výše HDP vliv na změny mezd a cen potravin? Pokud HDP vzroste výrazněji, projeví se to na mzdách nebo cenách ve stejném či následujícím roce?

---

## Struktura dat

### Primární tabulky:
- **czechia_payroll:** Mzdy v různých odvětvích za několikaleté období.
- **czechia_price:** Ceny vybraných potravin za stejné období.

### Číselníky:
- **czechia_payroll_calculation, czechia_payroll_industry_branch, czechia_payroll_unit, czechia_payroll_value_type:** Číselníky popisující atributy mezd.
- **czechia_price_category:** Číselník kategorií potravin.
- **czechia_region, czechia_district:** Informace o krajích a okresech ČR.

### Dodatečné tabulky:
- **religions:** Různé informace o zemích světa.
- **economies:** HDP, GINI koeficient, daňová zátěž apod.

---

## Výstupy projektu

1. **Datové tabulky:**
   - `t_{jmeno}_{prijmeni}_project_SQL_primary_final`: Obsahuje data mezd a cen potravin za Českou republiku sjednocená na totožné porovnatelné období.
   - `t_{jmeno}_{prijmeni}_project_SQL_secondary_final`: Dodatečná data o dalších evropských státech (HDP, GINI, populace).

2. **Sada SQL dotazů:**
   - SQL dotazy pro zodpovězení výzkumných otázek na základě vytvořených tabulek.

3. **Dokumentace:**
   - Popis vytvořených tabulek.
   - Seznam chybějících hodnot a další poznámky k datům.

---

## Postup realizace

1. **Příprava dat:**
   - Načtení dat z primárních tabulek do dočasných pohledů.
   - Sjednocení časových období a transformace dat do výsledných tabulek.

2. **Analýza dat:**
   - Tvorba SQL dotazů pro analýzu dat a odpovědi na výzkumné otázky.

3. **Prezentace výsledků:**
   - Uložení dat a dotazů do GitHub repozitáře.
   - Popis mezivýsledků, chybějících hodnot a metodologie.

---

## GitHub repozitář

### Obsah:
- **`README.md`:** Tento dokument s popisem projektu.
- **`primary_table.sql`:** SQL skript pro vytvoření tabulky `t_{jmeno}_{prijmeni}_project_SQL_primary_final`.
- **`secondary_table.sql`:** SQL skript pro vytvoření tabulky `t_{jmeno}_{prijmeni}_project_SQL_secondary_final`.
- **`queries.sql`:** SQL dotazy pro zodpovězení výzkumných otázek.
- **`notes.md`:** Dokumentace s poznámkami k projektu.

---

## Poznámky

- Data v primárních tabulkách zůstávají beze změny.
- Transformace a výpočty se provádějí výhradně v nově vytvořených tabulkách nebo pohledech.
- V případě chybějících hodnot budou uvedeny příslušné poznámky v dokumentaci.

---

## Kontakt

Pro více informací nebo dotazy se obracejte na autora projektu.
