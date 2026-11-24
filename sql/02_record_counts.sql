-- Run after 01_schema_and_all_records.sql
SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM Customers
UNION ALL
SELECT 'Stores' AS TableName, COUNT(*) AS TotalRows FROM Stores
UNION ALL
SELECT 'Products' AS TableName, COUNT(*) AS TotalRows FROM Products
UNION ALL
SELECT 'Orders' AS TableName, COUNT(*) AS TotalRows FROM Orders
UNION ALL
SELECT 'OrderItems' AS TableName, COUNT(*) AS TotalRows FROM OrderItems
UNION ALL
SELECT 'Returns' AS TableName, COUNT(*) AS TotalRows FROM Returns;
