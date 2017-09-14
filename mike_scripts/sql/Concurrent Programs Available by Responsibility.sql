--SCRIPT TO IDENTIFY INDIVIDUAL CONCURRENT PROGRAMS AVAILABLE TO ACTIVE RESPONSIBILITIES
select frt.RESPONSIBILITY_NAME, fcp.USER_CONCURRENT_PROGRAM_NAME, 'DIRECT'
from fnd_responsibility fr, fnd_responsibility_tl frt, fnd_request_group_units frgu,
     fnd_concurrent_programs_tl fcp 
where fr.responsibility_id = frt.RESPONSIBILITY_ID
and frgu.REQUEST_GROUP_ID = fr.REQUEST_GROUP_ID
and frgu.REQUEST_UNIT_ID = fcp.CONCURRENT_PROGRAM_ID
and frgu.REQUEST_UNIT_TYPE = 'P'
--and frgu.REQUEST_GROUP_ID = 263
and nvl(fr.end_date, sysdate + 1) > sysdate
and frt.responsibility_name like '%GL%'
and fr.responsibility_id in (select responsibility_id
					  	  from fnd_user_resp_groups
						  where nvl(end_date, sysdate + 1) > sysdate
						  and user_id in (select user_id from fnd_user where nvl(end_date, sysdate+1) > sysdate))						  
union
--SCRIPT TO IDENTIFY INDIVIDUAL CONCURRENT PROGRAMS AVAILABLE VIA APPLICATIONS TO ACTIVE RESPONSIBILITIES
select frt.RESPONSIBILITY_NAME, fcp.USER_CONCURRENT_PROGRAM_NAME, 'VIA APPLICATION'
from fnd_responsibility fr, fnd_responsibility_tl frt, fnd_request_group_units frgu,
     fnd_concurrent_programs_tl fcp 
where fr.responsibility_id = frt.RESPONSIBILITY_ID
and frgu.REQUEST_GROUP_ID = fr.REQUEST_GROUP_ID
and frgu.REQUEST_UNIT_ID = fcp.application_id
and frgu.REQUEST_UNIT_TYPE = 'A'
--and frgu.REQUEST_GROUP_ID = 263
and nvl(fr.end_date, sysdate + 1) > sysdate
and frt.responsibility_name like '%GL%'
and fr.responsibility_id in (select responsibility_id
					  	  from fnd_user_resp_groups
						  where nvl(end_date, sysdate + 1) > sysdate
 						  and user_id in (select user_id from fnd_user where nvl(end_date, sysdate+1) > sysdate))
union
--SCRIPT TO IDENTIFY INDIVIDUAL CONCURRENT PROGRAMS AVAILABLE TO ACTIVE RESPONSIBILITIES via REQUEST SETS
select frt.RESPONSIBILITY_NAME, fcp.USER_CONCURRENT_PROGRAM_NAME, 'VIA REQUEST SET'
from fnd_responsibility fr, fnd_responsibility_tl frt, fnd_request_group_units frgu,
     fnd_request_sets frs, fnd_request_set_programs frsp, fnd_concurrent_programs_tl fcp 
where fr.responsibility_id = frt.RESPONSIBILITY_ID
and frgu.REQUEST_GROUP_ID = fr.REQUEST_GROUP_ID
and frgu.REQUEST_UNIT_ID = frs.request_set_id
and frs.request_set_id = frsp.request_set_id
and frsp.PROGRAM_APPLICATION_ID = fcp.APPLICATION_ID
and frsp.CONCURRENT_PROGRAM_ID = fcp.CONCURRENT_PROGRAM_ID
and frgu.REQUEST_UNIT_TYPE = 'S'
--and frgu.REQUEST_GROUP_ID = 263
and nvl(fr.end_date, sysdate + 1) > sysdate
and frt.responsibility_name like '%GL%'
and fr.responsibility_id in (select responsibility_id
					  	  from fnd_user_resp_groups
						  where nvl(end_date, sysdate + 1) > sysdate
  						  and user_id in (select user_id from fnd_user where nvl(end_date, sysdate+1) > sysdate))
						  

						  
						  
select * from fnd_request_set_programs frsp

select * from fnd_request_set_programs

select * from fnd_tables where table_name like '%REQ%SET%'

select * from fnd_request_group_units frgu
where frgu.REQUEST_GROUP_ID = 263  						  

select * from fnd_application
where application_id = 20007

select * from fnd_concurrent_programs_tl
where application_id = 20007


select * from fnd_user where user_id in (
select user_id from fnd_user_resp_groups
where responsibility_id = (select responsibility_id from fnd_responsibility_tl
	  					   where responsibility_name like 'GL User USOTH')
and nvl(end_date, sysdate + 1) > sysdate	)

--9902

select fu.user_name, frt.responsibility_name
from fnd_user fu, fnd_responsibility_tl frt, fnd_user_resp_groups furg, fnd_responsibility fr
where fu.user_id = furg.user_id
and frt.responsibility_id = fr.responsibility_id
and fr.responsibility_id = furg.responsibility_id
and nvl(fu.end_date, sysdate + 1) > sysdate
and nvl(furg.end_date, sysdate + 1) > sysdate
and nvl(fr.end_date, sysdate + 1) > sysdate
order by user_name


