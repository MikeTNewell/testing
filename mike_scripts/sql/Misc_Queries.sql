----------------------------------------------------------------------------------------------------------------
-- Below are miscellanies queries
----------------------------------------------------------------------------------------------------------------

-- These statements are usually requested for me to run.
-- Last update 05/17/2005

-- Requested by Mara June on 5/16/2005
select name, value from v$parameter where name like 'cursor_sharing';

-- See the file size of a report in Oracle
-- Substitute the value in the "request_id"
select OFILE_SIZE from FND_CONCURRENT_REQUESTS where REQUEST_ID = 6996003;

-- The GL posting count
-- Placing a condition to test this value against 0 at the start of any GL-data-dependent 
-- chain (with it not releasing the chain to start until the value of the subvar=0) will 
-- prevent any stale data problems caused by the chain starting before the posting process had finished.
select substrb(count(*),1,512) post_count
from applsys.fnd_concurrent_requests
where concurrent_program_id = 101
and program_application_id = 101
and phase_code = 'R';

-- This is to test the column set name.  A parameter in the Budgets reports
-- Substitute the number in the "axis_set_id"
select axis_set_id, name
from rg_report_axis_sets
where axis_set_id = 7568;

-- Requested by Mara June on May 24th 2005
select * from v$NLS_PARAMETERS;

-- Check what ran for a certain date
select SO_module, so_start_date, so_jobid, so_status_name, 
so_job_started, so_job_finished, so_request_date, so_chain_id, so_operator
from so_job_history
where so_job_started between to_date('16-JUN-2004 11:45:00 AM', 'DD-MON-YYYY HH:MI:SS PM') and to_date('17-JUN-2004 12:00:00 PM', 'DD-MON-YYYY HH:MI:SS PM')
order by so_job_started;

-- Find information on a certain request group
select * from applsys.fnd_request_groups
where request_group_name like 'CCSC Payroll Manager';

-- Find which responsibilty goes with request group id
select * from applsys.fnd_responsibility
where request_group_id like '518';


select * from rg_report_content_sets;

-- This is for alert maintenance
select * from alr_actions 
  where to_recipients like '%nels%'
     or cc_recipients like '%nels%'

select * from alr_alerts where alert_id = 100421
where table_name like 'ALR%';

select * from alr_actions --where upper() like '%Authorization%'

----------------------
-- This is for finding the correct ids for FSG runs
select name, row_set_id, column_set_id, report_id, parameter_set_id, content_set_id, row_order_id, report_display_set_id
 from rg.rg_reports 
  where report_id = 19611
  or report_id = 20244
  or report_id = 20379
  or report_id = 20644
  or report_id = 19563;

select * from rg.rg_reports where name = 'Budget 2006 Dept IS' -- this equals 4819

select column_set_id from rg.rg_reports where name = 'CLUB - Dept I/S Projection-13' -- this equals 1591

select parameter_set_id from rg.rg_reports where name = 'CLUB - Dept I/S Projection-13' -- this equals 5018
-------------------------------------------------------------------------------------------------------------

select * from fnd_concurrent_programs where concurrent_program_name = 'FNDREPRINT'

select * from fnd_concurrent_programs where application_id = 0;

select * from fnd_concurrent_requests where request_id = 7299997

select * from fnd_concurrent_requests where concurrent_program_id = 98
--and argument2 = '05b18hp4050'

------------------------------------------------------------------------------------------
set linesize 256
set pagesize 0
set verify off
set feedback off
spool $SQLOPER_HOME/exec/lp_script.sh
select substrb('cat $SQLOPER_HOME/exec/init_string.txt '|| outfile_name ||' > $SQLOPER_HOME/exec/'||substrb(outfile_na
me, -7)||'.prn', 1, 256)
from applsys.fnd_concurrent_requests
where request_id in (
        select so_ref1 from aw_job_history
        where so_chain_id = &ChainID
        and so_module in ('CONC_REQ_JOB'))
