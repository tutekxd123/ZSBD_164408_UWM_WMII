--Zadanie 1

DROP TABLE EMPLOYEES CASCADE constraints;
DROP TABLE JOBS CASCADE constraints;
DROP TABLE JOB_HISTORY CASCADE constraints;
DROP TABLE DEPARTMENTS CASCADE constraints;
DROP TABLE LOCATIONS CASCADE constraints;
DROP TABLE COUNTRIES CASCADE constraints;
DROP TABLE REGIONS CASCADE constraints;



-- Zadanie 2
CREATE TABLE DEPARTMENTS as select * from HR.DEPARTMENTS;
CREATE TABLE EMPLOYEES as select * from HR.EMPLOYEES;
CREATE TABLE JOBS as select * from HR.JOBS;
CREATE TABLE JOB_GRADES as select * from HR.JOB_GRADES;
CREATE TABLE JOB_HISTORY as select * from HR.JOB_HISTORY;
CREATE TABLE LOCATIONS as select * from HR.LOCATIONS;
CREATE TABLE PRODUCTS as select * from HR.PRODUCTS;
CREATE TABLE REGIONS as select * from HR.REGIONS;
CREATE TABLE SALES as select * from HR.SALES;
CREATE TABLE COUNTRIES as select * from HR.COUNTRIES

-- Pierwsze co Klucze główne
ALTER TABLE JOB_HISTORY
    ADD PRIMARY KEY (EMPLOYEE_ID,START_DATE,JOB_ID);

ALTER TABLE COUNTRIES
	ADD PRIMARY KEY (COUNTRY_ID);

ALTER TABLE DEPARTMENTS
	ADD PRIMARY KEY (DEPARTMENT_ID);

ALTER TABLE EMPLOYEES
	ADD PRIMARY KEY (EMPLOYEE_ID);

ALTER TABLE JOBS
	ADD PRIMARY KEY (JOB_ID);

ALTER TABLE LOCATIONS
	ADD PRIMARY KEY (LOCATION_ID);

ALTER TABLE PRODUCTS
	ADD PRIMARY KEY (PRODUCT_ID);

ALTER TABLE REGIONS
	ADD PRIMARY KEY (REGION_ID);

ALTER TABLE SALES
	ADD PRIMARY KEY(SALE_ID);




-- Klucze Obce

ALTER TABLE JOB_HISTORY
	ADD CONSTRAINT fk_job_history_job FOREIGN KEY (job_id) REFERENCES JOBS(job_id) ON DELETE CASCADE;

ALTER TABLE JOB_HISTORY
	ADD CONSTRAINT Fk_job_history_employ FOREIGN KEY (employee_ID) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE;



ALTER TABLE DEPARTMENTS
	ADD CONSTRAINT fk_departments_manger FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id) ON DELETE SET NULL;

ALTER TABLE DEPARTMENTS
	ADD CONSTRAINT fk_department_location FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);

ALTER TABLE LOCATIONS
	ADD CONSTRAINT fk_locations_country FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id);

ALTER TABLE COUNTRIES
	ADD CONSTRAINT fk_countries_region FOREIGN KEY (region_id) REFERENCES REGIONS(region_id);


ALTER TABLE EMPLOYEES
	ADD CONSTRAINT fk_employees_managerID FOREIGN KEY (manager_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID) ON DELETE SET NULL;

ALTER TABLE EMPLOYEES
	ADD constraint FK_EMPLOYEES_Department FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID) ON DELETE SET NULL;

ALTER TABLE SALES
	ADD constraint FK_SALES_EMPLOYEES FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE SALES
	ADD CONSTRAINT FK_SALES_PRODUCT FOREIGN KEY(PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID);

-- Zadanie 3 (główne)
--Podzadanie 1
SELECT CONCAT(CONCAT(LAST_NAME,' '),SALARY) AS "Wynagrodzenie" FROM EMPLOYEES
where EMPLOYEES.DEPARTMENT_ID IN (20,50) and SALARY BETWEEN 2000 AND 7000
ORDER BY LAST_NAME ASC;

--Podzadanie2
SELECT hire_date, last_name, &kolumnaUser
FROM employees
WHERE manager_id IS NOT NULL
  AND EXTRACT(YEAR FROM hire_date) = 2005
ORDER BY &kolumnaUser;

--Podzadanie3
SELECT CONCAT(CONCAT(FIRST_NAME, ' '),LAST_NAME) as "Imie i Nazwisko",SALARY,PHONE_NUMBER FROM EMPLOYEES
WHERE SUBSTR(LAST_NAME,3,1)='e' and FIRST_NAME LIKE '%&imiefragment%'
ORDER BY "Imie i Nazwisko" DESC, SALARY ASC;

