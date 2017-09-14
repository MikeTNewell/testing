
set pagesize 20
column disc_user format a15
column folders format a50

spool top_ten_disc.out


select minutes, substr(folders, 1, 50) folders, disc_user
from (
 select round(eqs.qs_act_elap_time/60,2) minutes,
             eo.obj_name||' '||decode(instr(qs_object_use_key, '.',1,1),0,' (only) ','(and others) ') folders, 
			 eqs.qs_username disc_user,
             rank() over (order by round(eqs.qs_act_elap_time/60,2) desc) ranking     
 from discvadm.eul_qpp_statistics eqs, discvadm.eul_objs eo
 where decode(instr(qs_object_use_key, '.',1,1),
        0, eqs.qs_object_use_key, substr(eqs.qs_object_use_key,1,instr(qs_object_use_key, '.',1,1)-1)) = to_char(eo.obj_id)
 and eqs.qs_username <> 'UNKNOWN'
 and eqs.qs_date_stamp between trunc (sysdate -1) and trunc(sysdate-0)
 group by round(eqs.qs_act_elap_time/60,2), eo.obj_name||' '||decode(instr(qs_object_use_key, '.',1,1),0,
               ' (only) ','(and others) '),
          eqs.qs_username
)
order by minutes desc                         
/
spool off
exit