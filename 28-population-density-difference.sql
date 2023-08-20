--this is query to get how many difference between max population and min populations

select (max(population)-min(population)) as difference 
from city;