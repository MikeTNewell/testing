-- Find a process by sid 
select p.spid from v$session s, v$process p where s.sid=534 and s.paddr=p.addr

-- See all of the processes running on an instance 
select p.spid  -- The UNIX PID
       ,s.sid  ,s.serial#
       ,p.username  as os_user
       ,s.username  ,s.status
       ,p.terminal  ,p.program
  from v$session s  ,v$process p
 where p.addr = s.paddr
 order by s.username ,p.spid ,s.sid ,s.serial# ;

-- See the sql being run 
select s.username
       ,s.sid  ,s.serial#
       ,sql.sql_text
  from v$session s, v$sqltext sql
 where sql.address    = s.sql_address
   and sql.hash_value = s.sql_hash_value
 --and upper(s.username) like 'USERNAME%'
 order by s.username ,s.sid ,s.serial# ,sql.piece ;
 
-- Kill a process 
alter system kill session 'SID,SERIAL#';

-- Find session by user 
SELECT s.SID, s.SERIAL#, s.STATUS, p.spid, sql.sql_text
  FROM V$SESSION s, v$process p, v$sqltext sql
  WHERE s.USERNAME = 'DECKTD';


