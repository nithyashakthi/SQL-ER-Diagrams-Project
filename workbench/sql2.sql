create database hospitaldb;
use hospitaldb;

create table hospital(
hosid int primary key,
hname varchar(50),
haddress varchar(115),
hcity varchar(25)
);

create table patient(
pat_id int primary key,
pname varchar(50) not null,
pdiagnosis varchar(100)not null,
paddress varchar(115),
hosid int,
foreign key(hosid)references hospital(hosid)
);

create table doctor(
docid int primary key,
dname varchar(50) not null,
qualifictaion varchar(100),
salary decimal(10,2),
hosid int,
foreign key (hosid) references hospital(hosid)
);
create table medicalrecord(
precordid int primary key,
date_of_examination date,
problem varchar(200),
patid int ,
foreign key (patid) references patient(pat_id)
);

select*from hospital;
insert into hospital(hosid,hname,haddress,hcity) values
(1,'city hospital','123main set','new york'),
(2,'green valley hospita','345 oak ave','los angeles'),
(3,'sunrise hospital','789 pine set','chicago');

insert into patient (pat_id,pname,pdiagnosis,paddress,hosid) values
(101,'john','diabetes','123 main st',1),
(102,'jane smith','hypertension','200 pine set',2),
(103,'robert brown','asthma','300 maple st',1);

INSERT INTO Doctor (Docid, DName,qualifictaion, Salary, Hosid) VALUES
 (201, 'Dr. Alice Johnson', 'MD - Cardiology', 150000, 1), 
(202, 'Dr. Mark Wilson', 'MD - Neurology', 130000, 2),
 (203, 'Dr. Sarah Lee', 'MD - Pediatrics', 120000, 1);
 
 INSERT INTO MedicalRecord (precordid, Date_of_examination, Problem, patid) 
VALUES 
(301, '2024-09-01', 'Routine Check-up', 101),
(302, '2024-09-10', 'Blood Pressure Monitoring', 102),
(303, '2024-09-15', 'Asthma Attack Treatment', 103);

SELECT * FROM Hospital;
SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM MedicalRecord;

select h.hname,p.pat_id,p.pname,p.pdiagnosis
from patient as p
join hospital as h on p.hosid=h.hosid;

select d.docid,d.dname,d.qualifictaion,d.salary,h.hname,h.hcity
from doctor  as d
join hospital h on d.hosid=h.hosid;

DELIMITER //
CREATE TRIGGER PreventLowSalaryDoctor
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    -- If the new doctor's salary is less than 100,000, raise an error
    IF NEW.salary < 100000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor salary must be at least 100,000.';
    END IF;
END //
DELIMITER ;

-- This should fail since the salary is less than 100,000
INSERT INTO Doctor (docid, dname, qualifictaion, salary, hosid)
VALUES (204, 'Dr. Test', 'Test Qualification', 90000, 1);





