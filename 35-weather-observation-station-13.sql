-- this is query to get the sum lat_n where having values greater than 38.7780 and less than 137.2345. truncate to 4 decimal places

select truncate (sum(lat_n), 4)
from station
where lat_n > 38.7880 and lat_n < 137.2345;