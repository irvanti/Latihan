--this is query to get how many city with population larger than 100.000

select count(*) as total_kota
from city
where population > 100000;