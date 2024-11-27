-- Create the database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- Create Customer table
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Create Item table
CREATE TABLE Item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    item_price DECIMAL(10, 2) NOT NULL
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Create ShoppingCart table (a junction table to handle many-to-many relation between Orders and Item)
CREATE TABLE ShoppingCart (
    order_id INT,
    item_id INT,
    quantity INT,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- Create CreditCard table
CREATE TABLE CreditCard (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    card_number VARCHAR(16) UNIQUE NOT NULL,
    expiry_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Create Company table
CREATE TABLE Company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    established_date DATE
);

-- Create Shipping table
CREATE TABLE Shipping (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    shipping_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Create ECommerce table
CREATE TABLE ECommerce (
    ecommerce_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    url VARCHAR(255)
);


-- Insert records into Customer table
INSERT INTO Customer (name, email) VALUES ('Alice Johnson', 'alice@example.com');
INSERT INTO Customer (name, email) VALUES ('Bob Smith', 'bob@example.com');
INSERT INTO Customer (name, email) VALUES ('Charlie Brown', 'charlie@example.com');

-- Insert records into Item table
INSERT INTO Item (item_name, item_price) VALUES ('Laptop', 1000.00);
INSERT INTO Item (item_name, item_price) VALUES ('Smartphone', 500.00);
INSERT INTO Item (item_name, item_price) VALUES ('Tablet', 300.00);

-- Insert records into Orders table
INSERT INTO Orders (customer_id, order_date) VALUES (1, '2024-10-01');
INSERT INTO Orders (customer_id, order_date) VALUES (2, '2024-10-02');
INSERT INTO Orders (customer_id, order_date) VALUES (3, '2024-10-03');

-- Insert records into ShoppingCart (junction table)
INSERT INTO ShoppingCart (order_id, item_id, quantity) VALUES (1, 1, 2);  -- Order 1 contains 2 Laptops
INSERT INTO ShoppingCart (order_id, item_id, quantity) VALUES (2, 2, 1);  -- Order 2 contains 1 Smartphone
INSERT INTO ShoppingCart (order_id, item_id, quantity) VALUES (3, 3, 3);  -- Order 3 contains 3 Tablets

-- Insert records into CreditCard table
INSERT INTO CreditCard (customer_id, card_number, expiry_date) VALUES (1, '1234567812345678', '2025-12-01');
INSERT INTO CreditCard (customer_id, card_number, expiry_date) VALUES (2, '8765432187654321', '2026-06-01');
INSERT INTO CreditCard (customer_id, card_number, expiry_date) VALUES (3, '1122334455667788', '2027-09-01');

-- Insert records into Company table
INSERT INTO Company (company_name, established_date) VALUES ('TechCorp', '2020-05-01');
INSERT INTO Company (company_name, established_date) VALUES ('SoftSolutions', '2018-09-10');
INSERT INTO Company (company_name, established_date) VALUES ('GadgetHub', '2015-03-15');

-- Insert records into Shipping table
INSERT INTO Shipping (order_id, shipping_date, status) VALUES (1, '2024-10-02', 'Shipped');
INSERT INTO Shipping (order_id, shipping_date, status) VALUES (2, '2024-10-03', 'In Process');
INSERT INTO Shipping (order_id, shipping_date, status) VALUES (3, '2024-10-04', 'Delivered');

-- Insert records into ECommerce table
INSERT INTO ECommerce (name, url) VALUES ('Amazon', 'https://www.amazon.com');
INSERT INTO ECommerce (name, url) VALUES ('eBay', 'https://www.ebay.com');
INSERT INTO ECommerce (name, url) VALUES ('Shopify', 'https://www.shopify.com');

select*from Customer;         
select*from Item;          
select*from Orders;           
select*from ShoppingCart;     
select*from  CreditCard;      
select*from Company  ;        
select*from Shipping; 

-- Join Customer, Orders, and ShoppingCart Table
SELECT Customer.name, Orders.order_id, Orders.order_date, Item.item_name, ShoppingCart.quantity
FROM Customer
JOIN Orders ON Customer.customer_id = Orders.customer_id
JOIN ShoppingCart ON Orders.order_id = ShoppingCart.order_id
JOIN Item ON ShoppingCart.item_id = Item.item_id;

--  Join Orders and ShoppingCart Table
SELECT Orders.order_id, Orders.order_date, ShoppingCart.item_id, ShoppingCart.quantity
FROM Orders
JOIN ShoppingCart ON Orders.order_id = ShoppingCart.order_id;

-- store procedure
DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT Orders.order_id, Orders.order_date, Item.item_name, ShoppingCart.quantity
    FROM Orders
    JOIN ShoppingCart ON Orders.order_id = ShoppingCart.order_id
    JOIN Item ON ShoppingCart.item_id = Item.item_id
    WHERE Orders.customer_id = cust_id;
END //
DELIMITER ;

call GetCustomerOrders(1);
-- trigger
DELIMITER //
CREATE TRIGGER UpdateShippingStatus 
BEFORE UPDATE ON Shipping
FOR EACH ROW
BEGIN
    -- Check if the new shipping date is less than or equal to the current date
    IF NEW.shipping_date <= CURDATE() THEN
        -- Set the status to 'Shipped' if the condition is met
        SET NEW.status = 'Shipped';
    ELSE
        -- Optionally, you can handle the case where the status remains 'In Process'
        SET NEW.status = 'In Process';
    END IF;
END //
DELIMITER ;



-- Update shipping_date to today's date
UPDATE Shipping SET shipping_date = CURDATE() WHERE shipping_id = 2;

-- test trigger
-- Assume shipping_id 2 is still in process; update to today's date

-- Verify if the status is updated
SELECT * FROM Shipping WHERE shipping_id = 2;



