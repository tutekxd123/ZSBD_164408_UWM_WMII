CREATE TABLE EMPLOYEES(
	employee_id INT NOT NULL PRIMARY KEY,
	first_name VARCHAR2(200) NOT NULL,
	last_name VARCHAR2(200) NOT NULL,
	email VARCHAR2(200) NOT NULL,
	phone_number VARCHAR2(30) NOT NULL,
	hire_date DATE NOT NULL,
	job_id INT,
	salary NUMBER(20,2) DEFAULT 0,
	commission_pct INT NOT NULL,
	manager_id INT,
	department_ID INT
);
CREATE TABLE JOBS(
	job_id INT NOT NULL PRIMARY KEY,
	job_title VARCHAR2(200) NOT NULL,
	max_salary NUMBER(20,2) NOT NULL,
	min_salary NUMBER(20,2) NOT NULL CHECK(min_salary<=max_salary-2000)
);
CREATE TABLE JOB_HISTORY(
	employee_ID INT NOT NULL,
	start_date DATE NOT NULL DEFAULT NOW(),
	end_date DATE,
	job_id INT,
	department_ID INT NOT NULL,
	PRIMARY KEY (employee_ID, start_date,job_id,end_date)
);
CREATE TABLE DEPARTMENTS(
	department_id INT NOT NULL,
	department_name VARCHAR2(200) NOT NULL,
	manager_id int DEFAULT NULL,
	location_id int DEFAULT NULL
)
CREATE TABLE LOCATIONS(
	location_id INT PRIMARY KEY NOT NULL,
	street_address VARCHAR2(200) NOT NULL,
	postal_code VARCHAR2(30) NOT NULL,
	city VARCHAR2(130) NOT NULL,
	state_province VARCHAR2(55) NOT NULL,
	country_id INT NOT NULL

);
CREATE TABLE COUNTRIES(
	country_id INT PRIMARY KEY NOT NULL,
	country_name VARCHAR2(40) NOT NULL,
	region_id INT NOT NULL
)
CREATE TABLE REGIONS(
	region_id INT PRIMARY KEY NOT NULL,
	region_name VARCHAR(50) NOT NULL
)











