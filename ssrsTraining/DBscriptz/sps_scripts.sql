USE [AdventureWorks2012]
GO
/****** Object:  StoredProcedure [dbo].[ssrsTestDS2]    Script Date: 11/28/2016 5:08:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTestDS2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssrsTestDS2]
GO
/****** Object:  StoredProcedure [dbo].[ssrsTestDS1]    Script Date: 11/28/2016 5:08:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTestDS1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssrsTestDS1]
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask05]    Script Date: 11/28/2016 5:08:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask05]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssrsTask05]
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask02_1]    Script Date: 11/28/2016 5:08:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask02_1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssrsTask02_1]
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask02]    Script Date: 11/28/2016 5:08:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask02]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssrsTask02]
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask01]    Script Date: 11/28/2016 5:08:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask01]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssrsTask01]
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask_bigTricky]    Script Date: 11/28/2016 5:08:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask_bigTricky]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssrsTask_bigTricky]
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask_bigTricky]    Script Date: 11/28/2016 5:08:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask_bigTricky]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssrsTask_bigTricky] AS' 
END
GO
ALTER procedure [dbo].[ssrsTask_bigTricky]
@ProductSubCategory nvarchar(100) = null,
@StartDate date = null,
@EndDate date = null
as
begin
create table #t(i int)
insert into #t (i) values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10)
--select * from #t
SELECT dateadd(year, 9, dateadd(dd, #t.i, soh.OrderDate)) AS [DATE]
--,soh.OrderDate
,soh.SalesOrderNumber + '0' + ltrim(str(#t.i)) AS [Order]
,st.Name AS TerritoryName
,ppc.NAME AS ProductCategory
,pps.NAME AS ProductSubcategory
,pp.NAME AS Product
,sd.OrderQty AS Qty
,sd.LineTotal AS LineTotal
FROM Sales.SalesPerson AS sp
INNER JOIN Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales.SalesOrderDetail AS sd ON sd.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS pp ON sd.ProductID = pp.ProductID
INNER JOIN Production.ProductSubcategory AS pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS ppc ON ppc.ProductCategoryID = pps.ProductCategoryID
INNER JOIN Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
cross join #t
where (@ProductSubCategory is null or pps.Name = @ProductSubCategory)
and (dateadd(year, 9, dateadd(dd, #t.i, soh.OrderDate)) between isnull(@StartDate, '2000-01-01') and isnull(@EndDate, getdate()))
drop table #t
end
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask01]    Script Date: 11/28/2016 5:08:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask01]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssrsTask01] AS' 
END
GO

ALTER procedure [dbo].[ssrsTask01] as
SELECT soh.OrderDate AS DATE
,soh.SalesOrderNumber AS [Order]
,st.Name AS TerritoryName
,ppc.NAME AS ProductCategory
,pps.NAME AS ProductSubcategory
,pp.NAME AS Product
,SUM(sd.OrderQty) AS Qty
,SUM(sd.LineTotal) AS LineTotal
FROM Sales.SalesPerson AS sp
INNER JOIN Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales.SalesOrderDetail AS sd ON sd.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS pp ON sd.ProductID = pp.ProductID
INNER JOIN Production.ProductSubcategory AS pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS ppc ON ppc.ProductCategoryID = pps.ProductCategoryID
INNER JOIN Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
WHERE ppc.NAME = 'Clothing'
GROUP BY ppc.NAME
,soh.OrderDate
,soh.SalesOrderNumber
,pps.NAME
,pp.NAME
,soh.SalesPersonID
,st.Name

GO
/****** Object:  StoredProcedure [dbo].[ssrsTask02]    Script Date: 11/28/2016 5:08:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask02]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssrsTask02] AS' 
END
GO

ALTER procedure [dbo].[ssrsTask02]
@StartDate datetime, @EndDate datetime,
@SalesTerritory nvarchar(max), @ProductCategory nvarchar(max), @ProductSubcategory nvarchar(max)
as
begin
SET NOCOUNT ON;

SELECT soh.OrderDate AS DATE
,soh.SalesOrderNumber AS [Order]
,st.Name AS TerritoryName
,ppc.NAME AS ProductCategory
,pps.NAME AS ProductSubcategory
,pp.NAME AS Product
,SUM(sd.OrderQty) AS Qty
,SUM(sd.LineTotal) AS LineTotal
FROM Sales.SalesPerson AS sp
INNER JOIN Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales.SalesOrderDetail AS sd ON sd.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS pp ON sd.ProductID = pp.ProductID
INNER JOIN Production.ProductSubcategory AS pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS ppc ON ppc.ProductCategoryID = pps.ProductCategoryID
INNER JOIN Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
WHERE soh.OrderDate>=@StartDate and soh.OrderDate<=@EndDate and
st.TerritoryID in (select number from dbo.intlist_to_tbl(@SalesTerritory)) and
ppc.ProductCategoryID in (select number from dbo.intlist_to_tbl(@ProductCategory)) and
pps.ProductSubcategoryID in (select number from dbo.intlist_to_tbl(@ProductSubcategory))
GROUP BY ppc.NAME,soh.OrderDate,soh.SalesOrderNumber,pps.NAME,pp.NAME,soh.SalesPersonID,st.Name
end
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask02_1]    Script Date: 11/28/2016 5:08:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask02_1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssrsTask02_1] AS' 
END
GO

ALTER procedure [dbo].[ssrsTask02_1]
@StartDate datetime, @EndDate datetime,
@SalesTerritory nvarchar(max), @ProductCategory nvarchar(max), @ProductSubcategory nvarchar(max)
as
begin
SET NOCOUNT ON;

if @SalesTerritory like '%English Speaking%'
begin
	set @SalesTerritory = replace(replace(@SalesTerritory,'English Speaking','') + N',1,2,3,4,5,6,9,10',',,',',')
end
SELECT soh.OrderDate AS DATE
,soh.SalesOrderNumber AS [Order]
,st.Name AS TerritoryName
,ppc.NAME AS ProductCategory
,pps.NAME AS ProductSubcategory
,pp.NAME AS Product
,SUM(sd.OrderQty) AS Qty
,SUM(sd.LineTotal) AS LineTotal
FROM Sales.SalesPerson AS sp
INNER JOIN Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales.SalesOrderDetail AS sd ON sd.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS pp ON sd.ProductID = pp.ProductID
INNER JOIN Production.ProductSubcategory AS pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS ppc ON ppc.ProductCategoryID = pps.ProductCategoryID
INNER JOIN Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
WHERE soh.OrderDate>=@StartDate and soh.OrderDate<=@EndDate and
st.TerritoryID in (select number from dbo.intlist_to_tbl(@SalesTerritory)) and
ppc.ProductCategoryID in (select number from dbo.intlist_to_tbl(@ProductCategory)) and
pps.ProductSubcategoryID in (select number from dbo.intlist_to_tbl(@ProductSubcategory))
GROUP BY ppc.NAME,soh.OrderDate,soh.SalesOrderNumber,pps.NAME,pp.NAME,soh.SalesPersonID,st.Name
end
GO
/****** Object:  StoredProcedure [dbo].[ssrsTask05]    Script Date: 11/28/2016 5:08:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTask05]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssrsTask05] AS' 
END
GO

ALTER procedure [dbo].[ssrsTask05]
@StartDate datetime, @EndDate datetime,
@SalesTerritory nvarchar(max), @ProductCategory nvarchar(max), @ProductSubcategory nvarchar(max)
as
begin
SET NOCOUNT ON;

if @SalesTerritory like '%English Speaking%'
begin
	set @SalesTerritory = replace(replace(@SalesTerritory,'English Speaking','') + N',1,2,3,4,5,6,9,10',',,',',')
end
SELECT soh.OrderDate AS DATE
,soh.SalesOrderNumber AS [Order]
,st.Name AS TerritoryName
,st.TerritoryID
,ppc.NAME AS ProductCategory
,ppc.ProductCategoryID
,pps.NAME AS ProductSubcategory
,pps.ProductSubcategoryID
,pp.NAME AS Product
,SUM(sd.OrderQty) AS Qty
,SUM(sd.LineTotal) AS LineTotal
FROM Sales.SalesPerson AS sp
INNER JOIN Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales.SalesOrderDetail AS sd ON sd.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS pp ON sd.ProductID = pp.ProductID
INNER JOIN Production.ProductSubcategory AS pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS ppc ON ppc.ProductCategoryID = pps.ProductCategoryID
INNER JOIN Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
WHERE soh.OrderDate>=@StartDate and soh.OrderDate<=@EndDate and
st.TerritoryID in (select number from dbo.intlist_to_tbl(@SalesTerritory)) and
ppc.ProductCategoryID in (select number from dbo.intlist_to_tbl(@ProductCategory)) and
pps.ProductSubcategoryID in (select number from dbo.intlist_to_tbl(@ProductSubcategory))
GROUP BY ppc.NAME,ppc.ProductCategoryID,soh.OrderDate,soh.SalesOrderNumber,pps.NAME,pps.ProductSubcategoryID,pp.NAME,soh.SalesPersonID,st.Name,st.TerritoryID
end
GO
/****** Object:  StoredProcedure [dbo].[ssrsTestDS1]    Script Date: 11/28/2016 5:08:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTestDS1]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssrsTestDS1] AS' 
END
GO

ALTER procedure [dbo].[ssrsTestDS1] as
SELECT soh.OrderDate AS DATE
,soh.SalesOrderNumber AS [Order]
,st.Name AS TerritoryName
,ppc.NAME AS ProductCategory
,pps.NAME AS ProductSubcategory
,pp.NAME AS Product
,SUM(sd.OrderQty) AS Qty
,SUM(sd.LineTotal) AS LineTotal
FROM Sales.SalesPerson AS sp
INNER JOIN Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales.SalesOrderDetail AS sd ON sd.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS pp ON sd.ProductID = pp.ProductID
INNER JOIN Production.ProductSubcategory AS pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS ppc ON ppc.ProductCategoryID = pps.ProductCategoryID
INNER JOIN Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
WHERE ppc.NAME = 'Clothing'
GROUP BY ppc.NAME
,soh.OrderDate
,soh.SalesOrderNumber
,pps.NAME
,pp.NAME
,soh.SalesPersonID
,st.Name

GO
/****** Object:  StoredProcedure [dbo].[ssrsTestDS2]    Script Date: 11/28/2016 5:08:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssrsTestDS2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssrsTestDS2] AS' 
END
GO

ALTER procedure [dbo].[ssrsTestDS2] as
SELECT soh.OrderDate AS DATE
,soh.SalesOrderNumber AS [Order]
,st.Name AS TerritoryName
,ppc.NAME AS ProductCategory
,pps.NAME AS ProductSubcategory
,pp.NAME AS Product
,SUM(sd.OrderQty) AS Qty
,SUM(sd.LineTotal) AS LineTotal
FROM Sales.SalesPerson AS sp
INNER JOIN Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales.SalesOrderDetail AS sd ON sd.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS pp ON sd.ProductID = pp.ProductID
INNER JOIN Production.ProductSubcategory AS pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS ppc ON ppc.ProductCategoryID = pps.ProductCategoryID
INNER JOIN Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
WHERE ppc.NAME = 'Clothing'
GROUP BY ppc.NAME
,soh.OrderDate
,soh.SalesOrderNumber
,pps.NAME
,pp.NAME
,soh.SalesPersonID
,st.Name

GO
