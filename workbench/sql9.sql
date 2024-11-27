create database employeedb;
use employeedb;
CREATE TABLE EMPLOYEE (
  ssn INT PRIMARY KEY,
  first_name VARCHAR(50),
  middle_initial CHAR(1),
  last_name VARCHAR(50),
  address VARCHAR(100),
  sex CHAR(1),
  birth_date DATE,
  status VARCHAR(20),
  salary DECIMAL(10, 2)
);
CREATE TABLE DEPENDENT (
  dependent_id INT PRIMARY KEY,
  ssn INT,
  name VARCHAR(50),
  sex CHAR(1),
  birth_date DATE,
  relationship VARCHAR(50),
  FOREIGN KEY (ssn) REFERENCES EMPLOYEE(ssn)
);
CREATE TABLE PROJECT (
  project_id INT PRIMARY KEY,
  name VARCHAR(100),
  budget DECIMAL(10, 2),
  location VARCHAR(100)
);
CREATE TABLE DEPARTMENT (
  dept_id INT PRIMARY KEY,
  name VARCHAR(100),
  location VARCHAR(100),
  number_of_employees INT
);
CREATE TABLE WORKS (
  ssn INT,
  project_id INT,
  start_date DATE,
  hours INT,
  PRIMARY KEY (ssn, project_id),
  FOREIGN KEY (ssn) REFERENCES EMPLOYEE(ssn),
  FOREIGN KEY (project_id) REFERENCES PROJECT(project_id)
);
CREATE TABLE DEPENDENTS_OF (
  ssn INT,
  dependent_id INT,
  PRIMARY KEY (ssn, dependent_id),
  FOREIGN KEY (ssn) REFERENCES EMPLOYEE(ssn),
  FOREIGN KEY (dependent_id) REFERENCES DEPENDENT(dependent_id)
);
INSERT INTO EMPLOYEE (ssn, first_name, middle_initial, last_name, address, sex, birth_date, status, salary) VALUES
(1, 'John', 'A', 'Doe', '123 Elm St', 'M', '1980-01-01', 'Full-Time', 60000),
(2, 'Jane', 'B', 'Smith', '456 Oak St', 'F', '1985-05-10', 'Full-Time', 65000),
(3, 'Michael', 'C', 'Johnson', '789 Pine St', 'M', '1990-02-15', 'Part-Time', 45000);
INSERT INTO DEPENDENT (dependent_id, ssn, name, sex, birth_date, relationship) VALUES
(1, 1, 'Alice', 'F', '2005-03-20', 'Daughter'),
(2, 1, 'Bob', 'M', '2008-06-15', 'Son'),
(3, 2, 'Charlie', 'M', '2010-11-12', 'Son');
INSERT INTO PROJECT (project_id, name, budget, location) VALUES
(1, 'Project Alpha', 100000, 'New York'),
(2, 'Project Beta', 150000, 'Los Angeles'),
(3, 'Project Gamma', 200000, 'San Francisco');
INSERT INTO DEPARTMENT (dept_id, name, location, number_of_employees) VALUES
(1, 'HR', 'New York', 10),
(2, 'Finance', 'Los Angeles', 15),
(3, 'Engineering', 'San Francisco', 20);
INSERT INTO WORKS (ssn, project_id, start_date, hours) VALUES
(1, 1, '2021-01-01', 40),
(2, 2, '2022-03-15', 35),
(3, 3, '2023-07-20', 30);
INSERT INTO DEPENDENTS_OF (ssn, dependent_id) VALUES
(1, 1),
(1, 2),
(2, 3);
create table manages(
ssn int,
dept_id int,
start_date date,
primary key(ssn,dept_id),
foreign key(ssn) references employee(ssn),
foreign key(dept_id) references department(dept_id));

INSERT INTO MANAGES (ssn, dept_id, start_date) VALUES
(1, 1, '2018-05-01'),
(2, 2, '2019-06-10'),
(3, 3, '2020-11-15');
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPENDENT;
SELECT * FROM PROJECT;
SELECT * FROM DEPARTMENT;
SELECT * FROM WORKS;
SELECT * FROM DEPENDENTS_OF;
SELECT * FROM MANAGES;

-- join 
SELECT E.first_name, E.last_name, P.name AS Project_Name, W.start_date, W.hours
FROM EMPLOYEE E
JOIN WORKS W ON E.ssn = W.ssn
JOIN PROJECT P ON W.project_id = P.project_id
WHERE P.name = 'Project X';

-- store procedure
DELIMITER //

CREATE PROCEDURE GetProjectDetails(IN projectName VARCHAR(100))
BEGIN
    SELECT E.first_name, E.last_name, W.start_date, W.hours
    FROM EMPLOYEE E
    JOIN WORKS W ON E.ssn = W.ssn
    JOIN PROJECT P ON W.project_id = P.project_id
    WHERE P.name = projectName;
END //

DELIMITER ;

call GetProjectDetails('Project Alpha');

-- trigger
DELIMITER $$

CREATE TRIGGER UpdateEmployeeCount
AFTER INSERT ON MANAGES
FOR EACH ROW
BEGIN
   UPDATE DEPARTMENT
   SET number_of_employees = number_of_employees + 1
   WHERE dept_id = NEW.dept_id;
END $$

DELIMITER ;
INSERT INTO EMPLOYEE (ssn, first_name, middle_initial, last_name, address, sex, birth_date, status, salary) VALUES
(4, 'John', 'A', 'Doe', '123 Elm St', 'M', '1980-01-01', 'Full-Time', 60000);

INSERT INTO DEPARTMENT (dept_id, name, location, number_of_employees) VALUES
(4, 'HR', 'New York', 10);
INSERT INTO MANAGES (ssn, dept_id, start_date) VALUES
(4, 4, '2024-02-01');

SELECT * FROM DEPARTMENT;

