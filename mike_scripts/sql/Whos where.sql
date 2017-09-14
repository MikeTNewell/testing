--ASSIGNMENT INFO
select pap.name, fu.user_name, ppf.full_name, paf.effective_start_date, 
       ppf.email_address, awusav.VARCHAR2_VALUE ccr_val, awusav.*
from per_all_positions pap, per_assignments_f paf, per_people_f ppf, fnd_user fu,
     (select * from ak_web_user_sec_attr_values where attribute_code = 'CCR_ENTITY_ACCESS') awusav
where pap.position_id = paf.position_id
and fu.employee_id = paf.person_id
and fu.employee_id = ppf.person_id
and fu.user_id = awusav.WEB_USER_ID(+)
and fu.user_name like :MyUser
and paf.effective_end_date > sysdate
and ppf.effective_end_date > sysdate

--ASSIGNMENT INFO by person name
select pap.name, fu.user_name, ppf.full_name, paf.effective_start_date, ppf.EMAIL_ADDRESS, fu.end_date
from per_all_positions pap, per_assignments_f paf, per_people_f ppf, fnd_user fu
where pap.position_id = paf.position_id
and fu.employee_id = paf.person_id
and fu.employee_id = ppf.person_id
and ppf.full_name like :MyFull
and paf.effective_end_date > sysdate
and ppf.effective_end_date > sysdate

--RESPONSIBILITY LIST
select fu.user_name, frt.RESPONSIBILITY_NAME
from fnd_user fu, fnd_user_resp_groups furg, fnd_responsibility_tl frt
where fu.user_id = furg.user_id
and furg.responsibility_id = frt.RESPONSIBILITY_ID
and nvl(furg.END_DATE, sysdate + 1) > sysdate 
and fu.user_name like :MyUser


--INFO by HR email
select pap.name, fu.user_name, ppf.full_name, paf.effective_start_date, ppf.EMAIL_ADDRESS
from per_all_positions pap, per_assignments_f paf, per_people_f ppf, fnd_user fu
where pap.position_id = paf.position_id
and fu.employee_id = paf.person_id
and fu.employee_id = ppf.person_id
and ppf.email_address like :MyMail
and paf.effective_end_date > sysdate
and ppf.effective_end_date > sysdate


--INFO by POSITION name
select pap.name, fu.user_name, ppf.full_name, paf.effective_start_date, ppf.EMAIL_ADDRESS
from per_all_positions pap, per_assignments_f paf, per_people_f ppf, fnd_user fu
where pap.position_id = paf.position_id
and fu.employee_id = paf.person_id
and fu.employee_id = ppf.person_id
and (pap.name like :MyPos1
or pap.name like :MyPos2)
--and pap.name not like '%Acc%'
--and pap.name not like '%Cont%'
and paf.effective_end_date > sysdate
and ppf.effective_end_date > sysdate

--ACTIVE HOLDERS OF A NAMED RESPONSIBILITY
select fu.user_name, frt.responsibility_name
from fnd_user fu, fnd_responsibility_tl frt, fnd_user_resp_groups furg
where fu.user_id = furg.user_id
and frt.RESPONSIBILITY_ID = furg.RESPONSIBILITY_ID
and nvl(fu.END_DATE, sysdate + 1) > sysdate
and nvl(furg.END_DATE, sysdate + 1) > sysdate
and frt.responsibility_name like :MyResp


select * from fnd_flex_values_tl
where flex_value_meaning like '01995'


select * from fnd_responsibility where menu_id = 1003883
and nvl(end_date, sysdate + 1) > sysdate 



update applsys.fnd_flex_values
set end_date_active = end_date_active - 20000,
last_update_date = sysdate,
last_updated_by = 19161

select * from applsys.fnd_flex_values
where flex_value_set_id = 1002614
and end_date_active is not null
and flex_value like '0%';


select * from ak_web_user_sec_attr_values awusav
where ATTRIBUTE_CODE = 'CCR_ENTITY_ACCESS'
and (creation_date > sysdate - 1
or last_update_date > sysdate - 1)  


