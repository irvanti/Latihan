-- this is query to get the name all cities in africa's continent

select ct.name
from city as ct
inner join country as ct2 on ct.countrycode = ct2.code
where ct2.continent = 'Africa';