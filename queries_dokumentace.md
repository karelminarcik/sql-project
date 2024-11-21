# Dokumentace: queries.sql

## 1. Analýza růstu mezd (Otázka 1)
- **Popis:**
  - Tento dotaz vytváří pohled `salary_grow`, který porovnává průměrnou mzdu v aktuálním roce s průměrnou mzdou o 12 let zpět (pokud je k dispozici) v rámci jednotlivých oborů.
  - Obsahuje sloupec `difference`, což je rozdíl mezi těmito hodnotami.
- **Účel:**
  - Identifikace dlouhodobého růstu mezd podle oborů.

---

## 2. Produkty dostupné za průměrnou mzdu (Otázka 2)
- **Popis:**
  - Dotaz vypočítává počet jednotek vybraných potravin (`mléko polotučné`, `chléb konzumní`), které lze koupit za průměrnou mzdu v letech 2006 a 2018.
  - Porovnává průměrnou cenu vybraných produktů s průměrnou mzdou.
- **Účel:**
  - Analyzovat dostupnost potravin v průběhu času na základě změny mezd a cen.

---

## 3. Průměrný procentuální růst cen potravin (Otázka 3)
- **Popis:**
  - Tento dotaz určuje procentuální změnu ceny potravin mezi jednotlivými roky.
  - Počítá průměrný procentuální růst cen pro každou potravinu.
  - Výstup zahrnuje potravinu s nejnižším průměrným procentuálním růstem.
- **Účel:**
  - Vyhodnotit, které potraviny vykazují nejstabilnější cenový vývoj.

---

## 4. Porovnání růstu cen potravin a mezd (Otázka 4)
- **Popis:**
  - Dotaz analyzuje průměrnou roční procentuální změnu cen potravin a mezd. 
  - Vypočítává rozdíl mezi těmito hodnotami pro každý rok.
- **Účel:**
  - Hodnotit, zda růst cen potravin odpovídá růstu mezd v průběhu let.

---

## 5. Korelace mezi mezdami, cenami potravin a HDP (Otázka 5)
- **Popis:**
  - Dotaz vytváří pohled `correl`, který porovnává roční změny v růstu HDP, průměrných mezd a cen potravin.
  - Počítá korelaci mezi těmito proměnnými:
    - Korelace mezi HDP a průměrnými mzdami.
    - Korelace mezi HDP a cenami potravin.
- **Účel:**
  - Zkoumat souvislosti mezi ekonomickými ukazateli v aktuálním roce.

---

## Posunutá data (Shifted Data)
- **Popis:**
  - Pohled `shifted_data` porovnává růst HDP s předchozím rokem růstu mezd a cen potravin.
  - Data jsou analyzována za účelem zjištění zpožděného vlivu HDP na mzdy a ceny potravin.
- **Účel:**
  - Zkoumat souvislosti mezi ekonomickými ukazateli se zpožděním jednoho roku .

---

## Shrnutí
Tento soubor obsahuje analytické dotazy, které poskytují hluboký vhled do souvislostí mezi ekonomickými ukazateli, jako jsou mzdy, ceny potravin a HDP. Důraz je kladen na identifikaci trendů a vztahů mezi jednotlivými ukazateli v čase.
