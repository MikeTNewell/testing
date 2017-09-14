SET ECHO off 
REM NAME:    TFSSCHEM.SQL 
REM USAGE:   "@path/tfsschem.sql" 
REM -------------------------------------------------------------------------- 
REM PURPOSE: 
REM    The purpose of this script is to create a report which gives a rough 
REM    outline of the tables, integrity constraints, and indexes for a schema. 
REM -------------------------------------------------------------------------- 
REM    Main text of script follows: 
 
SET ECHO OFF 
SET TERMOUT OFF 
SET FEEDBACK OFF 
SET TIMING OFF 
SET PAUSE OFF 
SET PAGESIZE 0 
SET LINESIZE 255 
 
SPOOL tmp.sql 
SELECT 'SELECT RPAD('''||table_name||''',30),RPAD('''|| 
       tablespace_name||''',24), ' || 
       'TO_CHAR(COUNT(*),''9,999,999,999'') FROM ' || table_name || ';' 
FROM user_tables 
ORDER BY table_name; 
SPOOL OFF 
SET TERMOUT ON 
 
SET LINESIZE 80 
 
SPOOL schema.lst 
 
PROMPT 
PROMPT 
SELECT 'SCHEMA QUICK-LIST FOR USERID ' || user || 
       ' AS OF ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') 
FROM DUAL; 
PROMPT ================================================================== 
 
PROMPT 
PROMPT 
PROMPT Tables Overview 
PROMPT =============== 
PROMPT 
PROMPT Table                          Tablespace               Number of Rows 
PROMPT ------------------------------ ------------------------ --------------| 
HOST rm tmp.sql 
 
PROMPT 
PROMPT 
PROMPT Referential Constraints 
PROMPT ======================= 
PROMPT 
PROMPT Table                     Constraint              T Referenced Constraint    D
PROMPT  
PROMPT ------------------------ ------------------------ -  --------------------------| 
BREAK ON "Table" SKIP 1 
SELECT RPAD(table_name, 24) "Table", 
       RPAD(constraint_name, 24) "Constraint", 
       constraint_type "T", 
       RPAD(r_constraint_name, 24) "Referenced Constraint", 
       RPAD(delete_rule, 1) "D" 
FROM user_constraints 
WHERE constraint_type IN ('P', 'R', 'U')        /* ???? */ 
ORDER BY table_name, constraint_type; 
 
PROMPT 
PROMPT 
PROMPT Tables and Columns 
PROMPT ================== 
PROMPT 
PROMPT Table                    Column                   T Len  Pre Sca N 
PROMPT ------------------------ ------------------------ - ---- --- --- -| 
BREAK ON "Table" SKIP 1 
SELECT RPAD(table_name, 24) "Table", 
       RPAD(column_name, 24) "Column", 
       DECODE(data_type, 
          'CHAR', 'C', 
          'VARCHAR', 'V', 
          'VARCHAR2', 'V', 
          'NUMBER', 'N', 
          'DATE', 'D', 
      '?') "T", 
       TO_CHAR(data_length,'9999') "Len", 
       TO_CHAR(data_precision,'99') "Pr", 
       TO_CHAR(data_scale,'99') "Sc", 
       nullable "N" 
FROM user_tab_columns 
ORDER BY table_name, column_id; 
 
PROMPT 
PROMPT 
PROMPT Non-Constraint Indexes 
PROMPT ====================== 
PROMPT 
PROMPT Table                     Index                   U  Column 
PROMPT ------------------------ ------------------------ -  ------------------------| 
BREAK ON "Table" SKIP 1 ON "Index" 
SELECT RPAD(i.table_name, 24) "Table", 
       RPAD(i.index_name, 24) "Index", 
     RPAD(i.uniqueness,1) U, 
       RPAD(c.column_name,24) "Column" 
FROM user_indexes i, user_ind_columns c 
WHERE i.table_name = c.table_name 
AND i.index_name = c.index_name 
ORDER BY i.table_name, i.index_name, c.column_position; 
 
SPOOL OFF