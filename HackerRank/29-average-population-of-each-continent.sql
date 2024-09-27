--this is query to get average populations in every continent by joining two tables

select ct2.continent, floor(avg(ct.population))
from city as ct 
inner join country as ct2 on ct.countrycode = ct2.code
group by ct2.continent;