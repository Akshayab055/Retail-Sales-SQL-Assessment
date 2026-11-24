-- Q1 mapping
SELECT s.StoreID,s.StoreName,s.RegionRaw,r.RegionName FROM Stores s LEFT JOIN Regions r ON s.RegionID=r.RegionID;

-- Q1 unmapped
SELECT s.* FROM Stores s LEFT JOIN Regions r ON s.RegionID=r.RegionID WHERE r.RegionID IS NULL;

-- Q2 duplicate records before cleaning
SELECT * FROM OrderItems WHERE OrderItemID IN (SELECT OrderItemID FROM OrderItems GROUP BY OrderItemID HAVING COUNT(*) > 1);

-- Q2 counts
SELECT (SELECT COUNT(*) FROM OrderItems) AS RawRows,(SELECT COUNT(*) FROM OrderItems_Clean) AS CleanRows;

-- Q4
SELECT o.OrderID,o.CustomerID,c.CustomerName FROM Orders o JOIN Customers c ON o.CustomerID=c.CustomerID ORDER BY o.OrderID;

-- Q5
SELECT o.OrderID,o.CustomerID FROM Orders o LEFT JOIN Customers c ON o.CustomerID=c.CustomerID WHERE c.CustomerID IS NULL ORDER BY o.OrderID;

-- Q6
SELECT c.CustomerID,c.CustomerName FROM Customers c LEFT JOIN Orders o ON c.CustomerID=o.CustomerID WHERE o.OrderID IS NULL ORDER BY c.CustomerID;

-- Q7
SELECT i.OrderItemID,COUNT(t.ReturnID) AS ReturnCount,SUM(t.ReturnQuantity) AS ReturnedUnits FROM OrderItems_Clean i JOIN Returns t ON i.OrderItemID=t.OrderItemID GROUP BY i.OrderItemID HAVING COUNT(t.ReturnID)>1;

-- Q8 gross
SELECT r.RegionName, COUNT(DISTINCT o.OrderID) AS CompletedOrders, SUM(i.Quantity*i.UnitPrice) AS GrossSales FROM Orders o JOIN OrderItems_Clean i ON o.OrderID=i.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND o.OrderDate >= '2026-10-01' AND o.OrderDate < '2026-11-01' GROUP BY r.RegionName;

-- Q8 returns
SELECT r.RegionName, SUM(t.ReturnQuantity*i.UnitPrice) AS ReturnValue FROM Returns t JOIN OrderItems_Clean i ON t.OrderItemID=i.OrderItemID JOIN Orders o ON i.OrderID=o.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND t.ReturnDate >= '2026-10-01' AND t.ReturnDate < '2026-11-01' GROUP BY r.RegionName;

-- Q8 net
WITH g AS (SELECT r.RegionName, COUNT(DISTINCT o.OrderID) AS CompletedOrders, SUM(i.Quantity*i.UnitPrice) AS GrossSales FROM Orders o JOIN OrderItems_Clean i ON o.OrderID=i.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND o.OrderDate >= '2026-10-01' AND o.OrderDate < '2026-11-01' GROUP BY r.RegionName), t AS (SELECT r.RegionName, SUM(t.ReturnQuantity*i.UnitPrice) AS ReturnValue FROM Returns t JOIN OrderItems_Clean i ON t.OrderItemID=i.OrderItemID JOIN Orders o ON i.OrderID=o.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND t.ReturnDate >= '2026-10-01' AND t.ReturnDate < '2026-11-01' GROUP BY r.RegionName) SELECT g.*,COALESCE(t.ReturnValue,0) AS ReturnValue,g.GrossSales-COALESCE(t.ReturnValue,0) AS NetSales FROM g LEFT JOIN t ON g.RegionName=t.RegionName;

-- Q9 ranks
WITH n AS (WITH g AS (SELECT r.RegionName, COUNT(DISTINCT o.OrderID) AS CompletedOrders, SUM(i.Quantity*i.UnitPrice) AS GrossSales FROM Orders o JOIN OrderItems_Clean i ON o.OrderID=i.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND o.OrderDate >= '2026-10-01' AND o.OrderDate < '2026-11-01' GROUP BY r.RegionName), t AS (SELECT r.RegionName, SUM(t.ReturnQuantity*i.UnitPrice) AS ReturnValue FROM Returns t JOIN OrderItems_Clean i ON t.OrderItemID=i.OrderItemID JOIN Orders o ON i.OrderID=o.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND t.ReturnDate >= '2026-10-01' AND t.ReturnDate < '2026-11-01' GROUP BY r.RegionName) SELECT g.*,COALESCE(t.ReturnValue,0) AS ReturnValue,g.GrossSales-COALESCE(t.ReturnValue,0) AS NetSales FROM g LEFT JOIN t ON g.RegionName=t.RegionName) SELECT n.*,DENSE_RANK() OVER (ORDER BY GrossSales DESC) AS GrossRank,DENSE_RANK() OVER (ORDER BY NetSales DESC) AS NetRank FROM n;

