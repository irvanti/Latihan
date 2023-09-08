--this is query to get the print challenge created by each student and  If more than one student created the same number of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result. 


select h.hacker_id, h.name, count(c.challenge_id) as total_challenge
from hackers h
join challenges c on h.hacker_id = c.hacker_id
group by h.hacker_id, h.name
having count(*) = (
    select max(cnt) from 
    (select count(*) as cnt
    from hackers h join challenges c on h.hacker_id = c.hacker_id
    group by h.hacker_id) totals
)
or count(*) in
(
    select cnt2 from
    (select count(*) as cnt2
    from hackers H join challenges c on h.hacker_id = c.hacker_id
    group by h.hacker_id)Totals2
    group by cnt2
    having count(*) = 1
)
order by 3 desc, 1;