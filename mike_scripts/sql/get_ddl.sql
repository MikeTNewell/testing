set heading off;
 set echo off;
 Set pages 999;
 set long 90000;
 
spool ddl_list.sql
 select dbms_metadata.get_ddl('TABLE','DEPT','SCOTT') from dual; 
 select dbms_metadata.get_ddl('INDEX','DEPT_IDX','SCOTT') from dual;
 spool off;

--

set pagesize 0

 set long 90000

 set feedback off

 set echo off 
 spool scott_schema.sql 
 connect scott/tiger;
 SELECT DBMS_METADATA.GET_DDL('TABLE',u.table_name)
     FROM USER_TABLES u;
 SELECT DBMS_METADATA.GET_DDL('INDEX',u.index_name)
     FROM USER_INDEXES u;
 spool off;

--

 spool procedures_punch.lst


 select
   DBMS_METADATA.GET_DDL('PROCEDURE',u.object_name)
 from
   user_objects u
 where
   object_type = 'PROCEDURE';
 

 spool off;
