-- this is query to get average population with output rounded down to nearest integer

select round(avg(population), 0) as rata_rata_populasi
from city;