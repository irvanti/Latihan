--this is query to get smallest northen lat_N and round 4 decimal

select round(min(lat_n), 4)
from station
where lat_n > 38.7780