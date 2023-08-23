--thisis query to get long w by on smallest lat_n greater than 38.7780 and round your answer to 4 decimal

select round(long_w, 4)
from station
where lat_n = (select min(lat_n) from station where lat_n > 38.7780); 