use SQL_Practice_Problems

GO
create view SQLProblems20 as (
select CategoryName, count(p.CategoryID) as TotalProducts from Products as p
join categories as c
on p.CategoryID = c.CategoryID
group by CategoryName
--order by TotalProducts desc
)
GO

create view [dbo].[SQLProblems21] as (
select country,city, count(postalcode) as TotalCustomers from Customers
group by country, city
--order by TotalCustomers desc
)
GO

create view [dbo].[SQLProblems22] as (
select ProductID, ProductName, UnitsInStock, ReorderLevel from products
where UnitsInStock <= ReorderLevel
--order by ProductID
)
GO

create view [dbo].[SQLProblems23] as (
select ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued from Products
where UnitsInStock+UnitsOnOrder <= ReorderLevel
and Discontinued = 0
)
GO

create view [dbo].[SQLproblems24] as (
select top 100 CustomerID,CompanyName,Region from Customers
order by case when region is null then 1 else 0 end, region
)
GO

create view [dbo].[SQLProblems25] as (
select top (3) ShipCountry, avg(freight) as AverageFreight from Orders
group by ShipCountry
order by AverageFreight desc
)
GO

create view [dbo].[SQLProblems26] as (
select top (3) ShipCountry, avg(freight) as AverageFreight from Orders
Where OrderDate like '%2015%'
group by ShipCountry
order by AverageFreight desc
)
GO

create view [dbo].[SQLProblems27] as (
select shipcountry, OrderID,OrderDate,Freight from Orders
Where OrderDate > '20151231 00:00:00.000'
and orderdate < '20160101 00:00:00.000'
and ShipCountry = 'France'
)
GO

create view SQLProblems28 as (
select top(3) ShipCountry, avg(freight) as AverageFreight from Orders
where OrderDate <= (select max(OrderDate) from orders)
and orderdate >= (select dateadd(yyyy,-1,max(orderdate)) from Orders)
group by shipcountry
order by AverageFreight
)
GO

create view SQLProblems29 as (
select top 100 E.EmployeeID, E.LastName, OD.OrderID,P.ProductName, OD.Quantity from Products P
join OrderDetails OD on P.ProductID = OD.ProductID
join Orders O on O.orderID = OD.OrderID
join Employees E on E.EmployeeID = O.EmployeeID
group by E.EmployeeID, E.LastName, OD.OrderID,P.ProductName, OD.Quantity, OD.ProductID
order by OD.OrderID, OD.ProductID
)
GO

select c.CustomerID, o.CustomerID from Customers as C
left join Orders O on c.CustomerID = o.CustomerID
where o.CustomerID is null
group by c.customerid, o.CustomerID
order by c.CustomerID
GO

select c.customerid, o.customerid from Customers c
left join Orders O on o.CustomerID=c.CustomerID and o.EmployeeID = 4
where o.CustomerID is null
GO



