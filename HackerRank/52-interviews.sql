--this is query to print to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are 0.

select c.contest_id, c.hacker_id, c.name,
        sum(total_submissions) as total_submissions,                                               sum(total_accepted_submissions) as total_accepted_submissions, 
        sum(total_views) as total_views, 
        sum(total_unique_views) as total_unique_views
from contests c
left join colleges co on c.contest_id = co.contest_id
left join challenges ch on co.college_id = ch.college_id
left join (select challenge_id, sum(total_views) as total_views, 
                                sum(total_unique_views) as total_unique_views 
           from view_stats 
           group by challenge_id) as vs
    on ch.challenge_id = vs.challenge_id
left join (select challenge_id, sum(total_submissions) as total_submissions,                                               sum(total_accepted_submissions) as total_accepted_submissions
            from submission_stats
            group by challenge_id) as ss
    on ch.challenge_id = ss.challenge_id
group by c.contest_id, c.hacker_id, c.name
having (total_submissions + total_accepted_submissions + total_views + total_unique_views) > 0
order by c.contest_id;