--this is query to get average population in california district

select avg(population) as rata_rata_populasi
from city
where district = "California";