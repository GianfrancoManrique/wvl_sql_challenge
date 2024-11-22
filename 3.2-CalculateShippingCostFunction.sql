-- 3.2 Create a function to calculate shipping costs based on order weight and destination.
CREATE FUNCTION [dbo].[ufn_CalculateShippingCost]
(
@orderId uniqueidentifier,
@orderDistance int = 0
)
returns decimal(10,2)
as
begin
	-- Validate order status before calculating any shipping cost
	declare @orderStatus nvarchar(50) = (select OrderStatus from [Order] where OrderID = @orderId)
	if (lower(@OrderStatus) <> 'confirmed')
	begin
		return -1
	end

	-- Calculate order distance when value is not sent
	if (@orderDistance = 0) 
	begin
		-- TODO: Implements multi source addresses
		declare @sourceAddress nvarchar(200) = '855 W El Camino Real, Mountain View, CA 94040, EE. UU.';
		declare @destinationAddress nvarchar(200) = ( select top 1 sa.Address
													  from [Order] o
			                                          join ShippingAddress sa 
													  on o.ShippingAddressID = sa.ShippingAddressID
													  where o.OrderID =  @orderId 
													)
		-- TODO: Calculate order distance using @sourceAddress / @destinationAddress geolocation.
		-- We are going to simulate order distance calculation returning a fixed value
		set @orderDistance = 500
	end

	-- Get total order weight
	declare @orderWeight int = ( select sum(od.Quantity*p.Weight)
								 from OrderDetail od 
								 join Product p 
								 on od.ProductID = p.ProductID
								 where OrderID = @orderId 
							    )
	
	-- Calculate cost using ShippingCost table parameters
	declare @defaultCost decimal(10,2) = 30;
	declare @cost decimal(10,2);

	if not exists (select TOP 1 Cost 
					from dbo.ShippingCost
					where @orderDistance between MinDistanceKm and MaxDistanceKm
					and @orderWeight between MinOrderWeightKg and MaxOrderWeightKg
				   ) 
	begin
		return @defaultCost
	end

	set @cost = ( select TOP 1 Cost 
				  from dbo.ShippingCost
				  where @orderDistance between MinDistanceKm and MaxDistanceKm
				  and @orderWeight between MinOrderWeightKg and MaxOrderWeightKg
		        )

	return @cost
end
GO

-- Test 01 successfull
    exec usp_processOrders 
    @CustomerID = '8770D47E-5D76-445F-BCAC-F8F51E4EB0DB', --Customer 50
    @OrderDate = '2024-10-31', 
    @ShippingAddress = 'shipping address test two',
    @BillingAddress = 'billing address test two', 
    @ProductID = 'DB6A51DF-39CC-40AE-8D68-2716F64F147B', --Product 5
    @Quantity = 15,
    @Price = 7,
    @DiscountAmout = 20

	-- Use OrderID from previous step
	select OrderID, od.Quantity, p.Weight, od.Quantity*p.Weight as orderWeight
	from OrderDetail od 
	join Product p 
	on od.ProductID = p.ProductID
	where OrderID = 'B99DB350-E782-45F9-9DF0-73B88CCDA1BE' 
	
	-- Compare against shipping cost parameters
	select * from ShippingCost

	-- Calculate shipping cost
	select dbo.ufn_CalculateShippingCost('B99DB350-E782-45F9-9DF0-73B88CCDA1BE', 700)

-- Test 02 with invalid order status

-- Use OrderID from previous step
	execute usp_processOrderReturnOrRefund 
	@OrderID = 'B99DB350-E782-45F9-9DF0-73B88CCDA1BE',
	@OrderStatus = 'returned'

-- Returns invalid shipping cost
   select dbo.ufn_CalculateShippingCost('B99DB350-E782-45F9-9DF0-73B88CCDA1BE', 700)