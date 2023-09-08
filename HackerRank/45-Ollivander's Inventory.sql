--this is query to get the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age and then order desc by power and age

select w.id, wp.age, w.coins_needed, w.power
from wands w
join wands_property wp on w.code = wp.code
where wp.is_evil = 0 and w.coins_needed = (select min(coins_needed) from wands w2 where w.code = w2.code and w.power = w2.power)
order by w.power desc, wp.age desc;