and (ofile_size < 2700 and concurrent_program_id = 1002429)
/
select substrb('lp -c -d&PrintQueueName -n1 -tTEST '|| ' $SQLOPER_HOME/exec/'||substrb(outfile_name,-7)||'.prn', 1, 25
6)
from applsys.fnd_concurrent_requests
where request_id in (
        select so_ref1 from aw_job_history
        where so_chain_id = &ChainID
        and so_module in ('CON_REQ_JOB'))
and (ofile_size < 2700 and concurrent_program_id = 1002429)
/
select substrb('rm $SQLOPER_HOME/exec/'||substrb(outfile_name,-7)||'.prn', 1, 256)
from applsys.fnd_concurrent_requests
where parent_request_id in (
        select so_ref1 from aw_job_history
        where so_chain_id = &ChainID
        and so_module in ('FED_STATE_TAX_REMIT_MGR','LOCAL_TAX_REMIT_MGR'))
and ((ofile_size > 2700 and concurrent_program_id = 1002100)
     or (ofile_size > 1720 and concurrent_program_id = 39553)
     or (ofile_size > 2700 and concurrent_program_id = 39552))
/
spool off
exit
--------------------------------------------------------------------------------------------------

select substrb('/linapps/appl/linappl/chr/1.0.0/data/mastertax/MTAX_RTS_'|| so_ref1 ||'.TXT', 1, 256) 
from aw_job_history
        where so_chain_id = &ChainID
        and so_module in ('MAST_TAX_RTS_FILE_CREATE')
		and so_status_name = 'FINISHED'
		
----------------------------------------------------------------------------------------------------------------	
/*set linesize 256
set pagesize 0
set verify off
set feedback off
spool $SQLOPER_HOME/exec/lp_script3.sh	
*/

select substrb('cat $SQLOPER_HOME/exec/init_string.txt '|| outfile_name ||' > $SQLOPER_HOME/exec/'||substrb(outfile_name, -7)||'.prn', 1, 256)
from applsys.fnd_concurrent_requests
where request_id in (
        select so_ref1 from aw_job_history
        where so_chain_id = &ChainID
        and so_module in ('CONC_REQ_JOB'))
and (ofile_size < 2700 and concurrent_program_id = 1002429)
union
select substrb('lp -c -d&PrintQueueName -n1 -tTEST '|| ' $SQLOPER_HOME/exec/'||substrb(outfile_name,-7)||'.prn', 1, 256)
from fnd_concurrent_requests
where request_id in (
        select so_ref1 from aw_job_history
        where so_chain_id = &ChainID
        and so_module in ('CONC_REQ_JOB'))
and (ofile_size < 2700 and concurrent_program_id = 1002429)
union
select substrb('rm $SQLOPER_HOME/exec/'||substrb(outfile_name,-7)||'.prn', 1, 256)
from applsys.fnd_concurrent_requests
where request_id in (
        select so_ref1 from aw_job_history
        where so_chain_id = &ChainID
        and so_module in ('CONC_REQ_JOB')
and (ofile_size < 2700 and concurrent_program_id = 1002429))

--spool off
--exit
-----------------------------------------------------------------------------------------------------

select hr.meaning from hr_lookups hr 
WHERE hr.lookup_type = 'US_QUARTER_END_DATES' 
and hr.enabled_flag = 'Y' 
and 
(select MAX(gl.quarter_num) from gl_periods gl
where trunc(sysdate) > trunc(gl.quarter_start_date)
and gl.period_set_name = 'Period Calendar'
and trunc(gl.period_year) = to_char(sysdate, 'yyyy')
and trunc(gl.quarter_start_date) = trunc(start_date)) = hr.lookup_code 
--ORDER BY lookup_code

select * from gl_periods gl
where trunc(sysdate) > trunc(gl.quarter_start_date)
and gl.period_set_name = 'Period Calendar'
and trunc(gl.period_year) = to_char(sysdate, 'yyyy')
and trunc(gl.quarter_start_date) = trunc(start_date)

