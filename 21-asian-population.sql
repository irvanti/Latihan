--This is a query for the sum population in the Asia continent.

select sum(ct.population) as rata_rata_populasi
from city as ct inner join country as ct2
on ct.countrycode = ct2.code
where ct2.continent = 'Asia';
