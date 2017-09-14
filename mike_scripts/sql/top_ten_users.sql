
set pagesize 20
column user_name format a50

spool top_ten_users.out

select user_name, jobs from (
        select substr(fu.user_name, 1, 50) user_name,
               count(*) jobs, rank() over(order by count(*) desc) Ranking
          from fnd_concurrent_requests fcr, 
               fnd_user fu
         where fcr.requested_by = fu.user_id 
           and fcr.actual_start_date
       between trunc(sysdate -1)
           and trunc(sysdate -0)
           and fu.user_name not in ('CCASCHEDULER','PRELIM')
      group by fu.user_name
            )
 where Ranking <= 10                  
/
spool off
exit