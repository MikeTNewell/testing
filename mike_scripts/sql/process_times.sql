set lines 150;
clear col;
col requestor for a15;
col PROGRAM for a25;
col Time_SP for 999.99;
select  substr(user_concurrent_program_name ,1,25) PROGRAM,request_id,
        to_char(actual_start_date,'MM/DD/YY HH24:MI:SS') "Start_date",
        to_char(actual_completion_date,'MM/DD/YY HH24:MI:SS') "End_date" ,
        (actual_completion_date - actual_start_date)*1440 Time_SP,
        requestor,
ofile_size,
 lfile_size
from apps.fnd_conc_requests_form_v a
where phase_code='C'
  and status_code='C'
  and (actual_completion_date - actual_start_date)*1440 >30
  and to_char(actual_start_date,'MM/DD/YY HH24') > '03/31/07 22'
  and to_char(actual_completion_date,'MM/DD/YY HH24') < '04/01/07 10'
order by 2;