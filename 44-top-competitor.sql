--this is query to get hacker_id and name of hackers who achieved full scores for more than one challenge and order desc by total challenges and  If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.

select h.hacker_id, h.name
from hackers h
join submissions s on h.hacker_id = s.hacker_id
join challenges c on s.challenge_id = c.challenge_id
join difficulty d on c.difficulty_level = d.difficulty_level
where d.score = s.score
group by h.hacker_id, h.name
having count(*) > 1
order by count(*) desc, 1;