-- this is query to get the manhattan distance between points P1 and P2 and round it to scale of 4 decimal

select round(abs(min(lat_n) - max(lat_n)) + abs(min(long_w) - max(long_w)), 4)
from station;