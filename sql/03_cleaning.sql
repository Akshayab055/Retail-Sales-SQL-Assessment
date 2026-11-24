-- Q1: Standardize regions
CREATE TABLE Regions (RegionID INT PRIMARY KEY, RegionName VARCHAR(30) NOT NULL UNIQUE);
INSERT INTO Regions VALUES (1,'North'),(2,'South'),(3,'West');
ALTER TABLE Stores ADD COLUMN RegionID INT;
UPDATE Stores SET RegionID = CASE WHEN UPPER(TRIM(RegionRaw)) IN ('N','NORTH') THEN 1 WHEN UPPER(TRIM(RegionRaw)) IN ('S','SOUTH') THEN 2 WHEN UPPER(TRIM(RegionRaw)) IN ('W','WEST') THEN 3 END;
-- Q2: Create cleaned order lines
CREATE TABLE OrderItems_Clean AS SELECT OrderItemID,OrderID,ProductID,Quantity,UnitPrice,LoadedAt FROM (SELECT OrderItems.*, ROW_NUMBER() OVER (PARTITION BY OrderItemID ORDER BY LoadedAt DESC) AS rn FROM OrderItems) x WHERE rn=1;
ALTER TABLE Stores ADD FOREIGN KEY (RegionID) REFERENCES Regions(RegionID);
ALTER TABLE OrderItems_Clean ADD PRIMARY KEY (OrderItemID);
