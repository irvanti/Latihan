-- this is query to get sum populations in California

select sum(population) as total_populasi
from city
where district = "California";