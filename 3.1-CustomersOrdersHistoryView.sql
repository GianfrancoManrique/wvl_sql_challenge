-- 3.1 Create a view to display customer order history with detailed product information
CREATE VIEW [dbo].[vwCustomersOrdersHistory]
as
select c.CustomerName, o.OrderDate, o.OrderID,p.ProductName, od.Quantity, od.Price
from [Order] o
join OrderDetail od on o.OrderID = od.OrderID
join Customer c on o.CustomerID = c.CustomerID
join Product p on od.ProductID = p.ProductID
GO

-- Test view
SELECT * FROM [vwCustomersOrdersHistory]
order by CustomerName, OrderDate desc