select 'com=au user='||fu.user_name||' group="'||awusav.VARCHAR2_VALUE
        ||' - '||decode(ffvt.flex_value_meaning,'00000','All Entities',ffvt.description)
		||'" pass=password force=y email='||ppf.email_address||' desc="'||pap.name||'" full="'
		||ppf.full_name||'"'
from per_all_positions pap, per_assignments_f paf, per_people_f ppf, fnd_user fu,
     ak_web_user_sec_attr_values awusav, fnd_flex_values ffv, fnd_flex_values_tl ffvt
where pap.position_id = paf.position_id
and fu.employee_id = paf.person_id
and fu.employee_id = ppf.person_id
and fu.user_id = awusav.WEB_USER_ID
and awusav.varchar2_value = ffv.flex_value
and ffv.flex_value_set_id = 1002614
and ffv.flex_value_id = ffvt.flex_value_id
and awusav.ATTRIBUTE_CODE = 'CCR_ENTITY_ACCESS'
--and fu.user_name like :MyUser
and paf.effective_end_date > sysdate
and ppf.effective_end_date > sysdate
and (awusav.creation_date > sysdate - 1
or awusav.last_update_date > sysdate - 1)  
union
select 'com=aug user='||fu.user_name||' group="'||awusav.VARCHAR2_VALUE
	    ||' - '||decode(ffvt.flex_value_meaning,'00000','All Entities',ffvt.description)||'"'
from per_all_positions pap, per_assignments_f paf, per_people_f ppf, fnd_user fu,
     ak_web_user_sec_attr_values awusav, fnd_flex_values ffv, fnd_flex_values_tl ffvt
where pap.position_id = paf.position_id
and fu.employee_id = paf.person_id
and fu.employee_id = ppf.person_id
and fu.user_id = awusav.WEB_USER_ID
and awusav.varchar2_value = ffv.flex_value
and ffv.flex_value_set_id = 1002614
and ffv.flex_value_id = ffvt.flex_value_id
and awusav.ATTRIBUTE_CODE = 'CCR_ENTITY_ACCESS'
--and fu.user_name like :MyUser
and paf.effective_end_date > sysdate
and ppf.effective_end_date > sysdate
and (awusav.creation_date > sysdate - 1
or awusav.last_update_date > sysdate - 1)  







select description from fnd_flex_values_tl where flex_value_id in (
select flex_value_id from fnd_flex_values where flex_value_set_id = 1002614 and flex_value like 'P%') 

fnd_flex_values_tl where flex_value_meaning = '00131'



select fu_m.user_name, frt_m.responsibility_name, pap_m.name 
from fnd_user_resp_groups frg_m, fnd_user fu_m, fnd_responsibility_tl frt_m,
     per_all_positions pap_m, per_assignments_f paf_m, per_people_f ppf_m  
where frg_m.user_id = fu_m.user_id 
and frg_m.responsibility_id = frt_m.responsibility_id
and pap_m.position_id = paf_m.position_id
and fu_m.employee_id = paf_m.person_id
and fu_m.employee_id = ppf_m.person_id
and paf_m.effective_end_date > sysdate
and ppf_m.effective_end_date > sysdate
and frg_m.responsibility_id in (
	--INFO by POSITION name
	select frt.responsibility_id
	--select pap.name, fu.user_name, ppf.full_name, frt.RESPONSIBILITY_NAME, frt.APPLICATION_ID 
	from per_all_positions pap, per_assignments_f paf, per_people_f ppf, 
	     fnd_user fu, fnd_user_resp_groups furg, fnd_responsibility_tl frt
	where pap.position_id = paf.position_id
	and fu.employee_id = paf.person_id
	and fu.employee_id = ppf.person_id
	and fu.user_id = furg.user_id
	and furg.RESPONSIBILITY_ID = frt.RESPONSIBILITY_ID
	and (pap.name like :MyPos1
	or pap.name like :MyPos2)
	--and pap.name not like '%Acc%'
	--and pap.name not like '%Cont%'
	and paf.effective_end_date > sysdate
	and ppf.effective_end_date > sysdate
	and nvl(furg.end_date, sysdate + 1) > sysdate
	and frt.application_id = 800)
and nvl(frg_m.end_date, sysdate + 1) > sysdate 	


select * 