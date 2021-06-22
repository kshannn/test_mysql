-- Chinook Model Database Questions

-- 1
 select firstName, lastName, Title 
    from Employee
    where Title = "Sales Support Agent";

-- 2
select firstName,lastName,YEAR(HireDate) from Employee
    where YEAR(HireDate) = 2002 OR YEAR(HireDate) = 2003;

-- 3
select * from Artist
    where Name like "%metal%";

-- 4
select * from Employee
    where Title like "%sales%";

-- 5
 select * from Genre
    where Name = "easy listening";

-- 6 
select Title as "Album", Track.Name as "Track", Genre.Name as "Genre" from Track
    join Genre on Track.GenreId = Genre.GenreId
    join Album on Track.AlbumId = Album.AlbumId;

-- 7 
select BillingCountry, avg(Total) from Invoice 
    group by BillingCountry;

-- 8 

select BillingCountry, avg(Total) from Invoice 
    group by BillingCountry
    having avg(Total) >= 1.00;


-- 9 (not sure how to write)
select Invoice.CustomerId, avg(Total), sum(Total), Customer.Country from Invoice
    join Customer on Invoice.CustomerId = Customer.CustomerId
    where Country = "Germany" AND sum(Total) = (select sum(Total) from Invoice where sum(Total)>10) 
    group by Invoice.CustomerId, Customer.Country;

AND sum(Total) > 10
need to use sub-query
aggregation can only be in select
Invoice.CustomerId not in (select Invoice.CustomerId, sum(Total) <=10 from Invoice)


select(sum(Total)- select)

-- 10

select Title as "Album Title", Genre.Name as "Genre", Milliseconds from Track 
    join Album on Track.AlbumId = Album.AlbumId
    join Genre on Track.GenreId = Genre.GenreId;
