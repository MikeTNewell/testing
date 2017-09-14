SET ECHO off 
REM NAME:    TFSLKSQL.SQL 
REM USAGE:"@path/tfslksql" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM    SELECT on V$SQLTEXT, V$SESSION, and V$ACCESS 
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM    This script will report the SQL text of some of the locks  
REM    currently being held in the database. 
REM ------------------------------------------------------------------------ 
REM EXAMPLE: 
REM    USERNAME                              SID 
REM    ------------------------------ ---------- 
REM    OBJECT 
REM    ------------------------------------------------------------------- 
REM    LOCKWAIT SQL 
REM    -------- ---------------------------------------------------------- 
REM    SYSTEM                                 11 
REM    SCOTT.TABLE_CONFIG 
REM    E0034A5C update scott.table_config set tabno=99 where tabno=9 
REM     
REM    SYS                                     6 
REM    SCOTT.TABLE_CONFIG 
REM    E0034C98 update scott.table_config set capacity=28 where capacity=4 
REM  
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 
 
set pagesize 60 
set linesize 132 
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
/ 
