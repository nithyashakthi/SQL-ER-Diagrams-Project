CREATE DATABASE UniversityDB;
USE UniversityDB;

-- Create Student Table
CREATE TABLE Student (
    MIS INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Address VARCHAR(100),
    BirthDate DATE
);

-- Create Admission Table
CREATE TABLE Admission (
    Student_Num INT,
    Date_of_Enrollment DATE,
    Course_Name VARCHAR(100),
    PRIMARY KEY (Student_Num),
    FOREIGN KEY (Student_Num) REFERENCES Student(MIS)
);

-- Create TimeTable Table
CREATE TABLE TimeTable (
    Attribute INT AUTO_INCREMENT PRIMARY KEY,
    Time TIME,
    Date DATE,
    TeacherName VARCHAR(100)
);

-- Create Lecturer Table
CREATE TABLE Lecturer (
    email VARCHAR(100) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Address VARCHAR(100)
);

-- Create Subjects Table
CREATE TABLE Subjects (
    SubjectCode INT PRIMARY KEY,
    SubjectUnit VARCHAR(100),
    LecturerEmail VARCHAR(100),
    FOREIGN KEY (LecturerEmail) REFERENCES Lecturer(email)
);
-- Insert records into Student
INSERT INTO Student (MIS, FirstName, LastName, Address, BirthDate) 
VALUES (1, 'John', 'Doe', '123 Main St', '2000-01-15'),
       (2, 'Jane', 'Smith', '456 Oak St', '2001-03-22'),
       (3, 'Alice', 'Johnson', '789 Pine St', '1999-06-10');

-- Insert records into Admission
INSERT INTO Admission (Student_Num, Date_of_Enrollment, Course_Name)
VALUES (1, '2020-09-01', 'Computer Science'),
       (2, '2021-01-10', 'Mathematics'),
       (3, '2020-09-01', 'Physics');

-- Insert records into TimeTable
INSERT INTO TimeTable (Time, Date, TeacherName) 
VALUES ('09:00:00', '2024-01-01', 'Dr. Brown'),
       ('11:00:00', '2024-01-01', 'Prof. Green'),
       ('13:00:00', '2024-01-01', 'Ms. White');

-- Insert records into Lecturer
INSERT INTO Lecturer (email, FirstName, LastName, Address) 
VALUES ('brown@university.edu', 'Robert', 'Brown', '101 Elm St'),
       ('green@university.edu', 'Linda', 'Green', '202 Birch St'),
       ('white@university.edu', 'Helen', 'White', '303 Cedar St');

-- Insert records into Subjects
INSERT INTO Subjects (SubjectCode, SubjectUnit, LecturerEmail) 
VALUES (101, 'Database Systems', 'brown@university.edu'),
       (102, 'Calculus', 'green@university.edu'),
       (103, 'Physics 101', 'white@university.edu');

SELECT * FROM Student;
SELECT * FROM Admission;
SELECT * FROM TimeTable;
SELECT * FROM Lecturer;
SELECT * FROM Subjects;

-- join Query 1: Join Student and Admission
SELECT s.FirstName, s.LastName, a.Course_Name, a.Date_of_Enrollment
FROM Student s
JOIN Admission a ON s.MIS = a.Student_Num;
-- Join Lecturer and Subjects
SELECT l.FirstName, l.LastName, s.SubjectUnit
FROM Lecturer l
JOIN Subjects s ON l.email = s.LecturerEmail;
-- Join Student, Admission, and TimeTable
SELECT st.FirstName, st.LastName, ad.Course_Name, tt.TeacherName, tt.Date
FROM Student st
JOIN Admission ad ON st.MIS = ad.Student_Num
JOIN TimeTable tt ON tt.TeacherName = 'Dr. Brown'; -- You can modify this to match other relationships

DELIMITER //

CREATE PROCEDURE GetStudentCourses()
BEGIN
    SELECT s.FirstName, s.LastName, a.Course_Name
    FROM Student s
    JOIN Admission a ON s.MIS = a.Student_Num;
END //

DELIMITER ;

call GetStudentCourses();
-- trigger
DELIMITER //

CREATE TRIGGER Check_BirthDate_Before_Update
BEFORE UPDATE ON Student
FOR EACH ROW
BEGIN
    IF NEW.BirthDate > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'BirthDate cannot be a future date.';
    END IF;
END //

DELIMITER ;
SELECT * FROM Student;
UPDATE Student SET BirthDate = '2025-01-01' WHERE MIS = 1;  -- BirthDate cannot be a future date.
UPDATE Student SET BirthDate = '1999-12-31' WHERE MIS = 1;