-- Find the period name for the quater
select MAX(period_name) from gl.gl_periods@qalerp1
where trunc(sysdate) > trunc(quarter_start_date)
and period_set_name = 'Period Calendar'
and trunc(period_year) = to_char(sysdate, 'yyyy')
and trunc(quarter_start_date) = trunc(start_date)
---------------------------------------------------------------------------
-- Find init string
--set pagesize 0
--set linesize 256
--set feedback off
--set verify off

--spool $SQLOPER_HOME/exec/init_string.txt

select substrb(translate(initialization, '/e', '^['),1,256)
from applsys.fnd_printer_drivers
where printer_driver_name like 'HPLJLANDWIDE'

--where initialization = '/eE/e&l1O/e&l2A/e(s0P/e(s17.5H/e(8U/e&l8D/e&k2G/e&l5.45C/e&l1S'
--ere initialization = '%l1S%'
  
--printer_driver_name = (


select printer_driver from applsys.fnd_printer_information
where printer_type = (
          select printer_type from applsys.fnd_printer
          where printer_name like '&PrinterName' )
and printer_style ='HPLJ-Landwide'
--/

--spool off
--exit
----------------------------------------------------------------------------

select * from applsys.fnd_printer where printer_type like '%WEST%'

select request_id, argument_text, printer, print_style, number_of_copies 
from fnd_concurrent_requests where request_id = 7332161

-- This is for the MAMS Budget process for the Budget name
select * from gl_budget_versions bv, gl_budgets b
where bv.budget_name = b.budget_name
--and   b.set_of_books_id = :$PROFILES$.GL_SET_OF_BKS_ID
and b.budget_name = '2006 BUDGET'
order by upper(b.budget_name)

--Check for entities
select ffvt.FLEX_VALUE_MEANING||' - '||ffvt.DESCRIPTION 
from applsys.fnd_flex_values_tl ffvt, applsys.fnd_flex_values ffv
where ffv.flex_value_id = ffvt.flex_value_id 
and ffvt.flex_value_meaning like :MyFlex
and ffv.flex_value_set_id = 1002614

select outfile_name from fnd_concurrent_requests where request_id = 7582070

----------------------------------------------------------------------------------------------------------
-- The following are for discoverer setups
----------------------------------------------------------------------------------------------------------
select 'CREATE USER '||:NewUser||' identified by '||:NewPass from dual
union 
select 'DEFAULT TABLESPACE NOETIXVIEWS TEMPORARY TABLESPACE NOETIX_TEMP  PROFILE DEFAULT  ACCOUNT UNLOCK;'
from dual



------------------------------------------------------------------
--SCRIPT TO CREATE DATABASE PRIVS FOR NEW USER (run in TOAD or SQL*Plus)
------------------------------------------------------------------

select 'grant '||dsp.privilege||' to '||:NewUser||';'
from dba_sys_privs dsp
where grantee like :SourceUser
union
select 'GRANT '||drp.granted_role||' to '||:NewUser||';'
from dba_role_privs drp
where grantee like :SourceUser
union
select 'grant select on '||owner||'.'||table_name||' to '||:NewUser||';'
from dba_tab_privs
where grantee like :SourceUser
and privilege like 'SELECT'
union
select 'grant execute on '||owner||'.'||table_name||' to '||:NewUser||';'
from dba_tab_privs
where grantee like :SourceUser
and privilege like 'EXECUTE'


-- SCRIPT TO CREATE EULAPI INPUT FILE 
----------------------------------
----------------------------------
-- run on Discoverer AS server  (ie dallinux60) 
-- 1) run $ORACLE_HOME/discoverer/discwb.sh
-- 2) save this query's output as a text file (user_grants.txt)
-- 3) run eulapi -connect eul_owner/eul_owner_pwd@db -cmdfile user_grants.txt -log mylog.txt
----------------------------------
----------------------------------
select '-grant_privilege -privilege all_user_privs -user '||:NewUser
from dual
union
select '-grant_privilege -identifier -business_area_access '||e5b.BA_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_BAS e5b
where ba_id in (
select gba_ba_id from eul5_owner.eul5_access_privs
where ap_type like 'GBA'
and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :SourceUser)
)
union
select '-grant_privilege -identifier -workbook_access '||ed.DOC_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_documents ed
where doc_id in (
select gd_doc_id from eul5_owner.eul5_access_privs
where ap_type like 'GD'
and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :SourceUser)
)
union
select '-grant_privilege -identifier -workbook_access '||ed.DOC_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_documents ed
where ed.DOC_EU_ID = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :SourceUser)




