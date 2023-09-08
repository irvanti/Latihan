select distinct city
from station
WHERE mod(ID,2) = 0;