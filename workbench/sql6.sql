CREATE DATABASE hotel_management;
USE hotel_management;

CREATE TABLE Login (
    login_id INT PRIMARY KEY,
    login_username VARCHAR(50),
    login_password VARCHAR(50)
);

CREATE TABLE User (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    user_mobile VARCHAR(20),
    user_email VARCHAR(50),
    user_address VARCHAR(100),
    login_id INT,
    FOREIGN KEY (login_id) REFERENCES Login(login_id)
);

CREATE TABLE Roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50),
    role_desc TEXT
);

CREATE TABLE Permission (
    per_id INT PRIMARY KEY,
    per_role_id INT,
    per_modul VARCHAR(50),
    per_name VARCHAR(50),
    FOREIGN KEY (per_role_id) REFERENCES Roles(role_id)
);

CREATE TABLE Customer (
    cus_id INT PRIMARY KEY,
    cus_name VARCHAR(50),
    cus_mobile VARCHAR(20),
    cus_email VARCHAR(50),
    cus_address VARCHAR(100),
    cus_pass VARCHAR(50)
);

CREATE TABLE Hotel (
    hotel_id INT PRIMARY KEY,
    hotel_name VARCHAR(50),
    hotel_type VARCHAR(20),
    hotel_desc TEXT,
    hotel_rent DECIMAL(10, 2)
);

CREATE TABLE Payments (
    pay_id INT PRIMARY KEY,
    pay_cus_id INT,
    pay_date DATE,
    pay_amt DECIMAL(10, 2),
    pay_desc TEXT,
    FOREIGN KEY (pay_cus_id) REFERENCES Customer(cus_id)
);

CREATE TABLE Booking (
    book_id INT PRIMARY KEY,
    book_desc TEXT,
    book_type VARCHAR(20),
    user_id INT,
    hotel_id INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

-- Create a junction table for the many-to-many relationship between User and Roles
CREATE TABLE User_Roles (
    user_id INT,
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id));

-- Login table
INSERT INTO Login (login_id, login_username, login_password) VALUES
(1, 'user1', 'password1'),
(2, 'user2', 'password2'),
(3, 'user3', 'password3');

-- User table
INSERT INTO User (user_id, user_name, user_mobile, user_email, user_address, login_id) VALUES
(1, 'John Doe', '1234567890', 'johndoe@example.com', '123 Main St', 1),
(2, 'Jane Smith', '9876543210', 'janesmith@example.com', '456 Elm St', 2),
(3, 'Alice Johnson', '5555555555', 'alicejohnson@example.com', '789 Oak St', 3);

-- Roles table
INSERT INTO Roles (role_id, role_name, role_desc) VALUES
(1, 'Admin', 'Administrator role'),
(2, 'Manager', 'Manager role'),
(3, 'Guest', 'Guest role');

-- Permission table
INSERT INTO Permission (per_id, per_role_id, per_modul, per_name) VALUES
(1, 1, 'Hotel', 'Add Hotel'),
(2, 2, 'Booking', 'View Bookings'),
(3, 3, 'Payment', 'Make Payment');

-- Customer table
INSERT INTO Customer (cus_id, cus_name, cus_mobile, cus_email, cus_address, cus_pass) VALUES
(1, 'Customer1', '1111111111', 'customer1@example.com', 'Address1', 'pass1'),
(2, 'Customer2', '2222222222', 'customer2@example.com', 'Address2', 'pass2'),
(3, 'Customer3', '3333333333', 'customer3@example.com', 'Address3', 'pass3');

-- Hotel table
INSERT INTO Hotel (hotel_id, hotel_name, hotel_type, hotel_desc, hotel_rent) VALUES
(1, 'Hotel A', 'Luxury', 'Description for Hotel A', 100.00),
(2, 'Hotel B', 'Budget', 'Description for Hotel B', 50.00),
(3, 'Hotel C', 'Mid-Range', 'Description for Hotel C', 75.00);

-- Payments table
INSERT INTO Payments (pay_id, pay_cus_id, pay_date, pay_amt, pay_desc) VALUES
(1, 1, '2023-01-01', 100.00, 'Payment for Hotel A'),
(2, 2, '2023-02-01', 50.00, 'Payment for Hotel B'),
(3, 3, '2023-03-01', 75.00, 'Payment for Hotel C');

-- Booking table
INSERT INTO Booking (book_id, book_desc, book_type, user_id, hotel_id) VALUES
(1, 'Booking for Hotel A', 'Single Room', 1, 1),
(2, 'Booking for Hotel B', 'Double Room', 2, 2),
(3, 'Booking for Hotel C', 'Family Room', 3, 3);

-- User_Roles table
INSERT INTO User_Roles (user_id, role_id) VALUES
(1, 1),
(2, 2),
(3, 3);
-- join
SELECT User.user_id, User.user_name, Booking.book_id, Booking.book_desc
FROM User
INNER JOIN Booking ON User.user_id = Booking.user_id;

SELECT User.user_id, User.user_name, Booking.book_id, Booking.book_desc, Hotel.hotel_name
FROM User
INNER JOIN Booking ON User.user_id = Booking.user_id
INNER JOIN Hotel ON Booking.hotel_id = Hotel.hotel_id;

DELIMITER //

CREATE PROCEDURE GetAllUsers()
BEGIN
    SELECT * FROM User;
END //

DELIMITER ;
call GetAllUsers();

CREATE TABLE CustomerLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    cus_id INT,
    log_message VARCHAR(255),
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //

CREATE TRIGGER after_customer_insert
AFTER INSERT ON Customer
FOR EACH ROW
BEGIN
    INSERT INTO CustomerLog (cus_id, log_message)
    VALUES (NEW.cus_id, CONCAT('New customer added: ', NEW.cus_name));
END;
//

DELIMITER ;

INSERT INTO Customer (cus_id, cus_name, cus_mobile, cus_email, cus_address, cus_pass)
VALUES (4, 'Bob Brown', '5557654321', 'bob@example.com', '321 Maple Lane', 'password101');

SELECT * FROM CustomerLog;