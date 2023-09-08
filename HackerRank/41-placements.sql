-- this is query to get who's salary friend is higher than id

select s.name
from students s
inner join friends f on s.id = f.id
inner join packages p on s.id = p.id
inner join packages p2 on f.friend_id = p2.id
where p2.salary > p.salary
order by p2.salary;