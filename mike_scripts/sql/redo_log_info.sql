SET ECHO off 
REM NAME:   TFSRDOLG.SQL 
REM USAGE:"@path/tfsrdolg" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM SELECT on V$LOG and V$LOGFILE 
REM ------------------------------------------------------------------------ 
REM AUTHOR:  
REM    Nick Popovic, Oracle Corporation 
REM    (c)1995 by Oracle Corporation 
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM    Gives redo log information from v$log and v$logfile. 
REM ------------------------------------------------------------------------ 
REM EXAMPLE: 
REM                         Redo Log Summary 
REM 
REM    Size  
REM    Group                    Member            Archived  Status  (MB) 
REM    ----- ------------------------------------ -------- -------- ---- 
REM        1 /u02/oracle/V7.1.6/dbs/log1V716.dbf      NO   INACTIVE  10 
REM        2 /u02/oracle/V7.1.6/dbs/log2V716.dbf      NO   INACTIVE  10 
REM        3 /u02/oracle/V7.1.6/dbs/log3V716.dbf      NO   CURRENT   10 
REM  
REM ------------------------------------------------------------------------ 
REM DISCLAIMER: 
REM    This script is provided for educational purposes only. It is NOT  
REM    supported by Oracle World Wide Technical Support. 
REM    The script has been tested and appears to work as intended. 
REM    You should always run new scripts on a test instance initially. 
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 
 
ttitle - 
  center  'Redo Log Summary'  skip 2 
 
col group# 	format 999      heading 'Group'  
col member 	format a45	heading 'Member' justify c 
col status 	format a10	heading 'Status' justify c	 
col archived	format a10	heading 'Archived' 	 
col fsize 	format 999 	heading 'Size|(MB)'  
 
select  l.group#, 
        member, 
 	archived, 
        l.status, 
        (bytes/1024/1024) fsize 
from    v$log l, 
	v$logfile f 
where f.group# = l.group# 
order by 1 
/
