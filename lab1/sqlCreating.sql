CREATE TABLE EMPLOYEES(
	employee_id INT NOT NULL PRIMARY KEY,
	first_name VARCHAR2(200) NOT NULL,
	last_name VARCHAR2(200) NOT NULL,
	email VARCHAR2(200) NOT NULL,
	phone_number VARCHAR2(30) NOT NULL,
	hire_date DATE DEFAULT CURRENT_DATE NOT NULL,
	job_id INT,
	salary DECIMAL(20,2) DEFAULT 0,
	commission_pct DECIMAL(4,2) NOT NULL,
	manager_id INT,
	department_ID INT
);
-- OK!


CREATE TABLE JOBS(
	job_id INT NOT NULL PRIMARY KEY,
	job_title VARCHAR2(200) NOT NULL,
	max_salary DECIMAL(20,2) NOT NULL,
	min_salary DECIMAL(20,2) NOT NULL,
    CONSTRAINT checkSalaryMin CHECK (min_salary<=max_salary-2000)
);
-- OK
CREATE TABLE JOB_HISTORY(
	employee_ID INT NOT NULL,
	start_date DATE DEFAULT CURRENT_DATE NOT NULL,
	end_date DATE,
	job_id INT,
	department_ID INT NOT NULL,
	PRIMARY KEY (employee_ID, start_date,job_id,end_date)
);
-- OK
CREATE TABLE DEPARTMENTS(
	department_id INT PRIMARY KEY NOT NULL,
	department_name VARCHAR2(200) NOT NULL,
	manager_id int DEFAULT NULL,
	location_id int DEFAULT NULL
);
-- OK
CREATE TABLE LOCATIONS(
	location_id INT PRIMARY KEY NOT NULL,
	street_address VARCHAR2(200) NOT NULL,
	postal_code VARCHAR2(30) NOT NULL,
	city VARCHAR2(130) NOT NULL,
	state_province VARCHAR2(55) NOT NULL,
	country_id INT NOT NULL

);
-- OK
CREATE TABLE COUNTRIES(
	country_id INT PRIMARY KEY NOT NULL,
	country_name VARCHAR2(40) NOT NULL,
	region_id INT NOT NULL
);
-- OK
CREATE TABLE REGIONS(
	region_id INT PRIMARY KEY NOT NULL,
	region_name VARCHAR(50) NOT NULL
);
-- Teraz Pora na klucze obce
ALTER TABLE EMPLOYEES
    ADD CONSTRAINT fk_EMPLOYEES_MANAGER_ID
        FOREIGN KEY (manager_Id)
        REFERENCES EMPLOYEES(employee_id) ON DELETE SET NULL;

ALTER TABLE EMPLOYEES
    ADD CONSTRAINT fk_job_id
        FOREIGN KEY (job_id)
        REFERENCES JOBS(job_id);

ALTER TABLE EMPLOYEES
    ADD CONSTRAINT fk_DEPARTMENT_ID
        FOREIGN KEY (DEPARTMENT_ID)
        REFERENCES DEPARTMENTS(DEPARTMENT_ID) ON DELETE SET NULL;

-- OK

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


-- ZAD 2 INSERT 4 JOBS

INSERT INTO JOBS(job_id,job_title,max_salary, min_salary) VALUES (1,'CEO',90000,80000);
INSERT INTO JOBS(job_id,job_title,max_salary, min_salary) VALUES (2,'Enginner Software',20000,15000);
INSERT INTO JOBS(job_id,job_title,max_salary, min_salary) VALUES (3,'Tester Software',20000,15000);
INSERT INTO JOBS(job_id,job_title,max_salary, min_salary) VALUES (4,'accountant',7000,5000);

-- ZAD 3 Insert 4 EMPLOYES
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_ID)
	VALUES (1,'Piotr','Marzec','TJMBH!@gmail.com','+48601904692',DEFAULT,1,90000,1,NULL,NULL);

INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_ID)
	VALUES (2,'Pawel','Marzec','TJMBH!MLAS@gmail.com','+48601904231',DEFAULT,1,70000,1,NULL,NULL);

INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_ID)
	VALUES (3,'Kowal','Kowalczyk','tutsonmarima@protonmail.com','+48501904231',DEFAULT,2,15000,0,1,NULL);
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_ID)
	VALUES (4,'Marlena','Górska','marzena1992@wp.pl','+48501954231',DEFAULT,3,8000,0,2,NULL);









