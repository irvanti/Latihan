--this is query to get the max of lat_n where lat_n less than 137.2345 and answer with truncate to 4 decimals

select max(truncate (lat_n, 4))
from station
where lat_n < 137.2345;