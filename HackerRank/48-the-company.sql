--this is query to get grouping in each position at company

select c.company_code, max(c.founder), 
count(distinct lm.lead_manager_code) as jumlah_lead_manager,
count(distinct sm.senior_manager_code) as jumlah_senior_manager,
count(distinct m.manager_code) as jumlah_manager,
count(distinct e.employee_code) as jumlah_karyawan

from company c
join lead_manager lm on c.company_code = lm.company_code
join senior_manager sm on lm.lead_manager_code = sm.lead_manager_code
join manager m on sm.senior_manager_code = m.senior_manager_code
join employee e on m.manager_code = e.manager_code
group by c.company_code
order by c.company_code;