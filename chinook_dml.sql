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

-- 5 (did wrongly)
select Track.Name from Track join Genre on Track.GenreId = Genre.GenreId where Genre.Name = "Easy Listening";

select Track.Name from Track where GenreId in 
    (Select GenreId from Genre where Name = "easy listening");

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
    having avg(Total) >= 5.50;


-- 9 (not sure how to write)
select Invoice.CustomerId, avg(Total), Customer.Country from Invoice
    join Customer on Invoice.CustomerId = Customer.CustomerId
    where Country = "Germany" 
    group by Invoice.CustomerId, Customer.Country
    having sum(Total) > 10;

AND sum(Total) > 10
need to use sub-query
aggregation can only be in select
Invoice.CustomerId not in (select Invoice.CustomerId, sum(Total) <=10 from Invoice)


select(sum(Total)- select)

-- 10

select Title as "Album Title", Genre.Name as "Genre", avg(Milliseconds)/60000 from Track 
    join Album on Track.AlbumId = Album.AlbumId
    join Genre on Track.GenreId = Genre.GenreId
    where Genre.Name = "Jazz"
    
    group by Title, Genre.Name;
    


