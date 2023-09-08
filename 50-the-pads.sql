--this is query to get the list of names with their job initial

select concat(name, '(', left(occupation, 1), ')')
from occupations
order by name;

select concat('There are a total of ', count(name), ' ', lower(occupation), 's.') tot
from occupations
group by occupation
order by tot, occupation;