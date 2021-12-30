-- -----------------------------------------------------
-- Schema ClassAssignment
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ClassAssignment` ;

-- -----------------------------------------------------
-- Schema ClassAssignment
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ClassAssignment` DEFAULT CHARACTER SET utf8 ;
USE `ClassAssignment` ;

-- -----------------------------------------------------
-- Table `ClassAssignment`.`Project`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ClassAssignment`.`Project` (
  project_num INT NOT NULL,
  project_code CHAR(4),
  project_title VARCHAR(45),
  first_name VARCHAR(45), 
  last_name VARCHAR(45),  
  project_budget DECIMAL(5,2),
  PRIMARY KEY(project_num)
);

-- -----------------------------------------------------
-- Table `ClassAssignment`.`PayRoll`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ClassAssignment`.`PayRoll` (
  employee_num INT AUTO_INCREMENT,
  job_id INT NOT NULL,
  job_desc VARCHAR(40), 
  emp_pay DECIMAL(10,2),
  PRIMARY KEY(employee_num)
);

-- -----------------------------------------------------
-- Table `ClassAssignment`.`Project_backup`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `ClassAssignment`.`Project_backup` (
  project_num INT NOT NULL,
  project_code CHAR(4),
  project_title VARCHAR(45),
  first_name VARCHAR(45), 
  last_name VARCHAR(45),  
  project_budget DECIMAL(10,2),
  PRIMARY KEY(project_num)
);
-- ------------------------------------------------------------
-- FINAL EXAM STUFF
-- ------------------------------------------------------------
USE `ClassAssignment` ;
DROP TABLE IF EXISTS T1;
CREATE TABLE T1 (
C1 INT(10) unique not null,
C2 INT(10),
C3 INT(10),
C4 VARCHAR(40) DEFAULT 'HR',
PRIMARY KEY (C1),
CONSTRAINT C2 CHECK (C2 > C3),
CONSTRAINT C3 CHECK (C3 > 0)
);

DROP TABLE IF EXISTS T2;
CREATE TABLE T2(
C5 int(10) unique not null,
C6 int(10) not null,
FOREIGN KEY (C6) REFERENCES T1(C1),
PRIMARY KEY (C5)
);

DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees(
EmpID int(10) unique not null,
ManagerID int(10),
Name VarChar(45),
Department VarChar(45),
Salary int,
City VarChar(45)
);
INSERT INTO Employees VALUES (1,0,'Alex Smith', 'Admin', 90000, 'Boulder');
INSERT INTO Employees VALUES (2,1,'Amy Mars', 'Admin', 50000, 'Longmont');
INSERT INTO Employees VALUES (3,1,'Logan Mars', 'Admin', 70000, 'Longmont');
INSERT INTO Employees VALUES (4,1,'James Mont', 'Marketing', 55000, NULL);
INSERT INTO Employees VALUES (5,6,'John Smith', 'Marketing', 60000, 'Boulder');
INSERT INTO Employees VALUES (6,1,'Lily Mars', 'Marketing', 95000, NULL);
INSERT INTO Employees VALUES (7,6,'Ravi Grace', 'DataBase', 75000, 'Longmont');
INSERT INTO Employees VALUES (8,6,'Tara Frank', 'DataBase', 80000, 'Longmont');
INSERT INTO Employees VALUES (9,6,'Tom Ford', 'DataBase', 65000, NULL);
INSERT INTO Employees VALUES (10,6,'William Cruze', 'DataBase', 85000, 'Longmont');

select * from Employees;

select Name, Salary from Employees
order by salary desc
limit 4,1;

select Department, Count(*) as 'Employee Count' from Employees
group by department
having Count(*) > 3;


Update Employees
set City = 'Broomfield'
where City is NULL;
select Name, Department, City from Employees;

select distinct A.Name from employees A
inner join Employees B on A.EmpID = B.ManagerID;


select max(Salary) as 'max salary', 
min(Salary) 'min salary', round(avg(Salary),2) 'Average salary'
from employees;

select Name, Department, Salary from Employees
where Salary > (select avg(salary) from Employees);

select Name, Department, Salary, 
Rank() Over( PARTITION BY Department order by salary Desc) as 'Rank'
From Employees;

select Name, Salary
from Employees
where EmpID = (Select ManagerID from Employees 
group by ManagerID
order by Sum(Salary) desc Limit 1);






















-- ----------------------------------------- 
-- Altering/Modifying the project table
-- ----------------------------------------- 
ALTER TABLE project
MODIFY COLUMN project_num INT NOT NULL AUTO_INCREMENT;

ALTER TABLE Project AUTO_INCREMENT = 10;

ALTER TABLE project
MODIFY COLUMN project_budget DECIMAL(10,2);

INSERT INTO Project (project_code, project_title, first_name, last_name, project_budget)
					VALUES 	('PC01', 'DIA', 'John', 'Smith', 10000.99),
							('PC02', 'CHF', 'Tim', 'Cook', 12000.50),
                            ('PC03', 'AST', 'Rhonda', 'Smith', 8000.40);
                            
select * from Project;
-- ----------------------------------------- 
-- Altering/Modifying the pay roll table
-- ----------------------------------------- 
ALTER TABLE PayRoll
ADD CONSTRAINT min_pay CHECK (emp_pay > 10000);

ALTER TABLE PayRoll
Alter COLUMN job_desc SET DEFAULT 'Data Analyst';

ALTER TABLE PayRoll
Add COLUMN pay_date DATE after job_desc;


ALTER TABLE PayRoll
ADD FOREIGN KEY (job_id) REFERENCES Project(project_num);

INSERT INTO PayRoll (job_id, pay_date, emp_pay)
					VALUES 	(10, '2021-10-10',12000.99),
							(11, '2021-10-10',14000.99),
                            (12, '2021-10-10',16000.99);

UPDATE PayRoll
SET emp_pay = (emp_pay * 1.1) 
where employee_num = 2;


INSERT INTO Project_backup 
SELECT * from Project 
where last_name = "Smith";


CREATE VIEW Payroll_View
AS SELECT job_id,job_desc,pay_date
FROM PAYROLL
where job_id > 10;

CREATE INDEX pay_date
ON PayRoll(pay_date);


DELETE FROM Project_backup;

DELETE FROM PayRoll WHERE job_id = 10;
DELETE FROM Project WHERE project_num = 10;

select * from Project;





