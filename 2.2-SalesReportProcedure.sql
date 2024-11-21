
-- 2.2 Create a stored procedure to calculate sales reports by category and product
CREATE procedure [dbo].[usp_calculateSales]
as
begin
	with CTE_sales as
	(
		select p.CategoryID, p.ProductID, od.Price*od.Quantity - ISNULL(od.DiscountAmount,0) as total
		from OrderDetail od
		join [Order] o on od.OrderID = o.OrderID
		join Product p on od.ProductID = p.ProductID
		where o.OrderStatus NOT IN ('returned', 'refunded')
	)
	select CategoryID, ProductID, sum(total) as totalSales
	from CTE_sales
	group by CategoryID, ProductID
end
GO

-- Test procedure
exec [usp_calculateSales]

select p.CategoryID, 
	   p.ProductID,  
	   od.Price, 
	   od.Quantity, 
	   od.DiscountAmount,
	   od.Price*od.Quantity - ISNULL(od.DiscountAmount,0) as total
from OrderDetail od
join [Order] o on od.OrderID = o.OrderID
join Product p on od.ProductID = p.ProductID
where o.OrderStatus NOT IN ('returned', 'refunded')