---

--SCRIPT TO IDENTIFY WHETHER THE NEW USER IS ALREADY PRESENT IN THE NOETIX QUERY USERS
select * from eul5_noetix_sys.n_query_users where user_name like :NewUser


--SCRIPT TO ADD THE NEW USER TO THE NOETIX QUERY USERS

insert into eul5_noetix_sys.n_query_users (
select :NewUser, user_type, language_code, create_optimizing_views, create_synonyms,
       security_rules, delete_flag, gl_security_type_code
from eul5_noetix_sys.n_query_users
where user_name like :SourceUser)


---------------------------------------
---------------------------------------
--SCRIPT TO IDENTIFY THE BUSINESS AREAS 
--RELATED TO OBJECTS 
--REFERENCED BY THE WORKBOOKS
--SHARED WITH A GIVEN USER ACCT
---------------------------------------
---------------------------------------
select * from eul5_owner.eul5_bas
where ba_id in (
select bol_ba_id from eul5_owner.EUL5_BA_OBJ_LINKS
where bol_obj_id in (
	  select obj_id from eul5_owner.eul5_objs
	  where obj_developer_key in (
		  select ex_to_par_devkey --* --ex_to_id
		  from eul5_owner.EUL5_ELEM_XREFS
		  where ex_to_type = 'ITE' 
		  and ex_from_type = 'DOC'
		  and ex_from_id in (
		  select gd_doc_id
		   from eul5_owner.eul5_access_privs
		    where ap_type like 'GD'
			 and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :NewUser)
			 )
			)	 
	      )
		)	

		



		
--EULAPI script to revoke all workbooks and business areas for a given user		
select '-revoke_privilege -identifier -workbook_access '||ed.DOC_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_documents ed
where doc_id in (
select gd_doc_id from eul5_owner.eul5_access_privs
where ap_type like 'GD'
and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :RemoveUser))
union
select '-revoke_privilege -identifier -business_area_access '||e5b.BA_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_BAS e5b
where ba_id in (
select gba_ba_id from eul5_owner.eul5_access_privs
where ap_type like 'GBA'
and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :RemoveUser)
)
		
		
--Script to revoke all db privs from user
select 'revoke '||dsp.privilege||' from '||:NewUser||';'
from dba_sys_privs dsp
where grantee like :RemoveUser
union
select 'revoke '||drp.granted_role||' from '||:NewUser||';'
from dba_role_privs drp
where grantee like :RemoveUser
union
select 'revoke select on '||owner||'.'||table_name||' from '||:NewUser||';'
from dba_tab_privs
where grantee like :RemoveUser
and privilege like 'SELECT'
union
select 'revoke execute on '||owner||'.'||table_name||' from '||:NewUser||';'
from dba_tab_privs
where grantee like :RemoveUser
and privilege like 'EXECUTE'
		
		
--DOCUMENT ACCESS FOR NAMED USER		
select eeu.eu_username, edo.EU_USERNAME||'.'||ed.DOC_NAME 
from eul5_owner.eul5_eul_users eeu, eul5_owner.eul5_access_privs eap,
     eul5_owner.eul5_documents ed, eul5_owner.eul5_eul_users edo
