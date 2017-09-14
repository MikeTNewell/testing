select * from dba_stmt_audit_opts

select 'audit '||name||';' from system_privilege_map where (name like 'CREATE%TABLE%' or name like 'CREATE%INDEX%' or name like 'CREATE%CLUSTER%' or name like 'CREATE%SEQUENCE%' or name like 'CREATE%PROCEDURE%' or name like 'CREATE%TRIGGER%' or name like 'CREATE%LIBRARY%') union select 'audit '||name||';' from system_privilege_map where (name like 'ALTER%TABLE%' or name like 'ALTER%INDEX%' or name like 'ALTER%CLUSTER%' or name like 'ALTER%SEQUENCE%' or name like 'ALTER%PROCEDURE%' or name like 'ALTER%TRIGGER%' or name like 'ALTER%LIBRARY%') union select 'audit '||name||';' from system_privilege_map where (name like 'DROP%TABLE%' or name like 'DROP%INDEX%' or name like 'DROP%CLUSTER%' or name like 'DROP%SEQUENCE%' or name like 'DROP%PROCEDURE%' or name like 'DROP%TRIGGER%' or name like 'DROP%LIBRARY%') union select 'audit '||name||';' from system_privilege_map where (name like 'EXECUTE%INDEX%' or name like 'EXECUTE%PROCEDURE%' or name like 'EXECUTE%LIBRARY%')

select count(*),username,terminal,to_char(timestamp,'DD-MON-YYYY HH:mm:ss') timestamp,returncode
from dba_audit_session
--where timestamp >= to_date('2010/05/03', 'yyyy/mm/dd') 
--and timestamp <= to_date('2010/05/07', 'yyyy/mm/dd')
group by username,terminal,timestamp,returncode

select 
to_char('Total number of connections on ' || :host || ' between ' || to_char(sysdate - 9) || ' and ' || to_char(sysdate - 4) || ' is ' || count(*))
from oraaudit.aud$ a
where logoff$time >= to_char(sysdate - 9) and logoff$time <= to_char(sysdate - 4) and returncode = 0

select count(*) from oraaudit.aud$ a 
where logoff$time >= to_char(sysdate - 9) and logoff$time <= to_char(sysdate - 4) and returncode = 0
 
SELECT count(*)--min(logoff$time), max(logoff$time)
FROM ORAAUDIT.AUD$ A
where logoff$time >= to_char(sysdate - 9)
and logoff$time <= to_char(sysdate - 4)
and returncode = 0
--order by logoff$time asc from dual

select 
--GROUP BY RETURNCODE;

select * from oraaudit.aud$

describe oraaudit.aud$

select 'Reporting Period: ' || min(LOGOFF$TIME) ||' to '||
max(LOGOFF$TIME)|| '.' 
from ORAAUDIT.AUD$;