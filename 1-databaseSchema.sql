IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'WAVERLEY_CHALLENGE_GMV')
BEGIN
    CREATE DATABASE WAVERLEY_CHALLENGE_GMV;
END
USE WAVERLEY_CHALLENGE_GMV
GO
/****** Object:  Table [dbo].[BillingAddress]    Script Date: 11/21/2024 4:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillingAddress](
	[BillingAddressID] [bigint] IDENTITY(1,1) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BillingAddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 11/21/2024 4:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](50) NOT NULL,
	[CategoryDescription] [nvarchar](max) NULL,
	[ParentCategoryID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 11/21/2024 4:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [uniqueidentifier] NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Address] [nvarchar](200) NULL,
	[ShippingAddress] [nvarchar](200) NULL,
	[BillingAddress] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 11/21/2024 4:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [uniqueidentifier] NOT NULL,
	[CustomerID] [uniqueidentifier] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[OrderStatus] [nvarchar](50) NULL,
	[ShippingAddressID] [bigint] NOT NULL,
	[BillingAddressID] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 11/21/2024 4:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[OrderDetailID] [uniqueidentifier] NOT NULL,
	[OrderID] [uniqueidentifier] NOT NULL,
	[ProductID] [uniqueidentifier] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[DiscountAmount] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 11/21/2024 4:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [uniqueidentifier] NOT NULL,
	[ProductName] [nvarchar](255) NOT NULL,
	[CategoryID] [int] NULL,
	[Price] [decimal](10, 2) NULL,
	[StockQuantity] [int] NULL,
	[ProductDescription] [nvarchar](max) NULL,
	[ProductImage] [varbinary](max) NULL,
	[Weight] [decimal](10, 2) NULL,
	[WeightUnit] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingAddress]    Script Date: 11/21/2024 4:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingAddress](
	[ShippingAddressID] [bigint] IDENTITY(1,1) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ShippingAddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingCost]    Script Date: 11/21/2024 4:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingCost](
	[MinDistanceKm] [int] NOT NULL,
	[MaxDistanceKm] [int] NOT NULL,
	[MinOrderWeightKg] [int] NOT NULL,
	[MaxOrderWeightKg] [int] NOT NULL,
	[Cost] [decimal](10, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (newid()) FOR [CustomerID]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT (newid()) FOR [OrderID]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  DEFAULT (newid()) FOR [OrderDetailID]
GO
ALTER TABLE [dbo].[Product] ADD  DEFAULT (newid()) FOR [ProductID]
GO
ALTER TABLE [dbo].[Category]  WITH CHECK ADD FOREIGN KEY([ParentCategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([BillingAddressID])
REFERENCES [dbo].[BillingAddress] ([BillingAddressID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([ShippingAddressID])
REFERENCES [dbo].[ShippingAddress] ([ShippingAddressID])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [CHK_OrderStatus] CHECK  (([OrderStatus]='Refunded' OR [OrderStatus]='Returned' OR [OrderStatus]='Confirmed'))
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [CHK_OrderStatus]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CHK_ProductWeight] CHECK  (([Weight]>(0)))
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CHK_ProductWeight]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CHK_ProductWeightUnit] CHECK  (([WeightUnit]='kg'))
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CHK_ProductWeightUnit]
GO
