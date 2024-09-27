--this is query to print the prime number till max is 1000


--this is query wrote by nickat on comment https://www.hackerrank.com/challenges/print-prime-numbers/forum/comments/402778
set @potential_prime := 1;
set @divisor := 1;
select GROUP_CONCAT(potential_prime SEPARATOR '&')
from (select @potential_prime := @potential_prime + 1 as potential_prime
      from information_schema.tables t1, information_schema.tables t2
      limit 1000) potential_primes
where not exists (select *
                  from (select @divisor := @divisor + 1 as divisor
                        from information_schema.tables t3, information_schema.tables t4
                        limit 1000) divisors
                  where MOD(potential_prime, divisor) = 0
                        and potential_prime <> divisor);