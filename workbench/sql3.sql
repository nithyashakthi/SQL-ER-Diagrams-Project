create database library;
use library;
CREATE TABLE Publisher (
    Pub_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255)
);

CREATE TABLE Books (
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Price DECIMAL(10, 2),
    Available BOOLEAN,
    Pub_ID INT,
    FOREIGN KEY (Pub_ID) REFERENCES Publisher(Pub_ID)
);

CREATE TABLE Member (
    memb_id INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Memb_type VARCHAR(50),
    Memb_date DATE,
    Expiry_Date DATE
);

CREATE TABLE Borrowed_by (
    Book_ID INT,
    memb_id INT,
    Issue DATE,
    DueDate DATE,
    ReturnDate DATE,
    PRIMARY KEY (Book_ID, memb_id),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID),
    FOREIGN KEY (memb_id) REFERENCES Member(memb_id)
);
INSERT INTO Publisher (Pub_ID, Name, Address)
VALUES 
(101, 'Penguin Books', '123 Penguin St, NY'),
(102, 'HarperCollins', '456 Harper Ave, CA'),
(103, 'Simon & Schuster', '789 Simon Rd, TX');

INSERT INTO Books (Book_ID, Title, Author, Price, Available, Pub_ID)
    VALUES(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 300.00, TRUE, 101),
(2, '1984', 'George Orwell', 350.00, TRUE, 102),
(3, 'To Kill a Mockingbird', 'Harper Lee', 400.00, TRUE, 102);

INSERT INTO Member (memb_id, Name, Address, Memb_type, Memb_date, Expiry_Date)
VALUES 
(1, 'John Doe', '100 Main St, NY', 'Gold', '2024-01-01', '2024-12-31'),
(2, 'Jane Smith', '200 Maple Ave, CA', 'Silver', '2024-03-15', '2024-12-15'),
(3, 'Emily Johnson', '300 Oak Blvd, TX', 'Platinum', '2024-05-20', '2024-11-20');

INSERT INTO Borrowed_by (Book_ID, memb_id, Issue, DueDate, ReturnDate)
VALUES 
(1, 1, '2024-10-01', '2024-10-15', NULL),
(2, 2, '2024-10-02', '2024-10-16', NULL),
(3, 3, '2024-10-03', '2024-10-17', NULL);

select*from publisher;
select*from books;
select*from member;

-- join's condition to check relation
SELECT B.Book_ID, B.Title, B.Author, B.Price, P.Name AS Publisher_Name, P.Address
FROM Books B
INNER JOIN Publisher P ON B.Pub_ID = P.Pub_ID;

-- Join with Filtering:  books that have been borrowed

SELECT B.Book_ID, B.Title, M.Name AS Borrowed_By, BB.Issue, BB.DueDate
FROM Books B
INNER JOIN Borrowed_by BB ON B.Book_ID = BB.Book_ID
INNER JOIN Member M ON BB.memb_id = M.memb_id
WHERE B.Available = FALSE;

-- Stored Procedure to Count Total Books Borrowed by a Member
DELIMITER //

CREATE PROCEDURE GetTotalBooksBorrowedByMember(
    IN p_memb_id INT
)
BEGIN
    SELECT COUNT(*) AS TotalBooksBorrowed
    FROM Borrowed_by
    WHERE memb_id = p_memb_id;
END //

DELIMITER ;

CALL GetTotalBooksBorrowedByMember(1);

-- TRIGGER

DELIMITER //

CREATE TRIGGER UpdateBookAvailability
AFTER INSERT ON Borrowed_by
FOR EACH ROW
BEGIN
    UPDATE Books
    SET Available = FALSE
    WHERE Book_ID = NEW.Book_ID;
END //

DELIMITER ;
-- TESTING THE SETUP BY ADDIG ENTRIES.
INSERT INTO Books (Book_ID, Title, Author, Price, Available, Pub_ID)
VALUES 
(4, 'The Catcher in the Rye', 'J.D. Salinger', 500.00, TRUE, 101);
-- INSERT IN BORROWED 
INSERT INTO Borrowed_by (Book_ID, memb_id, Issue, DueDate, ReturnDate)
VALUES (4, 1, '2024-10-03', '2024-10-17', NULL);

-- check if the Trigger Updated the Books Table:

SELECT Book_ID, Title, Available
FROM Books
WHERE Book_ID = 4;

