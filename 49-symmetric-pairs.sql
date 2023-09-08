--this is quey to get the symetrics pair from columns x and y

select f1.x, f1.y
from functions f1
join functions f2 on f1.x = f2.y and f1.y = f2.x
group by f1.x, f1.y
having count(f1.x) > 1 or f1.x < f1.y
order by f1.x;