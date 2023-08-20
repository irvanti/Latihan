-- this is query to get sum populations in japan

select sum(population) as total_populasi
from city
where countrycode = 'JPN';