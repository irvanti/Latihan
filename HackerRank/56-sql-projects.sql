--this is query to finding the total number of different projects completed.
--Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project.

--this is query from talibabbas32 at discussion group hackerrank

select start_date,end_date 
from
(select start_date,row_number() over() as R 
 from projects 
 where start_date not in(select end_date from Projects order by end_date) 
 order by start_date) as S 
 inner join (select end_date,row_number() over() as R from projects where end_date not in(select start_date from projects order by start_date)order by eNd_date) E 
 on S.R=E.R 
 order by (start_date-end_date)desc;