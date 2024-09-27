--this is query to print total number of unique hackers who made at least 1 submission each day (starting on the first day of the contest), 
--and find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date

--i get the answer this from lalwanijayes github

select t1.submission_date, t1.unique_submissions, t2.hacker_id, t3.name
from (select submission_date, count(distinct hacker_id) unique_submissions
      from submissions s
      where select count(distinct submission_date) from submissions
             where hacker_id = s.hacker_id and submission_date < s.submission_date)
            = datediff(s.submission_date, '2016-03-01')
      group by submission_date) t1
join (select submission_date,
      (select hacker_id from submissions
       where submission_date = s.submission_date group by hacker_id
       order by COUNT(submission_id) desc, hacker_id limit 1) hacker_id
      from (select distinct submission_date from submissions) s) t2
on t1.submission_date = t2.submission_date
join hackers t3
on t2.hacker_id = t3.hacker_id
order by submission_date;