-- Q10 gross
SELECT r.RegionName, s.StoreID, s.StoreName, SUM(i.Quantity*i.UnitPrice) AS GrossSales FROM Orders o JOIN OrderItems_Clean i ON o.OrderID=i.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND o.OrderDate >= '2026-10-01' AND o.OrderDate < '2026-11-01' GROUP BY r.RegionName,s.StoreID,s.StoreName;

-- Q10 returns
SELECT r.RegionName, s.StoreID, s.StoreName, SUM(t.ReturnQuantity*i.UnitPrice) AS ReturnValue FROM Returns t JOIN OrderItems_Clean i ON t.OrderItemID=i.OrderItemID JOIN Orders o ON i.OrderID=o.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND t.ReturnDate >= '2026-10-01' AND t.ReturnDate < '2026-11-01' GROUP BY r.RegionName,s.StoreID,s.StoreName;

-- Q10 net
WITH g AS (SELECT r.RegionName, s.StoreID, s.StoreName, COUNT(DISTINCT o.OrderID) AS CompletedOrders, SUM(i.Quantity*i.UnitPrice) AS GrossSales FROM Orders o JOIN OrderItems_Clean i ON o.OrderID=i.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND o.OrderDate >= '2026-10-01' AND o.OrderDate < '2026-11-01' GROUP BY r.RegionName,s.StoreID,s.StoreName), t AS (SELECT r.RegionName, s.StoreID, s.StoreName, SUM(t.ReturnQuantity*i.UnitPrice) AS ReturnValue FROM Returns t JOIN OrderItems_Clean i ON t.OrderItemID=i.OrderItemID JOIN Orders o ON i.OrderID=o.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND t.ReturnDate >= '2026-10-01' AND t.ReturnDate < '2026-11-01' GROUP BY r.RegionName,s.StoreID,s.StoreName) SELECT g.*,COALESCE(t.ReturnValue,0) AS ReturnValue,g.GrossSales-COALESCE(t.ReturnValue,0) AS NetSales FROM g LEFT JOIN t ON g.StoreID=t.StoreID;

-- Q10 winners
WITH n AS (WITH g AS (SELECT r.RegionName, s.StoreID, s.StoreName, COUNT(DISTINCT o.OrderID) AS CompletedOrders, SUM(i.Quantity*i.UnitPrice) AS GrossSales FROM Orders o JOIN OrderItems_Clean i ON o.OrderID=i.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND o.OrderDate >= '2026-10-01' AND o.OrderDate < '2026-11-01' GROUP BY r.RegionName,s.StoreID,s.StoreName), t AS (SELECT r.RegionName, s.StoreID, s.StoreName, SUM(t.ReturnQuantity*i.UnitPrice) AS ReturnValue FROM Returns t JOIN OrderItems_Clean i ON t.OrderItemID=i.OrderItemID JOIN Orders o ON i.OrderID=o.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID WHERE o.OrderStatus='Completed' AND t.ReturnDate >= '2026-10-01' AND t.ReturnDate < '2026-11-01' GROUP BY r.RegionName,s.StoreID,s.StoreName) SELECT g.*,COALESCE(t.ReturnValue,0) AS ReturnValue,g.GrossSales-COALESCE(t.ReturnValue,0) AS NetSales FROM g LEFT JOIN t ON g.StoreID=t.StoreID), ranked AS (SELECT n.*,ROW_NUMBER() OVER (PARTITION BY RegionName ORDER BY NetSales DESC,StoreID) AS rn FROM n) SELECT * FROM ranked WHERE rn=1;

-- Q11
SELECT p.Category, SUM(t.ReturnQuantity*i.UnitPrice) AS ReturnValue FROM Returns t JOIN OrderItems_Clean i ON t.OrderItemID=i.OrderItemID JOIN Orders o ON i.OrderID=o.OrderID JOIN Stores s ON o.StoreID=s.StoreID JOIN Regions r ON s.RegionID=r.RegionID JOIN Products p ON i.ProductID=p.ProductID WHERE r.RegionName='North' AND o.OrderStatus='Completed' AND t.ReturnDate >= '2026-10-01' AND t.ReturnDate < '2026-11-01' GROUP BY p.Category ORDER BY ReturnValue DESC,p.Category;