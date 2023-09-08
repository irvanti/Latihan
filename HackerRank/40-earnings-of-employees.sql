--this is query to get who are having max earnings

select ((salary*months)) as total_earnings, count(name)
from employee
group by total_earnings desc
limit 1;