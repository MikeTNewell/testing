-- ASSOCIATE DEPT WITH USER

select fu.user_name, paaf.DEFAULT_CODE_COMB_ID, gcc.segment1, gcc.segment2
from per_all_assignments_f paaf, fnd_user fu, gl_code_combinations gcc
where fu.employee_id = paaf.person_id
and paaf.default_code_comb_id = gcc.code_combination_id
and paaf.effective_end_date > sysdate
--and fu.user_name like 'NELSQUINN'
and segment2 like '2028'


-- FORMS LOGIN SUMMARY
select count(user_id), sum((end_time - start_time) * 24) from fnd_logins where login_id in 
	   (
	select flr.login_id from FND_LOGIN_RESPONSIBILITIES flr, fnd_logins fl, fnd_user fu
	where fl.login_id = flr.login_id 
	  and fl.user_id = fu.user_id
	  and flr.start_time between trunc(sysdate - 1) and trunc(sysdate - 0)
--	  and fu.user_name like 'NELSQUINN'
	  and flr.END_TIME is not null
		)

		
		
--FORMS LOGINS BY DEPARTMENT
select trunc(sysdate - :DaysAgo) Rep_Date, sq.segment2 dept, sq.description, count(fl.user_id) logins, 
       round(sum((fl.end_time - fl.start_time) * 24),2) rt_hrs 
  from fnd_logins fl, (  		
	select fu.user_id, flr.login_id, fu.user_name, gcc.segment2, ffvt.description
	from FND_LOGIN_RESPONSIBILITIES flr, fnd_logins fl, fnd_user fu,
	     per_all_assignments_f paaf, gl_code_combinations gcc, 
		 fnd_flex_values ffv , fnd_flex_values_tl ffvt
	where fl.login_id = flr.login_id 
	  and fu.employee_id = paaf.person_id
	  and paaf.default_code_comb_id = gcc.code_combination_id
	  and gcc.segment2 = ffv.FLEX_VALUE
	  and fl.user_id = fu.user_id
	  and ffv.flex_value_id = ffvt.flex_value_id
	  and paaf.effective_end_date > sysdate
	  and ffv.FLEX_VALUE_SET_ID = 1002611
--	  and fu.user_id = 9283
	  and flr.start_time between trunc(sysdate - :DaysAgo) and trunc(sysdate - :DaysAgo + 28)
	  and flr.END_TIME is not null
	  group by fu.user_id, flr.login_id, fu.user_name, gcc.segment2, ffvt.description
	  ) sq
where fl.login_id = sq.login_id	  
group by sq.segment2, sq.description
order by round(sum((fl.end_time - fl.start_time) * 24),2) desc


--FORMS LOGINS BY ENTITY
select trunc(sysdate - :DaysAgo) Rep_date, sq.segment1 entity, sq.description, count(fl.user_id) logins, 
       nvl(round(sum((fl.end_time - fl.start_time) * 24),2),0) rt_hrs 
  from fnd_logins fl, (  		
	select fu.user_id, flr.login_id, fu.user_name, gcc.segment1, ffvt.description
	from FND_LOGIN_RESPONSIBILITIES flr, fnd_logins fl, fnd_user fu,
	     per_all_assignments_f paaf, gl_code_combinations gcc, 
		 fnd_flex_values ffv , fnd_flex_values_tl ffvt
	where fl.login_id = flr.login_id 
	  and fu.employee_id = paaf.person_id
	  and paaf.default_code_comb_id = gcc.code_combination_id
	  and gcc.segment1 = ffv.FLEX_VALUE
	  and fl.user_id = fu.user_id
	  and ffv.flex_value_id = ffvt.flex_value_id
	  and paaf.effective_end_date > sysdate
	  and ffv.FLEX_VALUE_SET_ID = 1002614
--	  and fu.user_id = 9283
	  and flr.start_time between trunc(sysdate - :DaysAgo) and trunc(sysdate - :DaysAgo + 28)
	  and flr.END_TIME is not null
	  group by fu.user_id, flr.login_id, fu.user_name, gcc.segment1, ffvt.description
	  ) sq
where fl.login_id = sq.login_id	  
group by sq.segment1, sq.description
order by nvl(round(sum((fl.end_time - fl.start_time) * 24),2),0) desc


--COMPUTE AVAILABLE CONCURRENT PROCESSING MINUTES FOR A GIVEN DAY 


select trunc(sysdate - :DaysAgo) rep_date, fcqt.user_concurrent_queue_name, 
       sum(fcqs.min_processes * 
          (trunc((fctp.end_time - fctp.start_time)/100,0) * 60 +
			  mod((fctp.end_time - fctp.start_time), 100) + 1)
		   ) avail_rtm
from fnd_concurrent_queue_size fcqs, fnd_concurrent_time_periods fctp, 
     fnd_concurrent_queues fcq, fnd_concurrent_queues_tl fcqt
where fcqs.CONCURRENT_TIME_PERIOD_ID = fctp.CONCURRENT_TIME_PERIOD_ID
  and fcq.concurrent_queue_id = fcqs.concurrent_queue_id
  and fcq.CONCURRENT_QUEUE_ID = fcqt.CONCURRENT_QUEUE_ID
  and fcq.ENABLED_FLAG = 'Y'