--PodZadanie4
SELECT FIRST_NAME, LAST_NAME,ROUND(months_between(CURRENT_DATE,HIRE_DATE)) AS "Liczba_miesiecy_przepracowanych",
case 
    when ROUND(months_between(CURRENT_DATE,HIRE_DATE))<=150 then (salary/100)*10
    when ROUND(months_between(CURRENT_DATE,HIRE_DATE)) BETWEEN 150 and 200 then (salary/100)*20
    when ROUND(months_between(CURRENT_DATE,HIRE_DATE))>=200 then (salary/100)*30
end as "Wysokość_Dodatku"
from EMPLOYEES
ORDER BY "Liczba_miesiecy_przepracowanych";

--PodZadanie 5


SELECT * FROM (
select d.DEPARTMENT_NAME, min(salary) as "min_salary", ROUND(avg(salary)) as "srednia" from employees
inner join departments d on d.department_ID = employees.department_id
group by d.DEPARTMENT_NAME) d1
where d1."min_salary">=5000;

--PodZadanie 6

select e1.last_name, e1.department_ID,d.DEPARTMENT_NAME, e1.job_ID from employees e1
inner join departments d on d.DEPARTMENT_ID = e1.DEPARTMENT_ID 
inner join locations l on d.location_id=l.location_id
where l.City = 'Toronto';

--PodZadanie 7
--Teoretycznie pracuja sami ze soba, nie wiem czy to wypisywac, ale niech bedzie

select e1.first_name, e1.last_name,e2.first_name,e2.last_name from employees e1
inner join employees e2 on e1.DEPARTMENT_ID = e2.DEPARTMENT_ID
where e1.first_name='Jennifer';

----PodZadanie 8

select d.department_ide from DEPARTMENTS d
left join employees e1 on e1.DEPARTMENT_ID = d.department_ID
where e1.EMPLOYEE_ID is NULL;

---PodZadanie 9
select e1.first_name, e1.job_id,d.department_name,e1.salary,j.grade from employees e1
inner join departments d on e1.department_id=d.department_id
inner join JOB_GRADES j on e1.salary BETWEEN j.min_salary and j.max_salary;

--PodZadanie 10
select e1.first_name, e1.last_name, salary from employees e1
where salary >(select avg(employees.salary) from employees )
order by salary DESC;

--PodZadanie 11
select DISTINCT e1.EMPLOYEE_ID,e1.first_name,e1.last_name from employees e1
inner join employees e2 on e2.department_id=e1.department_id and e2.last_name LIKE '%n%';

--PodZadanie 12
select employees.first_name,employees.last_name, ROUND(CURRENT_DATE-HIRE_DATE) from employees
where CURRENT_DATE-HIRE_DATE >= (select  AVG(ROUND(CURRENT_DATE-HIRE_DATE)) FROM EMPLOYEES);

--PodZadanie 13
select d.DEPARTMENT_NAME, COUNT(*) as "Liczba Pracowników", ROUND(AVG(salary)) as "Średnie Wynagrodzenie" from departments d
inner join employees e on e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.department_name
order by COUNT(*) DESC;

--PodZadanie 14
select first_name, last_name from employees
where salary<=(
select min(salary) from departments d
inner join employees e on e.department_id=d.department_id and d.department_name='IT');
--PodZadanie 15
select d. department_id,d.department_name from departments d
inner join employees e on e.department_id = d.department_id and e.salary>=(select avg(salary) from employees)
group by d.department_id, d.department_name;

--Podzapytanie 16
select * from (

select d.department_name,ROUND(avg(e.salary)) as "srednie_zarobki" from departments d
inner join employees e on e.department_id=d.department_id
group by d.department_name ) d1
order by d1."srednie_zarobki" DESC

FETCH FIRST 5 ROWS ONLY;

--PodZapytanie 17

-- JOIN EXplosion (jezeli pracownicy nie maja department to nie maja lokalizacji)
select r.REGION_NAME,COUNT( DISTINCT  c.country_name) as "Liczba krajów", c.country_name from regions r
inner join countries c on c.REGION_ID = r.REGION_ID
inner join locations l on l.country_ID = c.country_id
inner join departments d on d.location_id = l.location_id
inner join employees e on e.department_id = d.department_id
group by r.REGION_NAME

--Podzapytanie 18
select e1.first_name, e1.last_name from employees e1
inner join employees e2 on e1.manager_id=e2.employee_id
where e1.salary>e2.salary
--PodZapytanie 19
select to_char(hire_date,'Month'), count(*) from employees
group by to_char(hire_date,'Month')
--Podzapytanie 20
select * from (select d.department_name,ROUND(AVG(salary)) as "srednie wynagrodzenie" from departments d
inner join employees e on e.department_id= d.department_id
group by d.department_name) d1

order by d1."srednie wynagrodzenie" DESC
FETCH FIRST 3 ROWS ONLY