where eeu.EU_ID = eap.AP_EU_ID
and eap.GD_DOC_ID = ed.DOC_ID
and ed.DOC_EU_ID = edo.EU_ID
and eeu.eu_username like :MyUser

	
--EXPORT OF WORKBOOKS FOR ID'ed USER	
select '-export /home/oradis1/eulapi_scripts/wbs/wb'||doc_id||'.xml -workbook '||doc_developer_key||' -identifier' 
from eul5_owner.eul5_documents
where doc_eu_id = 342971
	
-------------------------------------------------------------------------------------------------------------------------
-- End of discoverer queries
-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------
-- Performance Testing queries
-------------------------------------------------------------------------------------------------------------------------

select fcp.USER_CONCURRENT_PROGRAM_NAME, fu.user_name,
fcr.ACTUAL_START_DATE, fcr.ACTUAL_COMPLETION_DATE, fcr.argument_text,
round((nvl(fcr.ACTUAL_COMPLETION_DATE, sysdate) - fcr.ACTUAL_START_DATE)*24*60,2) minutes
from applsys.fnd_concurrent_requests fcr, 
     applsys.fnd_concurrent_programs_tl fcp, 
	 applsys.fnd_user fu, 
	 applsys.fnd_responsibility_tl fr 
where -- fcr.phase_code like 'R'
--and 
fcr.CONCURRENT_PROGRAM_ID = fcp.CONCURRENT_PROGRAM_ID
and fcr.PROGRAM_APPLICATION_ID = fcp.APPLICATION_ID
and fu.user_id = fcr.REQUESTED_BY
and fcr.RESPONSIBILITY_ID = fr.RESPONSIBILITY_ID
and fu.user_name = 'DMORALES'
--and fcr.ACTUAL_START_DATE > sysdate - 7
--and (fcr.actual_start_date between trunc(sysdate- :DaysAgo) + 6/24 and trunc(sysdate- :DaysAgo +1) + 6/24
--or fcr.actual_completion_date between trunc(sysdate- :DaysAgo) + 6/24 and trunc(sysdate- :DaysAgo+1) + 6/24
--or (fcr.actual_start_date < trunc(sysdate- :DaysAgo) + 6/24 
--    and fcr.actual_completion_date > trunc(sysdate- :DaysAgo+1) + 6/24))
	
	
select * from fnd_profile_option_values 
where last_update_date > sysdate - 7	


select * from gl_je_batches
where name like '%Sys36%Inf%'
and default_period_name like 'Per13-03'
and set_of_books_id = 1

select fcp.USER_CONCURRENT_PROGRAM_NAME, --fu.user_name,
fcr.ACTUAL_START_DATE, fcr.ACTUAL_COMPLETION_DATE,
round((nvl(fcr.ACTUAL_COMPLETION_DATE, sysdate) - fcr.ACTUAL_START_DATE)*24*60,2) minutes,
fcr.ARGUMENT_TEXT
from applsys.fnd_concurrent_requests fcr, 
     applsys.fnd_concurrent_programs_tl fcp, 
	 applsys.fnd_user fu, 
	 applsys.fnd_responsibility_tl fr 
where --fcr.phase_code like 'R'
fcr.CONCURRENT_PROGRAM_ID = fcp.CONCURRENT_PROGRAM_ID
and fcr.PROGRAM_APPLICATION_ID = fcp.APPLICATION_ID
and fu.user_id = fcr.REQUESTED_BY
and fcr.RESPONSIBILITY_ID = fr.RESPONSIBILITY_ID
--and fu.user_name = 'BAWILLIAMS'
and fu.user_name = 'DMORALES'
and fu.user_name != 'ANONYMOUS'
and fcp.USER_CONCURRENT_PROGRAM_NAME = 'CCHR Timecard Batch Verification'

---

