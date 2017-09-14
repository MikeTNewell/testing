-- First run this to get tables to compress 
create function compression_ratio (tabname varchar2)
return number is � sample percentage
pct number := 0.000099;
blkcnt number := 0; blkcntc number; begin
execute immediate ' create table TEMP$$FOR_TEST pctfree 0
as select * from ' tabname ' where rownum < 1';
while ((pct < 100) and (blkcnt < 1000)) loop
execute immediate 'truncate table TEMP$$FOR_TEST';
execute immediate 'insert into TEMP$$FOR_TEST select *
from ' tabname ' sample block (' pct ',10)';
execute immediate 'select
count(distinct(dbms_rowid.rowid_block_number(rowid)))
from TEMP$$FOR_TEST' into blkcnt;
pct := pct * 10;
end loop;
execute immediate 'alter table TEMP$$FOR_TEST move compress ';
execute immediate 'select
count(distinct(dbms_rowid.rowid_block_number(rowid)))
from TEMP$$FOR_TEST' into blkcntc;
execute immediate 'drop table TEMP$$FOR_TEST';
return (blkcnt/blkcntc);
end;
/

-- How to run the PL/SQL from above. 
1 declare
2 a number;
3 begin
4 a:=compression_ratio('TEST');
5 dbms_output.put_line(a);
6 end
7 ;
8 /

-- Check the size 
select bytes/1024/1024 "Size in MB" from user_segments
where segment_name='TEST'

-- Run to compress. 
alter table test move compress;

-- Check the size again. 
select bytes/1024/1024 "Size in MB" from user_segments
where segment_name='TEST'