--this is query to calculating the amount of error (actual - miscalculated average monthly salaries) and round it up to the next integer

select ceil(avg(salary) - avg(replace(salary, '0', '')))
from employees;