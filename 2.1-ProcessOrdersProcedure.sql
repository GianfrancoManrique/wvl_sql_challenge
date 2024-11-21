-- 2.1 Create a stored procedure to process orders, updating inventory levels and generating order confirmations
CREATE PROCEDURE [dbo].[usp_processOrders] 
    @CustomerID uniqueidentifier,
    @OrderDate datetime,
    @ShippingAddress nvarchar(200),
    @BillingAddress nvarchar(200),
    @ProductID uniqueidentifier,
    @Quantity int,
    @Price decimal(10,2),
    @DiscountAmout decimal(10,2)
as
begin
	BEGIN TRY
		BEGIN TRANSACTION;

		declare @billingAddressID bigint;
		declare @shippingAddressID bigint;
		declare @orderIDs table(id uniqueidentifier);
		declare @orderID uniqueidentifier;
		declare @orderDetailsIDs table(id uniqueidentifier);
		declare @orderDetailID uniqueidentifier;

		declare @currentStock int = (select StockQuantity from Product where ProductID = @ProductID);
		IF (@currentStock - @Quantity < 0)
		BEGIN
			THROW 50001, 'Not enough stock',  1;
		END

		insert into ShippingAddress(Address) values (@ShippingAddress);
		set @shippingAddressID = SCOPE_IDENTITY();

		insert into BillingAddress(Address) values (@BillingAddress);
		set @billingAddressID = SCOPE_IDENTITY();

		insert into [Order](CustomerID, OrderDate, OrderStatus, ShippingAddressID, BillingAddressID)
		output inserted.OrderID into @orderIDs
		values (@CustomerID, @OrderDate, 'CONFIRMED', @shippingAddressID, @billingAddressID)

		set @orderID = (select top 1 id from @orderIDs)

		--TODO: Refactor to insert multiple order details
		insert into OrderDetail(OrderID, ProductID, Quantity, Price, DiscountAmount)
		output inserted.OrderDetailID into @orderDetailsIDs
		values (@orderID, @ProductID, @Quantity, @Price, @DiscountAmout)

		--TODO: Refactor to update multiple products stock
		update Product
		set StockQuantity = StockQuantity - @Quantity
		where ProductID = @ProductID

		print CAST(@orderID AS VARCHAR(50)) + ' confirmed'

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		PRINT ERROR_MESSAGE();
		THROW;
	END CATCH
end
GO

-- Test 01 successfull
select * from Product
where ProductID = 'D3F59303-443A-43BA-A6D9-8CCAF68F5B27'

exec usp_processOrders 
    @CustomerID = 'F2DB9A68-E322-46A7-A6FD-38B964F2615D',
    @OrderDate = '2024-11-21', 
    @ShippingAddress = 'shipping address test',
    @BillingAddress = 'billing address test', 
    @ProductID = 'D3F59303-443A-43BA-A6D9-8CCAF68F5B27',
    @Quantity = 30,
    @Price = 3,
    @DiscountAmout = 12

select o.*, sa.Address as ShippingAddressID, ba.Address as BillingAddress
from [Order] o
join ShippingAddress sa on o.ShippingAddressID = sa.ShippingAddressID
join BillingAddress ba on o.BillingAddressID = ba.BillingAddressID
where OrderID = '82FDDA0A-19C8-4B54-8F96-FE446F71D83A'

select * from [OrderDetail]
where OrderID = '82FDDA0A-19C8-4B54-8F96-FE446F71D83A'

select * from Product
where ProductID = 'D3F59303-443A-43BA-A6D9-8CCAF68F5B27'

-- Test 02 with not enough stock error
exec usp_processOrders 
    @CustomerID = 'F2DB9A68-E322-46A7-A6FD-38B964F2615D',
    @OrderDate = '2024-11-21', 
    @ShippingAddress = 'shipping address test',
    @BillingAddress = 'billing address test', 
    @ProductID = 'D3F59303-443A-43BA-A6D9-8CCAF68F5B27',
    @Quantity = 600, --Update to trigger error
    @Price = 3,
    @DiscountAmout = 12
