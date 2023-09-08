--this is query to get the total skor from maximum scores for all of the challenges and order total score desc,  If more than one hacker achieved the same total score, then sort the result by ascending hacker_id

select ms.hacker_id, h.name, sum(ms.max_score) as total_skor
from (select hacker_id, max(score) as max_score
      from submissions
      group by hacker_id, challenge_id
      having max(score) > 0 )as ms
join hackers h on h.hacker_id = ms.hacker_id
group by ms.hacker_id, h.name
order by total_skor desc, ms.hacker_id;