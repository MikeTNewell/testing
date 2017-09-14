select * from dba_rollback_segs where segment_name = '_SYSSMU53$'

select sum(bytes) from dba_segments where segment_name like 'WF%';

select * from dba_data_files where tablespace_name = 'APPS_UNDOTS1';

grant select on benefits to PSCHWARTZ

grant select on DSWEET.SAVE_ASSET_REF to EUL5_OWNER

grant insert on CCAPPS.CCAR_AUTOPAY_DETAILS to CLUBUPLOAD

grant select on MERCURY.RST_MP_ALL_PHONE_NUMBERS with grant option

describe DBA_TAB_PRIVS

select * from DBA_TAB_PRIVS

describe dba_roles

select * from dba_roles

describe DBA_ROLE_PRIVS 

select * from DBA_ROLE_PRIVS where grantee = 'PSCHWARTZ'

describe dba_objects

/* To find the amount of space in a table */
select (bytes/1024/1024) as "Size in MB"
from dba_segments
where segment_name = 'PA_TXN_ACCUM_DETAILS'
-- 118074125 on 06292007 

----------------------------------------------------------------------------------------------
/* Tuning Scripts */
----------------------------
/* -- Take out to run
declare

   l_task_id     varchar2(20);
   l_sql         varchar2(2000);
begin
   l_sql := 'select account_no from accounts where old_account_no = 11';
   dbms_sqltune.drop_tuning_task ('FOLIO_COUNT');
   l_task_id := dbms_sqltune.create_tuning_task (
      sql_text  => l_sql,
      user_name  => 'ARUP',
      scope      => 'COMPREHENSIVE',
      time_limit => 120,
      task_name  => 'FOLIO_COUNT'
   );
   dbms_sqltune.execute_tuning_task ('FOLIO_COUNT');
end;
/
*/ -- Take out to run
/*The above package creates and executes a tuning task named FOLIO_COUNT. 
Next, you will need to see the results of the execution of the task (that is, see the recommendations).*/ 
set serveroutput on size 999999
set long 999999
select dbms_sqltune.report_tuning_task ('FOLIO_COUNT') from dual;
-------------------------------
/* End of Tuning scripts */
-----------------------------------------------------------------------------------------------------------

/* See what processes are running */
select c.spid SPID, b.osuser OSUSER, b.username USERNAME, b.sid SID, b.serial# SERIALNUM,
a.sql_text
  from v$sqltext a, v$session b, v$process c
   where a.address    = b.sql_address
--   and b.status     = 'ACTIVE' /* YOU CAN CHOOSE THIS OPTION ONLY TO SEE 
--                                  ACTVE TRANSACTION ON THAT MOMENT */
   and b.paddr      = c.addr
   and a.hash_value = b.sql_hash_value
 order by c.spid,a.hash_value,a.piece

 
/* Redo log info */
select  l.group#, 
        member, 
 	archived, 
        l.status, 
        (bytes/1024/1024) fsize 
from    v$log l, 
	v$logfile f 
where f.group# = l.group# 
order by 1

/* Lists all jobs that have been submitted to run in the 
   local database job queue. */ 
select 
  job                        jid, 
  log_user                   subu, 
  priv_user                  secd, 
  what                       proc, 
  to_char(last_date,'MM/DD') lsd, 
  substr(last_sec,1,5)       lst, 
  to_char(next_date,'MM/DD') nrd, 
  substr(next_sec,1,5)       nrt, 
  failures                   fail, 
  decode(broken,'Y','N','Y') ok 
from 
  sys.dba_jobs 
  
/* This script will report the SQL text of some of the locks  
   currently being held in the database. */
select s.username username,  
       a.sid sid,  
       a.owner||'.'||a.object object,  
       s.lockwait,  
       t.sql_text SQL 
from   v$sqltext t,  
       v$session s,  
       v$access a 
where  t.address=s.sql_address  
and    t.hash_value=s.sql_hash_value  
and    s.sid = a.sid  
and    a.owner != 'SYS' 
and    upper(substr(a.object,1,2)) != 'V$'

/* This script will report the SQL text of some of the locks  
   currently being held in the database. */ 
select B.SID, C.USERNAME, C.OSUSER, C.TERMINAL,
       DECODE(B.ID2, 0, A.OBJECT_NAME,
            'Trans-'||to_char(B.ID1)) OBJECT_NAME,
       B.TYPE,
       DECODE(B.LMODE,0,'--Waiting--',
                      1,'Null',
                      2,'Row Share',
                      3,'Row Excl',
                   	  4,'Share',
                      5,'Sha Row Exc',
					  6,'Exclusive',
                        'Other') "Lock Mode",
       DECODE(B.REQUEST,0,' ',
                      1,'Null',
                      2,'Row Share',
                      3,'Row Excl',
                      4,'Share',
                      5,'Sha Row Exc',
                      6,'Exclusive',
                     'Other') "Req Mode"
  from DBA_OBJECTS A, V$LOCK B, V$SESSION C