--and fcr.REQUESTED_BY != -1
--and fu.user_id = 'CCAREPORTS'
--and fcp.USER_CONCURRENT_PROGRAM_NAME != 'Reprints output from concurrent requests'
--and fcp.USER_CONCURRENT_PROGRAM_NAME != 'Purge Concurrent Request and/or Manager Data'
--and fcp.USER_CONCURRENT_PROGRAM_NAME != 'Periodic Alert Scheduler'
--and fcp.USER_CONCURRENT_PROGRAM_NAME != 'Posting'
--and fcp.USER_CONCURRENT_PROGRAM_NAME != 'Journal Import'
--and fcp.USER_CONCURRENT_PROGRAM_NAME != 'Program - Automatic Posting'
--and fcp.USER_CONCURRENT_PROGRAM_NAME != 'Program - Maintain Budget Organization' 

or fcp.USER_CONCURRENT_PROGRAM_NAME = 'CCHR Departmental Earnings Report'
--and fcr.ACTUAL_START_DATE > sysdate - 7
--and (fcr.actual_start_date between trunc(sysdate- :DaysAgo) + 6/24 and trunc(sysdate- :DaysAgo +1) + 6/24
--or fcr.actual_completion_date between trunc(sysdate- :DaysAgo) + 6/24 and trunc(sysdate- :DaysAgo+1) + 6/24
--or (fcr.actual_start_date < trunc(sysdate- :DaysAgo) + 6/24 
--and fcr.actual_completion_date > trunc(sysdate- :DaysAgo+1) + 6/24))
  



select *--substrb(file_name,1,512) 
from cchr_investment_time_periods_v@qalerp1
where payroll_id = 68
and trunc(sysdate - 38) between effective_date and regular_payment_date + 1

select * from fnd_concurrent_requests where request_id = 7265061


select fcp.USER_CONCURRENT_PROGRAM_NAME, fr.RESPONSIBILITY_NAME, fu.user_name, fcr.* 
from fnd_concurrent_requests fcr, fnd_concurrent_programs_tl fcp, fnd_user fu, fnd_responsibility_tl fr
where ((fcr.phase_code = 'P' 
and fcr.status_code in ('I','Q'))
or ((fcr.resubmit_interval is not null
or fcr.RESUBMIT_TIME is not null) and fcr.phase_code <> 'C'))
and fcr.CONCURRENT_PROGRAM_ID = fcp.CONCURRENT_PROGRAM_ID
and fcr.requested_by = fu.user_id
and fcr.RESPONSIBILITY_ID = fr.responsibility_id
and fcr.program_application_id = fcp.application_id

--------------------------------------------------------------------------------------------------------------------------
-- End of Performace test queries
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- Payroll Performance test
--------------------------------------------------------------------------------------------------------------------------
-- This script produceses output for payroll processing

col requestor format a15
break on "Run Date" skip 1
compute avg of "Run Mins" on "Run Date"

select
 trunc(requested_start_date) "Run Date",
 request_id request,
 requestor,
 decode(status_code, 'E', 'Error', 'G', 'Warning', 'I', 'Normal', 'C', 'Normal', 
  'R', 'Normal', 'D', 'Cancelled', 'X', 'Term', 'Other: '||status_code) Status,
 to_char(requested_start_date, 'HH24:MI:SS') "Start Time",
 to_char(actual_completion_date, 'HH24:MI:SS') "Finish Time",
 round((actual_completion_date-requested_start_date)*1440,0) "Run Mins"
from apps.fnd_conc_req_summary_v 
where phase_code = 'C'
and request_id in (select parent_request_id
from apps.fnd_conc_req_summary_v
where user_concurrent_program_name='Payroll Process')
order by Actual_start_date desc
/

----------------------------------------------------------------------------------------------------------------
-- End of Payroll Performance Test
----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------
-- For finding prompt values in Appworx.
----------------------------------------------------------------------------------------------------------------
/* Formatted on 2007/02/05 10:19 (Formatter Plus v4.5.2) */
SELECT so_job_table.so_module, so_job_prompts.so_prompt_dflt
  FROM so_job_prompts, so_job_table
 WHERE (    (so_job_table.so_job_seq = so_job_prompts.so_job_seq)
        AND (so_job_prompts.so_prompt_dflt LIKE '/%')
       )