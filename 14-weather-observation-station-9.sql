select distinct city
from station
where not city like 'a%' and not city like 'i%' and not city like 'u%' and not city like 'e%' and not city like 'o%';