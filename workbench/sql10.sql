-- Create Database
CREATE DATABASE GymManagement;
USE GymManagement;

-- Create Tables
CREATE TABLE Member (
    Mem_ID INT PRIMARY KEY,
    Mem_Name VARCHAR(50),
    Mem_Contact VARCHAR(15),
    Mem_Address VARCHAR(100),
    Mem_Email VARCHAR(50)
);

CREATE TABLE Trainer (
    Tr_ID INT PRIMARY KEY,
    Tr_Name VARCHAR(50),
    Tr_Contact VARCHAR(15),
    Tr_Address VARCHAR(100)
);

CREATE TABLE Equipment (
    Eq_ID INT PRIMARY KEY,
    Eq_Name VARCHAR(50),
    Eq_Type VARCHAR(50)
);

CREATE TABLE TrainingSchedule (
    Sess_ID INT PRIMARY KEY,
    Sess_Date DATE,
    Sess_Time TIME,
    Sess_Duration INT,
    Sess_Details VARCHAR(200)
);

CREATE TABLE Fee (
    F_ID INT PRIMARY KEY,
    F_Amount DECIMAL(10, 2),
    F_Date DATE
);

CREATE TABLE Staff (
    St_ID INT PRIMARY KEY,
    St_Name VARCHAR(50),
    St_Contact VARCHAR(15),
    St_Address VARCHAR(100)
);

CREATE TABLE GymFacility (
    Gym_ID INT PRIMARY KEY AUTO_INCREMENT
);

-- Create Junction Tables for Many-to-Many Relationships
CREATE TABLE MemberTrainer (
    Mem_ID INT,
    Tr_ID INT,
    PRIMARY KEY (Mem_ID, Tr_ID),
    FOREIGN KEY (Mem_ID) REFERENCES Member(Mem_ID),
    FOREIGN KEY (Tr_ID) REFERENCES Trainer(Tr_ID)
);

CREATE TABLE MemberEquipment (
    Mem_ID INT,
    Eq_ID INT,
    PRIMARY KEY (Mem_ID, Eq_ID),
    FOREIGN KEY (Mem_ID) REFERENCES Member(Mem_ID),
    FOREIGN KEY (Eq_ID) REFERENCES Equipment(Eq_ID)
);

CREATE TABLE TrainerGymFacility (
    Tr_ID INT,
    Gym_ID INT,
    PRIMARY KEY (Tr_ID, Gym_ID),
    FOREIGN KEY (Tr_ID) REFERENCES Trainer(Tr_ID),
    FOREIGN KEY (Gym_ID) REFERENCES GymFacility(Gym_ID)
);

-- Create relationships for Trainer and Training Schedule
ALTER TABLE TrainingSchedule
ADD COLUMN Tr_ID INT,
ADD FOREIGN KEY (Tr_ID) REFERENCES Trainer(Tr_ID);

-- Create relationship between Fee and Training Schedule
ALTER TABLE Fee
ADD COLUMN Sess_ID INT,
ADD FOREIGN KEY (Sess_ID) REFERENCES TrainingSchedule(Sess_ID);

-- Insert 3 Sample Records for Each Table
INSERT INTO Member VALUES (1, 'Alice', '1234567890', '123 Elm St', 'alice@example.com');
INSERT INTO Member VALUES (2, 'Bob', '0987654321', '456 Maple St', 'bob@example.com');
INSERT INTO Member VALUES (3, 'Charlie', '1122334455', '789 Oak St', 'charlie@example.com');

INSERT INTO Trainer VALUES (1, 'John Doe', '1234567890', '101 Main St');
INSERT INTO Trainer VALUES (2, 'Jane Smith', '2345678901', '202 Park Ave');
INSERT INTO Trainer VALUES (3, 'Sam Brown', '3456789012', '303 Broadway');

INSERT INTO Equipment VALUES (1, 'Treadmill', 'Cardio');
INSERT INTO Equipment VALUES (2, 'Dumbbell', 'Strength');
INSERT INTO Equipment VALUES (3, 'Yoga Mat', 'Flexibility');

INSERT INTO TrainingSchedule VALUES (1, '2024-10-01', '08:00:00', 60, 'Morning Yoga', 1);
INSERT INTO TrainingSchedule VALUES (2, '2024-10-02', '09:00:00', 45, 'Cardio Blast', 2);
INSERT INTO TrainingSchedule VALUES (3, '2024-10-03', '10:00:00', 30, 'Strength Training', 3);

INSERT INTO Fee VALUES (1, 500.00, '2024-10-01', 1);
INSERT INTO Fee VALUES (2, 300.00, '2024-10-02', 2);
INSERT INTO Fee VALUES (3, 200.00, '2024-10-03', 3);

INSERT INTO Staff VALUES (1, 'Emma White', '1234567890', '456 North St');
INSERT INTO Staff VALUES (2, 'Oliver Green', '2345678901', '789 South St');
INSERT INTO Staff VALUES (3, 'Ava Brown', '3456789012', '123 East St');

INSERT INTO GymFacility VALUES (1);
INSERT INTO GymFacility VALUES (2);
INSERT INTO GymFacility VALUES (3);

-- Insert into Junction Tables
INSERT INTO MemberTrainer VALUES (1, 1);
INSERT INTO MemberTrainer VALUES (2, 2);
INSERT INTO MemberTrainer VALUES (3, 3);

INSERT INTO MemberEquipment VALUES (1, 1);
INSERT INTO MemberEquipment VALUES (2, 2);
INSERT INTO MemberEquipment VALUES (3, 3);

INSERT INTO TrainerGymFacility VALUES (1, 1);
INSERT INTO TrainerGymFacility VALUES (2, 2);
INSERT INTO TrainerGymFacility VALUES (3, 3);

select* from Member;
select * from trainer;
select*from equipment;
select*from gymfacility;
select*from trainingschedule;
select*from fee;
select*from staff;
select*from membertrainer;
select*from memberequipment;
select*from trainergymfacility;
-- Create Stored Procedure to View All Trainers
DELIMITER //
CREATE PROCEDURE GetAllTrainers()
BEGIN
    SELECT * FROM Trainer;
END //
DELIMITER ;
 
call getalltrainers();

-- Create Trigger to Prevent Duplicate Email Entries in Member
DELIMITER //
CREATE TRIGGER PreventDuplicateEmail
BEFORE INSERT ON Member
FOR EACH ROW
BEGIN
    DECLARE email_count INT;
    SELECT COUNT(*) INTO email_count FROM Member WHERE Mem_Email = NEW.Mem_Email;
    IF email_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate Email Entry';
    END IF;
END //
DELIMITER ;

-- Test Existing Trigger - Trying to Insert a Duplicate Email
INSERT INTO Member (Mem_ID, Mem_Name, Mem_Contact, Mem_Address, Mem_Email)
VALUES (4, 'David', '5566778899', '100 Cedar St', 'alice@example.com');



-- Example Join Query to Check Member and Trainer Relationships
SELECT m.Mem_Name, t.Tr_Name
FROM Member m
JOIN MemberTrainer mt ON m.Mem_ID = mt.Mem_ID
JOIN Trainer t ON mt.Tr_ID = t.Tr_ID;
