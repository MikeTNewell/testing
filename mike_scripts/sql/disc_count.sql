set pagesize 20
spool disc_count.out

 select trunc(sysdate -1) rpt_date, count(*) queries from (
 select eqs.qs_username, eo.obj_name, 
 decode(instr(qs_object_use_key, '.',1,1),0,'SINGLE FOLDER','MULTIPLE FOLDERS') query_type,
 eqs.qs_date_stamp,      
 round(eqs.qs_act_elap_time/60,2) run_time_minutes,
 eqs.* 
 from discvadm.eul_qpp_statistics eqs, discvadm.eul_objs eo
 where decode(instr(qs_object_use_key, '.',1,1),
        0, eqs.qs_object_use_key, substr(eqs.qs_object_use_key,1,instr(qs_object_use_key, '.',1,1)-1)) = to_char(eo.obj_id)
 and eqs.qs_username <> 'UNKNOWN'
 and eqs.qs_date_stamp between trunc (sysdate -1) and trunc(sysdate-0))

/
spool off
exit