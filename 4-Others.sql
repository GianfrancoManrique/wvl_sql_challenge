-- Indexes creation
CREATE NONCLUSTERED INDEX IX_OrderDetail_OrderID
ON OrderDetail(OrderID)

CREATE NONCLUSTERED INDEX IX_OrderDetail_ProductID
ON OrderDetail(ProductID)

CREATE NONCLUSTERED INDEX IX_Order_CustomerID
ON [Order](CustomerID)

-- Users creation with defined security rights