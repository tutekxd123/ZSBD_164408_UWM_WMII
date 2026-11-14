//1. Utwórz widok v_wysokie_pensje, dla tabeli employees, który pokaże wszystkich pracowników zarabiających więcej niż 6000.
create view "v_wysokie_pensje" as 
select * from employees e
where e.salary>=6000;

//2. Zmień definicję widoku v_wysokie_pensje, aby pokazywał  tylko pracowników zarabiających powyżej  12000

CREATE OR REPLACE view "v_wysokie_pensje" as 
select * from employees e
where e.salary>=12000;

//3.	Usuń widok v_wysokie_pensje.
drop view "v_wysokie_pensje";


//4.	Stwórz widok dla tabeli employees zawierający: employee_id, last_name, first_name, dla pracowników z departamentu o nazwie Finance
CREATE VIEW "v_Finance_Employees" as 

select e.employee_id, e.last_Name, e.first_name,d.department_name from employees e
inner join departments d on e.department_ID = d.department_Id
where d.department_name = 'Finance';

//5.	Stwórz widok dla tabeli employees zawierający: employee_id, last_name, first_name, salary, job_id, email, hire_date dla pracowników mających zarobki pomiędzy 5000 a 12000.
CREATE VIEW "v_salary_between_5000_12000" as 
select e.employee_id, e.last_name, e.first_name, e.salary, e.job_id, e.email, e.hire_date from employees e
where e.salary between 5000 and 12000;

//6.	Poprzez utworzone  widoki sprawdź, czy możesz:
//a.	dodać nowego pracownika
//b.	edytować  pracownika
//c.	usunąć pracownika


insert into "v_Finance_Employees"(EMPLOYEE_ID,LAST_NAME,FIRST_NAME,DEPARTMENT_NAME) VALUES (999,'tutek','test','Finance'); //Nie działa bo nie mozna modyfikowac 2 tabel jednoczesnie

update "v_Finance_Employees" set LAST_NAME = 'test' where EMPLOYEE_ID=108; //Działa

delete from "v_Finance_Employees" where EMPLOYEE_ID=108 //działa

INSERT into "v_salary_between_5000_12000"(employee_id, last_name, first_name, salary, job_id, email, hire_date) VALUES (999,'test','test',90000,2,'test@gmail.com',CURRENT_TIMESTAMP); //działa
delete from "v_salary_between_5000_12000" where EMPLOYEE_ID=1 //działa

update "v_salary_between_5000_12000" set LAST_NAME = 'test' where EMPLOYEE_ID=999; //Działa

//7.	Stwórz widok, który dla każdego działu zatrudnia przynajmniej 4 pracowników, wyświetli: identyfikator działu, nazwę działu, liczbę pracowników w dziale,  średnią pensję w dziale i najwyższa pensja w dziale.
//a.	Sprawdź, czy możesz dodać dane do tego widoku.


CREATE VIEW "v_departments_count_employees" as (
select d.DEPARTMENT_ID, d.DEPARTMENT_NAME, COUNT(*) as "Liczba pracownikow", ROUND(avg(e.salary)) as "średnia wypłata" from departments d
inner join employees e on e.department_id = d.department_id
group BY d.DEPARTMENT_ID, d.DEPARTMENT_NAME
HAVING COUNT(*)>4)

insert into "v_departments_count_employees" (DEPARTMENT_ID,DEPARTMENT_NAME,"Liczba pracownikow","średnia wypłata") VALUES(101,'Finance2',3,3000); //nie można modyfikować kolumny, która odwzorowuje się do tabeli nie zachowującej kluczy
