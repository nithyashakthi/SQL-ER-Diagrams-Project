create database BankDB;
use BankDB;

CREATE TABLE Bank (
    Code VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100)
);

CREATE TABLE Branch (
    Branch_id INT PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100),
    Bank_Code VARCHAR(10),
    FOREIGN KEY (Bank_Code) REFERENCES Bank(Code)
);

CREATE TABLE Loan (
    Loan_id INT PRIMARY KEY,
    Loan_type VARCHAR(50),
    Amount DECIMAL(15,2),
    Branch_id INT,
    FOREIGN KEY (Branch_id) REFERENCES Branch(Branch_id)
);

CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Acc_Type VARCHAR(50),
    Balance DECIMAL(15,2),
    Branch_id INT,
    FOREIGN KEY (Branch_id) REFERENCES Branch(Branch_id)
);

CREATE TABLE Customer (
    Custid INT PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100),
    Phone VARCHAR(15)
);

-- Create Junction table for Loan-Customer relationship (Availed by)
CREATE TABLE Customer_Loan (
    Custid INT,
    Loan_id INT,
    PRIMARY KEY (Custid, Loan_id),
    FOREIGN KEY (Custid) REFERENCES Customer(Custid),
    FOREIGN KEY (Loan_id) REFERENCES Loan(Loan_id)
);

-- Create Junction table for Account-Customer relationship (Hold by)
CREATE TABLE Customer_Account (
    Custid INT,
    Account_No INT,
    PRIMARY KEY (Custid, Account_No),
    FOREIGN KEY (Custid) REFERENCES Customer(Custid),
    FOREIGN KEY (Account_No) REFERENCES Account(Account_No)
);

-- Insert into Bank
INSERT INTO Bank (Code, Name, Address) 
VALUES ('B001', 'Global Bank', '123 Main St'),
       ('B002', 'City Bank', '456 Oak St'),
       ('B003', 'Metro Bank', '789 Pine St');

-- Insert into Branch
INSERT INTO Branch (Branch_id, Name, Address, Bank_Code) 
VALUES (101, 'Downtown Branch', '456 Elm St', 'B001'),
       (102, 'Uptown Branch', '789 Maple St', 'B002'),
       (103, 'Suburban Branch', '321 Birch St', 'B003');

-- Insert into Customer
INSERT INTO Customer (Custid, Name, Address, Phone) 
VALUES (1, 'John Doe', '789 Maple St', '1234567890'),
       (2, 'Jane Smith', '101 Oak St', '0987654321'),
       (3, 'Alice Johnson', '102 Pine St', '1122334455');

-- Insert into Loan
INSERT INTO Loan (Loan_id, Loan_type, Amount, Branch_id) 
VALUES (1001, 'Home Loan', 50000, 101),
       (1002, 'Car Loan', 15000, 102),
       (1003, 'Education Loan', 30000, 103);

-- Insert into Account
INSERT INTO Account (Account_No, Acc_Type, Balance, Branch_id) 
VALUES (5001, 'Savings', 1000, 101),
       (5002, 'Checking', 2000, 102),
       (5003, 'Fixed Deposit', 5000, 103);
-- insert into relationship
-- Insert into Customer_Loan (Availed by)
INSERT INTO Customer_Loan (Custid, Loan_id) 
VALUES (1, 1001),
       (2, 1002),
       (3, 1003);

-- Insert into Customer_Account (Hold by)
INSERT INTO Customer_Account (Custid, Account_No) 
VALUES (1, 5001),
       (2, 5002),
       (3, 5003);
select *from bank;
select*from branch;
select*from loan;
select*from account;
select*from Customer_Loan;
select*from Customer_Account;

-- Find customers who have loans from a specific branch
SELECT c.Name, l.Loan_type, l.Amount, b.Name AS Branch_Name
FROM Customer c
JOIN Customer_Loan cl ON c.Custid = cl.Custid
JOIN Loan l ON cl.Loan_id = l.Loan_id
JOIN Branch b ON l.Branch_id = b.Branch_id
WHERE b.Branch_id = 101;

-- store procedure
DELIMITER //

CREATE PROCEDURE GetCustomersByLoan(IN loanId INT)
BEGIN
    SELECT c.Name, c.Address, c.Phone
    FROM Customer c
    JOIN Customer_Loan cl ON c.Custid = cl.Custid
    WHERE cl.Loan_id = loanId;
END //

DELIMITER ;

CALL GetCustomersByLoan(1001);

-- trigger

-- Create Loan_Audit Table

CREATE TABLE Loan_Audit (
    Audit_id INT AUTO_INCREMENT PRIMARY KEY,
    Loan_id INT,
    Old_Amount DECIMAL(15,2),
    New_Amount DECIMAL(15,2),
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- trigger
DELIMITER //

CREATE TRIGGER loan_update_audit
AFTER UPDATE ON Loan
FOR EACH ROW
BEGIN
    IF OLD.Amount <> NEW.Amount THEN
        INSERT INTO Loan_Audit (Loan_id, Old_Amount, New_Amount)
        VALUES (NEW.Loan_id, OLD.Amount, NEW.Amount);
    END IF;
END //

DELIMITER ;

SELECT * FROM Loan_Audit;
UPDATE Loan
SET Amount = 60000
WHERE Loan_id = 1002;
SELECT * FROM Loan_Audit;
