-- 1.    Stwórz ranking pracowników oparty na wysokości pensji. Jeśli dwie osoby mają tę samą pensję, powinny otrzymać ten sam numer. 
select e.employee_id, e.First_Name, e.salary,
RANK() OVER ( order by e.salary DESC) as rank_salary
from employees e
order by e.salary DESC;

-- 2. Dodaj kolumnę, która pokazuje całkowitą sumę pensji wszystkich pracowników, ale bez grupowania ich. 

select e.employee_id, e.First_Name, e.salary,
RANK() OVER ( order by e.salary DESC) as rank_salary,
SUM(e.salary) OVER () as "Suma Wynagrodzen"
from employees e
order by e.salary DESC;

-- 3. Dla każdego pracownika wypisz: nazwisko, nazwę produktu, skumulowaną wartość sprzedaży dla pracownika, ranking wartości sprzedaży względem wszystkich zamówień. Skorzystaj dodatkowo z tabeli sales oraz products. 
select e.last_name, p.Product_Name,
SUM(s.price) OVER (PARTITION BY e.employee_id, p.product_Name order by s.sale_date) as "Suma Narastająca" from employees e
inner join sales s on e.employee_ID = s.employee_ID
inner join products p on p.product_id = s.product_id

-- 4.	Dla każdego wiersza z tabeli sales wypisać nazwisko pracownika, nazwę produktu, cenę produktu, liczbę transakcji dla danego produktu tego dnia, sumę zapłaconą danego dnia za produkt, poprzednią cenę oraz kolejną cenę danego produktu.
select e.last_name, p.product_name, s.price, 
ROW_NUMBER() OVER (PARTITION by s.sale_DATE, p.product_id ORDER BY s.sale_ID ) as "Liczba Transakcji",
sum(s.price) OVER (PARTITION by s.sale_Date, p.product_id) as "Suma W dniu za produkt",
LAG(s.price) OVER (PARTITION BY p.product_id ORDER BY s.price) as "Poprzednia cena",
LEAD(s.price) OVER (PARTITION BY p.product_id ORDER BY s.price) as "Następna cena"

from sales s
inner join employees e on e.employee_ID=s.Employee_ID
inner join products p on p.product_id=s.product_id


--5.	Dla każdego wiersza wypisać nazwę produktu, cenę produktu, sumę całkowitą zapłaconą w danym miesiącu oraz sumę rosnącą zapłaconą w danym miesiącu za konkretny produkt.
select p.product_name, s.Price, EXTRACT (YEAR FROM s.SALE_DATE) as "Rok", EXTRACT (MONTH from s.sale_Date) as "Mies",
SUM(s.price) OVER (PARTITION BY EXTRACT (YEAR FROM s.SALE_DATE), EXTRACT (MONTH from s.sale_Date)) as "Suma w Roku,Mies",
SUM(s.price) OVER (PARTITION BY s.product_id ORDER BY  EXTRACT (YEAR FROM s.SALE_DATE), EXTRACT (MONTH from s.sale_Date)) as "Suma narastajaca"
from sales s
inner join products p on p.PRODUCT_ID = s.PRODUCT_ID

-- 6.	Wypisać obok siebie cenę produktu z roku 2022 i roku 2023 z tego samego dnia oraz dodatkowo różnicę pomiędzy cenami tych produktów oraz dodatkowo nazwę produktu i jego kategorię.
SELECT 
    s.product_id,
    s.price as "Cena_2022",
    (SELECT s2.price FROM sales s2 WHERE s2.product_id = s.product_id AND EXTRACT(YEAR FROM s2.SALE_DATE) = 2023 AND EXTRACT(DAY FROM s2.SALE_DATE) = EXTRACT(DAY FROM s.SALE_DATE)  AND EXTRACT(MONTH FROM s2.SALE_DATE) = EXTRACT(MONTH FROM s.SALE_DATE)) as "Cena_2023",
    EXTRACT(MONTH FROM s.SALE_DATE) as "Mies",
    EXTRACT(DAY FROM s.SALE_DATE) as "Dzień"
FROM sales s 
WHERE EXTRACT(YEAR FROM s.SALE_DATE) = 2022

-- 7.	Dla każdego wiersza wypisać nazwę kategorii produktu, nazwę produktu, jego cenę, minimalną cenę w danej kategorii, maksymalną cenę w danej kategorii, różnicę między maksymalną a minimalną ceną.

select p.product_Category,p.product_name, s.price,
MIN(s.price) OVER( PARTITION by p.product_Category) as "Min Cena w Kateg",
MAX(s.price) OVER( PARTITION by p.product_Category) as "MAX Cena w Kateg",
(MAX(s.price) OVER( PARTITION by p.product_Category) - MIN(s.price) OVER( PARTITION by p.product_Category)) as "Różnica"
from sales s
inner join products p on s.product_id = p.product_id

-- 8. Dla każdego wiersza wypisz  nazwę produktu i średnią kroczącą ceny (biorącą pod uwagę poprzednią, bieżącą i następną cenę) tego produktu według kolejnych dat
select p.product_name,
ROUND(((COALESCE(LAG(s.price) OVER(PARTITION BY p.product_ID ORDER BY s.SALE_DATE),0) + s.price + COALESCE(LEAD(s.price) OVER(PARTITION BY p.product_ID  ORDER BY s.SALE_DATE),0))/3),2) as "Średnia ruchoma"

from sales s
inner join products p on s.product_ID = p.product_ID

-- 9.	Dla każdego wiersza nazwę produktu, kategorię oraz ranking cen wewnątrz kategorii, ponumerowane wiersze wewnątrz kategorii w zależności od ceny oraz ranking gęsty (dense) cen wewnątrz kategorii.
select p.product_name, p.product_category, 
RANK() OVER (PARTITION BY p.product_category order by s.price) as "Ranking Cen",
ROW_NUMBER() OVER (PARTITION BY p.product_category order by s.price) AS "Numerowany wiersz",
DENSE_RANK() OVER (PARTITION BY p.product_category order by s.price) as "Ranking Gęsty"
from sales s
inner join products p on s.product_ID = p.product_ID

-- 10. Dla każdego wiersza tabeli sales nazwisko pracownika, nazwa produktu, wartość rosnąca jego sprzedaży według dat (cena produktu * ilość) dla danego pracownika oraz ranking wartości sprzedaży dla kolejnych wierszy globalnie według wartości zamówienia
select e.last_name, p.product_name,
sum(s.price * s.Quantity) OVER (PARTITION by e.employee_ID ORDER BY s.sale_Date),
RANK() OVER (ORDER BY s.price * s.Quantity DESC)
from sales s
inner join products p on s.product_ID = p.product_ID
inner join employees e on e.employee_ID = s.employee_id
ORDER BY e.last_name, s.sale_Date; 

-- 11.	Nie używając funkcji okienkowych wyświetl: Imiona i nazwiska pracowników oraz ich stanowisko, którzy uczestniczyli w sprzedaży.

SELECT DISTINCT e.first_name, e.last_name 
FROM sales s 
INNER JOIN employees e ON s.employee_id = e.employee_id;
