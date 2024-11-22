-- 2.3 Create a stored procedure to handle product returns and refunds, updating inventory and order status.
CREATE PROCEDURE usp_processOrderReturnOrRefund
@OrderID uniqueidentifier,
@OrderStatus nvarchar(50)
as
begin
	BEGIN TRY
		BEGIN TRANSACTION;

		if not exists (select 1 from [Order] where OrderID = @OrderID)
		BEGIN
			THROW 50002, 'Inexisting Order ID',  1;
		END

		if lower(@OrderStatus) <> 'returned' AND  lower(@OrderStatus) <> 'refunded'
		BEGIN
			THROW 50003, 'Invalid Order Status',  1;
		END

		declare @productQuantity int;
		declare @productID uniqueidentifier;

		select TOP 1 
				@productQuantity = Quantity,
				@productID = ProductID
		from OrderDetail where OrderID = @OrderID

		update [Order]
		set OrderStatus = @OrderStatus
		where OrderID = @OrderID

		update Product
		set StockQuantity = StockQuantity + @productQuantity
		where ProductID = @ProductID

		print CAST(@ProductID AS VARCHAR(50)) + ' order was ' + @OrderStatus

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		PRINT ERROR_MESSAGE();
		THROW;
	END CATCH
end

-- Test 01 successfull
-- Prevalidations. Use OrderID from 2.1
select * from [Order]
where OrderID = '82FDDA0A-19C8-4B54-8F96-FE446F71D83A' --OrderStatus

select * from [OrderDetail]
where OrderID = '82FDDA0A-19C8-4B54-8F96-FE446F71D83A' --Quantity

select * from Product
where ProductID = 'D3F59303-443A-43BA-A6D9-8CCAF68F5B27' --StockQuantity

execute usp_processOrderReturnOrRefund 
@OrderID = '82FDDA0A-19C8-4B54-8F96-FE446F71D83A',
@OrderStatus = 'returned'

-- Postvalidations
select * from [Order]
where OrderID = '82FDDA0A-19C8-4B54-8F96-FE446F71D83A' --OrderStatus

select * from [OrderDetail]
where OrderID = '82FDDA0A-19C8-4B54-8F96-FE446F71D83A' --Quantity

select * from Product
where ProductID = 'D3F59303-443A-43BA-A6D9-8CCAF68F5B27' --StockQuantity

-- Test 02 with inexisting Order ID
execute usp_processOrderReturnOrRefund 
@OrderID = '00000000-0000-0000-0000-000000000000',
@OrderStatus = 'returned'

-- Test 03 with invalid Order Status
execute usp_processOrderReturnOrRefund 
@OrderID = '82FDDA0A-19C8-4B54-8F96-FE446F71D83A',
@OrderStatus = 'confirmed'