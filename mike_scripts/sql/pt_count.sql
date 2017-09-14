
set pagesize 20
spool pt_count.out

  select trunc(sysdate) - 1 rpt_date, count(*) prime_time_jobs 
    from fnd_concurrent_requests
   where actual_start_date 
 between trunc(sysdate -1) + (8/24) 
     and trunc(sysdate -1) + (17/24)
				
/
spool off
exit