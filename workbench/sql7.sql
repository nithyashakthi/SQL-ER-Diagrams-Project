CREATE DATABASE BusTicketSystem;
USE BusTicketSystem;
-- Passenger table
CREATE TABLE Passenger (
    p_id INT PRIMARY KEY,
    pname VARCHAR(50),
    P_no VARCHAR(15),
    P_age INT
);

-- Ticket table
CREATE TABLE Ticket (
    t_id INT PRIMARY KEY,
    T_date DATE,
    t_amount DECIMAL(10, 2),
    tnumber VARCHAR(15)
);

-- Conductor table
CREATE TABLE Conductor (
    C_id INT PRIMARY KEY,
    c_name VARCHAR(50),
    C_address VARCHAR(100),
    C_age INT
);

-- Bus table
CREATE TABLE Bus (
    B_number VARCHAR(15) PRIMARY KEY,
    B_time TIME,
    B_windows INT,
    B_sites INT,
    B_route VARCHAR(50)
);

-- Relationship table for Passenger-Bus (many-to-many relation)
CREATE TABLE Travel (
    p_id INT,
    B_number VARCHAR(15),
    PRIMARY KEY (p_id, B_number),
    FOREIGN KEY (p_id) REFERENCES Passenger(p_id),
    FOREIGN KEY (B_number) REFERENCES Bus(B_number)
);

-- Relationship table for Ticket-Passenger (many-to-many relation)
CREATE TABLE Buy (
    t_id INT,
    p_id INT,
    PRIMARY KEY (t_id, p_id),
    FOREIGN KEY (t_id) REFERENCES Ticket(t_id),
    FOREIGN KEY (p_id) REFERENCES Passenger(p_id)
);
-- Relationship table for Conductor-Bus (many-to-many relation)
CREATE TABLE Have (
    C_id INT,
    B_number VARCHAR(15),
    PRIMARY KEY (C_id, B_number),
    FOREIGN KEY (C_id) REFERENCES Conductor(C_id),
    FOREIGN KEY (B_number) REFERENCES Bus(B_number)
);

-- Insert sample data into Passenger
INSERT INTO Passenger (p_id, pname, P_no, P_age) VALUES (1, 'John Doe', '1234567890', 30);
INSERT INTO Passenger (p_id, pname, P_no, P_age) VALUES (2, 'Jane Smith', '0987654321', 25);
INSERT INTO Passenger (p_id, pname, P_no, P_age) VALUES (3, 'Alice Johnson', '1112223334', 28);

-- Insert sample data into Ticket
INSERT INTO Ticket (t_id, T_date, t_amount, tnumber) VALUES (1, '2024-10-01', 50.00, 'T001');
INSERT INTO Ticket (t_id, T_date, t_amount, tnumber) VALUES (2, '2024-10-02', 75.00, 'T002');
INSERT INTO Ticket (t_id, T_date, t_amount, tnumber) VALUES (3, '2024-10-03', 100.00, 'T003');

-- Insert sample data into Conductor
INSERT INTO Conductor (C_id, c_name, C_address, C_age) VALUES (1, 'Mark Lee', '123 Elm Street', 40);
INSERT INTO Conductor (C_id, c_name, C_address, C_age) VALUES (2, 'Paul Green', '456 Oak Avenue', 35);
INSERT INTO Conductor (C_id, c_name, C_address, C_age) VALUES (3, 'Sara White', '789 Pine Road', 38);

-- Insert sample data into Bus
INSERT INTO Bus (B_number, B_time, B_windows, B_sites, B_route) VALUES ('B001', '09:00:00', 10, 40, 'Route 1');
INSERT INTO Bus (B_number, B_time, B_windows, B_sites, B_route) VALUES ('B002', '11:00:00', 12, 45, 'Route 2');
INSERT INTO Bus (B_number, B_time, B_windows, B_sites, B_route) VALUES ('B003', '13:00:00', 8, 35, 'Route 3');

INSERT INTO Buy (t_id, p_id) VALUES (1, 1);  -- Ticket ID 1 bought by Passenger ID 1
INSERT INTO Buy (t_id, p_id) VALUES (2, 2);  -- Ticket ID 2 bought by Passenger ID 2
INSERT INTO Buy (t_id, p_id) VALUES (3, 3);

INSERT INTO Travel (p_id, B_number) VALUES (1, 'B001');  -- Passenger ID 1 traveled on Bus B001
INSERT INTO Travel (p_id, B_number) VALUES (2, 'B002');  -- Passenger ID 2 traveled on Bus B002
INSERT INTO Travel (p_id, B_number) VALUES (3, 'B003');

INSERT INTO Have (C_id, B_number) VALUES (1, 'B001');  -- Conductor ID 1 is assigned to Bus B001
INSERT INTO Have (C_id, B_number) VALUES (2, 'B002');  -- Conductor ID 2 is assigned to Bus B002
INSERT INTO Have (C_id, B_number) VALUES (3, 'B003');
select*from passenger;
select*from ticket;
select*from conductor;
select*from bus;
select*from buy;
select*from travel;
select*from have;

select p.p_id,p.pname,b.B_number,b.B_time
from travel t
join passenger p on t.p_id=p.p_id
join bus b on t.B_number=b.B_number;

SELECT p.pname, t.T_date, t.t_amount
FROM Passenger p
INNER JOIN Buy b ON p.p_id = b.p_id
INNER JOIN Ticket t ON b.t_id = t.t_id;

-- store procedure

DELIMITER //
CREATE PROCEDURE GetTotalTicketAmount (IN passenger_id INT)
BEGIN
    SELECT Passenger.pname, SUM(Ticket.t_amount) AS Total_Amount
    FROM Ticket
    INNER JOIN Buy ON Ticket.t_id = Buy.t_id
    INNER JOIN Passenger ON Buy.p_id = Passenger.p_id
    WHERE Passenger.p_id = passenger_id
    GROUP BY Passenger.pname;
END //
DELIMITER ;

call GetTotalTicketAmount(2);
 -- trigger
 ALTER TABLE Passenger ADD COLUMN ticket_count INT DEFAULT 0;
 DELIMITER //
CREATE TRIGGER UpdateTicketCount AFTER INSERT ON Buy
FOR EACH ROW
BEGIN
    DECLARE ticket_count INT;

    -- Calculate the total number of tickets for the passenger
    SELECT COUNT(*) INTO ticket_count FROM Buy WHERE p_id = NEW.p_id;

    -- Update the passenger's ticket count (assuming there's a column to hold this data)
    UPDATE Passenger SET ticket_count = ticket_count WHERE p_id = NEW.p_id;
END //
DELIMITER ;
-- test trigger
select*from buy;
INSERT INTO Buy (t_id, p_id) VALUES (1, 2);
select*from passenger;

