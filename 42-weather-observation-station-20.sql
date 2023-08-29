--this is query to get median from lat_n and round the answer to 4 decimal

select round((lat_n), 4)
from station
where lat_n > 83.49946581 and lat_n < 83.92116818
order by lat_n;