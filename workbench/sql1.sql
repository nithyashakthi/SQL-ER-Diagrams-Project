create database faculty;
use faculty;
create table facultyInformation(
id int primary key,
name varchar(50),
department varchar(50),
telephoneNo varchar(15)
);
select *
from facultyInformation;

alter table facultyInformation 
add school varchar(50);

CREATE TABLE CommonUser (
    id INT PRIMARY KEY,
    UserName VARCHAR(50),
    Password VARCHAR(50)
);

CREATE TABLE Administrator (
    id INT PRIMARY KEY,
    UserName VARCHAR(50),
    Password VARCHAR(50)
);

CREATE TABLE TeacherUser (
    id INT PRIMARY KEY,
    UserName VARCHAR(50),
    Password VARCHAR(50)
);


CREATE TABLE Inquiry (
    FacultyId INT,
    CommonUserId INT,
    FOREIGN KEY (FacultyId) REFERENCES FacultyInformation(id),
    FOREIGN KEY (CommonUserId) REFERENCES CommonUser(id),
    PRIMARY KEY (FacultyId, CommonUserId)
);

CREATE TABLE Service (
    FacultyId INT,
    AdministratorId INT,
    FOREIGN KEY (FacultyId) REFERENCES FacultyInformation(id),
    FOREIGN KEY (AdministratorId) REFERENCES Administrator(id),
    PRIMARY KEY (FacultyId, AdministratorId)
);

CREATE TABLE Modify (
    FacultyId INT,
    TeacherUserId INT,
    FOREIGN KEY (FacultyId) REFERENCES FacultyInformation(id),
    FOREIGN KEY (TeacherUserId) REFERENCES TeacherUser(id),
    PRIMARY KEY (FacultyId, TeacherUserId)
);

DELIMITER //
CREATE PROCEDURE InsertFaculty (
    IN faculty_id INT,
    IN faculty_name VARCHAR(50),
    IN faculty_dept VARCHAR(50),
    IN faculty_tel VARCHAR(15),
	IN faculty_school VARCHAR(50)
)
BEGIN
    INSERT INTO FacultyInformation (id, Name, Department,
    TelephoneNo,school)
    VALUES (faculty_id, faculty_name, faculty_dept,
    faculty_tel, faculty_school);
END //
DELIMITER ;
call insertFaculty(101, 'John Doe', 'Computer Science',  '1234567890','Engineering');
call insertFaculty(103, 'Jane Smith', 'Mathematics', '9876543210','Science');
call insertfaculty(105, 'Emily Davis', 'Chemistry', '7891234560', 'Science');


select *from facultyInformation;
delete from facultyInformation where id=1;

INSERT INTO CommonUser (id, UserName, Password)
VALUES 
(101, 'common_user1', 'password123'),
(102, 'common_user2', 'password456'),
(103, 'common_user3', 'password789'),
(104, 'common_user4', 'password101');

INSERT INTO CommonUser (id, UserName, Password)
VALUES 
(105, 'common_user5', 'password105');
delete from CommonUser where id in(1,2,3,4);

INSERT INTO Administrator (id, UserName, Password)
VALUES 
(101, 'admin_user1', 'adminpass123'),
(102, 'admin_user2', 'adminpass456'),
(103, 'admin_user3', 'adminpass789'),
(104, 'admin_user4', 'adminpass101');
INSERT INTO Administrator (id, UserName, Password)
VALUES 
(105, 'admin_user5', 'adminpass105');

INSERT INTO TeacherUser (id, UserName, Password)
VALUES 
(101, 'teacher_user1', 'teachpass123'),
(102, 'teacher_user2', 'teachpass456'),
(103, 'teacher_user3', 'teachpass789'),
(104, 'teacher_user4', 'teachpass101');
INSERT INTO TeacherUser (id, UserName, Password)
VALUES 
(105, 'teacher_user5', 'teachpass105');

-- Insert records into Inquiry table
INSERT INTO Inquiry (FacultyId, CommonUserId)
VALUES 
(101, 101),
(102, 102),
(103,103),
(104,104),
(105,105);

-- Insert records into Modify table
INSERT INTO Modify (FacultyId, TeacherUserId)
VALUES 
(101, 101),
(102, 102),
(103,103),
(104,104),
(105,105);

-- Insert records into Service table
INSERT INTO Service (FacultyId, AdministratorId)
VALUES 
(101, 101),
(102, 102),
(103,103),
(104,104),
(105,105);

select *from commonuser;
select*from administrator;
select *from teacheruser;
select*from inquiry;
select*from modify;
select*from service;

-- join conditions
--  Verify FacultyInformation with Inquiry and CommonUser
SELECT 
    f.id AS FacultyId,
    f.Name AS FacultyName,
    c.id AS CommonUserId,
    c.UserName AS CommonUserName
FROM 
    Inquiry i
JOIN 
    FacultyInformation f ON i.FacultyId = f.id
JOIN 
    CommonUser c ON i.CommonUserId = c.id;
-- Verify Modify Relationship with FacultyInformation and TeacherUser
SELECT 
    f.id AS FacultyId,
    f.Name AS FacultyName,
    t.id AS TeacherUserId,
    t.UserName AS TeacherUserName
FROM 
    Modify m
JOIN 
    FacultyInformation f ON m.FacultyId = f.id
JOIN 
    TeacherUser t ON m.TeacherUserId = t.id;
    
-- Verify Service Relationship with FacultyInformation and Administrator 
SELECT 
    f.id as ServiceId, 
    f.id AS FacultyId, 
    f.Name AS FacultyName, 
    f.Department AS FacultyDepartment, 
    a.id AS AdministratorId, 
    a.UserName AS AdministratorName
FROM 
    Service s
JOIN 
    FacultyInformation f ON s.FacultyId = f.id
JOIN 
    Administrator a ON s.AdministratorId = a.id;