-- Question 1: Achieving 1NF in MYSQL
-- Step 1: Create the original table
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products TEXT
);
INSERT INTO ProductDetail
VALUES (101, 'John Doe', 'Laptop, Mouse'),
    (102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
    (103, 'Emily Clark', 'Phone');
-- Step 2: Use a recursive CTE to split products
WITH RECURSIVE split_products AS (
    SELECT OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
        SUBSTRING(
            Products,
            LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2
        ) AS remaining
    FROM ProductDetail
    UNION ALL
    SELECT OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(remaining, ',', 1)),
        SUBSTRING(
            remaining,
            LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2
        )
    FROM split_products
    WHERE remaining <> ''
)
SELECT OrderID,
    CustomerName,
    Product
FROM split_products
ORDER BY OrderID;
-- Question 2: Achieving 2NF in MySQL
-- Step 1: Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);
INSERT INTO Orders
VALUES (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Clark');
-- Step 2: Create the OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
INSERT INTO OrderItems
VALUES (101, 'Laptop', 2),
    (101, 'Mouse', 1),
    (102, 'Tablet', 3),
    (102, 'Keyboard', 1),
    (102, 'Mouse', 2),
    (103, 'Phone', 1);