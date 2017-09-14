SET ECHO off 
REM NAME:   TFSXPLAN.SQL 
REM USAGE:  See PURPOSE 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM    utlxplan.sql must be run prior to this script! 
REM ------------------------------------------------------------------------ 
REM AUTHOR:  
REM    Craig A. Shallahamer, Oracle USA      
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM    The following script is intended to assist application developers and 
REM    performance specialists in determining the execution path of a given  
REM    SQL statement without having to trace and tkprof the statement. 
REM 
REM    To use, you will make a copy of this file, then place the SQL 
REM    statement to be analyzed in the copy and run the script. 
REM 
REM    EXAMPLE 
REM 
REM    1. $ cp $path/explbig.sql x.sql 
REM    2. modify x.sql with your SQL. 
REM    3. SQL>@x.sql 
REM  
REM ------------------------------------------------------------------------ 
REM EXAMPLE: 
REM     OPERATIONS                OPTIONS         OBJECT_NAME 
REM 
REM    ------------------------- --------------- -----------------------  
REM      MERGE JOIN 
REM        SORT                       JOIN 
REM          TABLE ACCESS             FULL            DEPT 
REM        SORT                       JOIN 
REM          TABLE ACCESS             FULL            EMP 
REM  
REM ------------------------------------------------------------------------ 
REM DISCLAIMER: 
REM    This script is provided for educational purposes only. It is NOT  
REM    supported by Oracle World Wide Technical Support. 
REM    The script has been tested and appears to work as intended. 
REM    You should always run new scripts on a test instance initially. 
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 
 
col operation 	format	a13	trunc 
col options	format	a15	trunc 
col object_name	format	a23	trunc 
col id		format	9999 
col parent_id	format	9999 
col position	format	9999 
col operations	format	a25 
 
explain plan 
set statement_id = 'x' 
into plan_table 
for  
<<YOUR CODE HERE.  DON'T FORGET THE ";">> 
 
select lpad(' ',2*level) || operation operations,options,object_name 
from plan_table 
where statement_id = 'x' 
connect by prior id = parent_id and statement_id = 'x' 
start with id = 1 and statement_id = 'x' 
order by id; 
 
rollback; 