where A.OBJECT_ID(+) = B.ID1
  and B.SID = C.SID
  and C.USERNAME is not null
order by B.SID, B.ID2;

/* Reports users waiting for locks. */
SELECT sn.username, m.sid, m.type, 
        DECODE(m.lmode, 0, 'None', 
                        1, 'Null', 
                        2, 'Row Share', 
                        3, 'Row Excl.', 
                        4, 'Share', 
                        5, 'S/Row Excl.', 
                        6, 'Exclusive', 
                lmode, ltrim(to_char(lmode,'990'))) lmode, 
        DECODE(m.request,0, 'None', 
                         1, 'Null', 
                         2, 'Row Share', 
                         3, 'Row Excl.', 
                         4, 'Share', 
                         5, 'S/Row Excl.', 
                         6, 'Exclusive', 
                         request, ltrim(to_char(m.request, 
                '990'))) request, m.id1, m.id2 
FROM v$session sn, v$lock m 
WHERE (sn.sid = m.sid AND m.request != 0) 
        OR (sn.sid = m.sid 
                AND m.request = 0 AND lmode != 4 
                AND (id1, id2) IN (SELECT s.id1, s.id2 
     FROM v$lock s 
                        WHERE request != 0 
              AND s.id1 = m.id1 
                                AND s.id2 = m.id2) 
                ) 
ORDER BY id1, id2, m.request;

-- Find blocking locks 
select s1.username || '@' || s1.machine
  || ' ( SID=' || s1.sid || ' )  is blocking '
  || s2.username || '@' || s2.machine || ' ( SID=' || s2.sid || ' ) ' AS blocking_status
  from v$lock l1, v$session s1, v$lock l2, v$session s2
  where s1.sid=l1.sid and s2.sid=l2.sid
  and l1.BLOCK=1 and l2.request > 0
  and l1.id1 = l2.id1
  and l2.id2 = l2.id2 
-------------------------------------
 
select * from v$version

select * from v$sesstat

select * from dba_summaries

select last_analyzed from dba_tables where owner like '%MERCURY%'

select last_analyzed from dba_tables where owner like '%MAR%'

--exec fnd_stats.gather_schema_statistics('GL',25,5,'NOBACKUP');

-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/spfile_parameters.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays a list of all the spfile parameters.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @spfile_parameters
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
--SET LINESIZE 500

--COLUMN name  FORMAT A30
--COLUMN value FORMAT A60
--COLUMN displayvalue FORMAT A60

SELECT sp.sid,
       sp.name,
       sp.value
       --sp.display_value
FROM   v$spparameter sp
ORDER BY sp.name, sp.sid
--------------------------------

-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/pga_target_advice.sql
-- Author       : DR Timothy S Hall
-- Description  : Predicts how changes to the PGA_AGGREGATE_TARGET will affect PGA usage.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @pga_target_advice
-- Last Modified: 12/02/2004
-- -----------------------------------------------------------------------------------

SELECT ROUND(pga_target_for_estimate/1024/1024) target_mb,
       estd_pga_cache_hit_percentage cache_hit_perc,
       estd_overalloc_count
FROM   v$pga_target_advice

-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/db_properties.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays all database property values.
-- Call Syntax  : @db_properties
-- Last Modified: 15/09/2006
-- -----------------------------------------------------------------------------------
--COLUMN property_value FORMAT A50

SELECT property_name,
       property_value
FROM   database_properties
ORDER BY property_name
------------------------------------------------

-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/cache_hit_ratio.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays cache hit ratio for the database.
-- Comments     : The minimum figure of 89% is often quoted, but depending on the type of system this may not be possible.
-- Requirements : Access to the v$ views.
-- Call Syntax  : @cache_hit_ratio
-- Last Modified: 15/07/2000
-- -----------------------------------------------------------------------------------
--PROMPT
--PROMPT Hit ratio should exceed 89%

SELECT Sum(Decode(a.name, 'consistent gets', a.value, 0)) "Consistent Gets",
       Sum(Decode(a.name, 'db block gets', a.value, 0)) "DB Block Gets",
       Sum(Decode(a.name, 'physical reads', a.value, 0)) "Physical Reads",
       Round(((Sum(Decode(a.name, 'consistent gets', a.value, 0)) +
         Sum(Decode(a.name, 'db block gets', a.value, 0)) -
         Sum(Decode(a.name, 'physical reads', a.value, 0))  )/
           (Sum(Decode(a.name, 'consistent gets', a.value, 0)) +
             Sum(Decode(a.name, 'db block gets', a.value, 0))))
             *100,2) "Hit Ratio %"
FROM   v$sysstat a
------------------------------------------
