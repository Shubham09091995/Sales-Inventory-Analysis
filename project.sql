
CREATE DATABASE GroceryStoreDB;

USE GroceryStoreDB;

# Drop tables if they already exist
DROP TABLE IF EXISTS Sales, Inventory, Products, Employees, Customers, Suppliers;



-- Drop tables if they already exist
DROP TABLE IF EXISTS Sales, Inventory, Products, Employees, Customers, Suppliers;

-- Create tables
CREATE TABLE Products (
    ProductID INT PRIMARY KEY auto_increment,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY,
    QuantityInStock INT NOT NULL,
    ReorderLevel INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY auto_increment,
    CustomerName VARCHAR(100) NOT NULL,
    Contact VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY auto_increment,
    EmployeeName VARCHAR(100) NOT NULL,
    Role VARCHAR(50),
    HireDate DATE
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY auto_increment,
    SupplierName VARCHAR(100),
    ContactNumber VARCHAR(20)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY auto_increment,
    ProductID INT,
    CustomerID INT,
    EmployeeID INT,
    QuantitySold INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Insert sample data into Products
INSERT INTO Products (ProductName, Category, Price)
VALUES 
('Milk', 'Dairy', 2.50),
('Bread', 'Bakery', 1.50),
('Eggs', 'Dairy', 3.00),
('Apple', 'Fruits', 0.80),
('Rice', 'Grains', 1.20);

-- Insert inventory for the products
INSERT INTO Inventory (ProductID, QuantityInStock, ReorderLevel)
SELECT ProductID, 100, 20 FROM Products;

-- Insert sample customers
INSERT INTO Customers (CustomerName, Contact, Email)
VALUES 
('Alice Johnson', '1234567890', 'alice@example.com'),
('Bob Smith', '0987654321', 'bob@example.com');

-- Insert sample employees
INSERT INTO Employees (EmployeeName, Role, HireDate)
VALUES 
('Karen Williams', 'Cashier', '2022-01-15'),
('John Davis', 'Manager', '2021-11-10');

-- Insert sample suppliers
INSERT INTO Suppliers (SupplierName, ContactNumber)
VALUES 
('FreshDairy Ltd.', '111-222-3333'),
('Bakers Co.', '444-555-6666');

-- Insert sales data
INSERT INTO Sales (ProductID, CustomerID, EmployeeID, QuantitySold, SaleDate)
VALUES
(1, 1, 1, 2, '2025-05-28'),
(2, 1, 2, 1, '2025-05-29'),
(3, 2, 1, 1, '2025-05-30'),
(4, 2, 2, 5, '2025-05-30');

-- Queries (for reports)

-- # Daily Sales Summary
SELECT 
    SaleDate,
    SUM(QuantitySold * P.Price) AS TotalSales
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY SaleDate
ORDER BY SaleDate;

-- # Products Below Reorder Level
SELECT 
    P.ProductName,
    I.QuantityInStock,
    I.ReorderLevel
FROM Inventory I
JOIN Products P ON I.ProductID = P.ProductID
WHERE I.QuantityInStock < I.ReorderLevel;

-- # Top-Selling Products
SELECT 
    P.ProductName,
    SUM(S.QuantitySold) AS TotalSold
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalSold DESC;

-- # Employee Sales Performance
SELECT 
    E.EmployeeName,
    COUNT(S.SaleID) AS SalesHandled,
    SUM(S.QuantitySold * P.Price) AS TotalRevenue
FROM Sales S
JOIN Employees E ON S.EmployeeID = E.EmployeeID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY E.EmployeeName;

-- Queries (for reports)

-- # Daily Sales Summary
SELECT 
    SaleDate,
    SUM(QuantitySold * P.Price) AS TotalSales
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY SaleDate
ORDER BY SaleDate;

-- # Products Below Reorder Level
SELECT 
    P.ProductName,
    I.QuantityInStock,
    I.ReorderLevel
FROM Inventory I
JOIN Products P ON I.ProductID = P.ProductID
WHERE I.QuantityInStock < I.ReorderLevel;

-- # Top-Selling Products
SELECT 
    P.ProductName,
    SUM(S.QuantitySold) AS TotalSold
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalSold DESC;

-- # Employee Sales Performance
SELECT 
    E.EmployeeName,
    COUNT(S.SaleID) AS SalesHandled,
    SUM(S.QuantitySold * P.Price) AS TotalRevenue
FROM Sales S
JOIN Employees E ON S.EmployeeID = E.EmployeeID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY E.EmployeeName;