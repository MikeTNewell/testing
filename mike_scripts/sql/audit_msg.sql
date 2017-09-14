set linesize 80
set heading off
set verify off
set echo off
set pause off
set autotrace off

select to_char('Total number of connections between ' || to_char(sysdate - 9) || ' and ' || to_char(sysdate - 4) || ' on &1  is &2.') from dual
/
