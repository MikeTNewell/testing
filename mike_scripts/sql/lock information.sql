-- Who is locking what 
select 
  oracle_username
  os_user_name,
  locked_mode,
  object_name,
  object_type
from 
  v$locked_object a,dba_objects b
where 
  a.object_id = b.object_id

-- All locked objects 
select
   c.owner,
   c.object_name,
   c.object_type,
   b.sid,
   b.serial#,
   b.status,
   b.osuser,
   b.machine
from
   v$locked_object a ,
   v$session b,
   dba_objects c
where
   b.sid = a.session_id
and
   a.object_id = c.object_id;

-- Locking situation 
SELECT SUBSTR(TO_CHAR(session_id),1,5) "SID",
       SUBSTR(lock_type,1,15) "Lock Type",
       SUBSTR(mode_held,1,15) "Mode Held",
       SUBSTR(blocking_others,1,15) "Blocking?"
  FROM dba_locks

  
--TTITLE "ITL-Waits per table (INITRANS to small)"
--set pages 1000
--col owner format a15 trunc
--col object_name format a30 word_wrap
--col value format 999,999,999 heading "NBR. ITL WAITS"
--
select owner,
       object_name||' '||subobject_name object_name,
       value
  from v$segment_statistics
 where statistic_name = 'ITL waits'
 and value > 0
--order by 3,1,2;
--
--col owner clear
--col object_name clear
--col value clear
--ttitle off

