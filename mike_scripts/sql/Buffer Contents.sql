
--TOP 10 SOURCES OF BLOCKS IN BUFFER CACHE
select object_name, object_type, block_count
from (
select o.object_name,object_type, count(*) 
from x$bh b, dba_objects o 
where b.obj=o.object_id 
group by o.object_name, object_type
order by 3 desc)
where rownum < 11;



--TOP 10 SOURCES of SQL in DICTIONARY CACHE
select label, line_count from (
select * from (
select 'MODULE = '||module label, count(*) line_count 
from v$sql
where module is not null
group by module
union
select 'MODULE NULL, USER = '||du.USERNAME, count(*) 
from v$sql vs, dba_users du
where vs.PARSING_SCHEMA_ID = du.USER_ID
and vs.module is null
group by du.USERNAME)
order by 2 desc)
where rownum < 11



select *  
from fnd_concurrent_programs fcp, fnd_concurrent_programs_tl fcpt
where fcp.concurrent_program_name like :MyProg
and fcp.CONCURRENT_PROGRAM_ID = fcpt.CONCURRENT_PROGRAM_ID
and fcp.APPLICATION_ID = fcpt.APPLICATION_ID

select * 
from fnd_form ff, fnd_form_tl fft
where ff.FORM_ID = fft.FORM_ID
and ff.APPLICATION_ID = fft.APPLICATION_ID
and ff.form_name like :MyProg