and ((to_char(sysdate - :DaysAgo, 'D') + 0 between fctp.FROM_WEEK_DAY and fctp.TO_WEEK_DAY
	 and to_week_day > from_week_day)
	 or 
	(to_char(sysdate - :DaysAgo, 'D') + 0 between fctp.FROM_WEEK_DAY and fctp.TO_WEEK_DAY + 7
	 and to_week_day < from_week_day
	 and to_char(sysdate - :DaysAgo, 'D') + 0 >= fctp.from_week_day)
	 or 
	(to_char(sysdate - :DaysAgo, 'D') + 7 between fctp.FROM_WEEK_DAY and fctp.TO_WEEK_DAY + 7
	 and to_week_day < from_week_day
	 and to_char(sysdate - :DaysAgo, 'D') + 0 <= fctp.to_week_day)
	 or 
	(to_char(sysdate - :DaysAgo, 'D') + 0 between fctp.FROM_WEEK_DAY and fctp.TO_WEEK_DAY
	 and fctp.to_week_day = fctp.from_week_day))
group by fcqt.user_concurrent_queue_name	 


																		   
--COMPUTE USED CONCURRENT PROCESSING MINUTES by QUEUE FOR A GIVEN DAY
select trunc(sysdate - :DaysAgo), fcqt.USER_CONCURRENT_QUEUE_NAME, count(fcr.request_id) jobs,
sum ((least(fcr.actual_completion_date, trunc(sysdate -:DaysAgo+1)) - greatest(fcr.actual_start_date, trunc(sysdate - :DaysAgo))) 
     * 24* 60) rtm 
from fnd_concurrent_requests fcr, fnd_concurrent_processes fcp, fnd_concurrent_queues_tl fcqt
where fcr.CONTROLLING_MANAGER = fcp.CONCURRENT_PROCESS_ID 
  and fcp.CONCURRENT_QUEUE_ID = fcqt.CONCURRENT_QUEUE_ID
  and (fcr.actual_start_date between trunc(sysdate - :DaysAgo) and trunc(sysdate - :DaysAgo +1)	
   or fcr.actual_completion_date between trunc(sysdate - :DaysAgo) and trunc(sysdate - :DaysAgo + 1))
group by fcqt.USER_CONCURRENT_QUEUE_NAME   

   
--REPORT ON CONCURRENT QUEUE USAGE (AVAIL v ACTUAL)
select sq0.rep_date, sq0.user_concurrent_queue_name, sq0.avail_rtm, 
       round(nvl(sq1.rtm,0),2) act_rtm, nvl(sq1.jobs,0) jobs
from (   
select trunc(sysdate - :DaysAgo) rep_date, fcqt.user_concurrent_queue_name, 
       sum(fcqs.min_processes * 
          (trunc((fctp.end_time - fctp.start_time)/100,0) * 60 +
			  mod((fctp.end_time - fctp.start_time), 100) + 1)
		   ) avail_rtm
from fnd_concurrent_queue_size fcqs, fnd_concurrent_time_periods fctp, 
     fnd_concurrent_queues fcq, fnd_concurrent_queues_tl fcqt
where fcqs.CONCURRENT_TIME_PERIOD_ID = fctp.CONCURRENT_TIME_PERIOD_ID
  and fcq.concurrent_queue_id = fcqs.concurrent_queue_id
  and fcq.CONCURRENT_QUEUE_ID = fcqt.CONCURRENT_QUEUE_ID
  and fcq.ENABLED_FLAG = 'Y'
and ((to_char(sysdate - :DaysAgo, 'D') + 0 between fctp.FROM_WEEK_DAY and fctp.TO_WEEK_DAY
	 and to_week_day > from_week_day)
	 or 
	(to_char(sysdate - :DaysAgo, 'D') + 0 between fctp.FROM_WEEK_DAY and fctp.TO_WEEK_DAY + 7
	 and to_week_day < from_week_day
	 and to_char(sysdate - :DaysAgo, 'D') + 0 >= fctp.from_week_day)
	 or 
	(to_char(sysdate - :DaysAgo, 'D') + 7 between fctp.FROM_WEEK_DAY and fctp.TO_WEEK_DAY + 7
	 and to_week_day < from_week_day
	 and to_char(sysdate - :DaysAgo, 'D') + 0 <= fctp.to_week_day)
	 or 
	(to_char(sysdate - :DaysAgo, 'D') + 0 between fctp.FROM_WEEK_DAY and fctp.TO_WEEK_DAY
	 and fctp.to_week_day = fctp.from_week_day))
group by fcqt.user_concurrent_queue_name	 
) sq0,
(select trunc(sysdate - :DaysAgo), fcqt.USER_CONCURRENT_QUEUE_NAME, count(fcr.request_id) jobs,
sum ((least(fcr.actual_completion_date, trunc(sysdate -:DaysAgo+1)) - greatest(fcr.actual_start_date, trunc(sysdate - :DaysAgo))) 
     * 24* 60) rtm 
from fnd_concurrent_requests fcr, fnd_concurrent_processes fcp, fnd_concurrent_queues_tl fcqt
where fcr.CONTROLLING_MANAGER = fcp.CONCURRENT_PROCESS_ID 
  and fcp.CONCURRENT_QUEUE_ID = fcqt.CONCURRENT_QUEUE_ID
  and (fcr.actual_start_date between trunc(sysdate - :DaysAgo) and trunc(sysdate - :DaysAgo +1)	
   or fcr.actual_completion_date between trunc(sysdate - :DaysAgo) and trunc(sysdate - :DaysAgo + 1))
group by fcqt.USER_CONCURRENT_QUEUE_NAME
) sq1
where sq0.user_concurrent_queue_name = sq1.user_concurrent_queue_name(+) 
order by user_concurrent_queue_name  



