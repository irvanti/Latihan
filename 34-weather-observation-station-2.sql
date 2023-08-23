-- this is query to get the The sum of all values in LAT_N rounded to a scale of  decimal places and The sum of all values in LONG_W rounded to a scale of  decimal places gives name as lat and lot

select round(sum(lat_n), 2) as lat, round(sum(long_w), 2) as lon
from station;