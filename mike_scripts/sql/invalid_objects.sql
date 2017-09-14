break on c1 skip 2

set pages 999

col c1 heading 'owner' format a15
col c2 heading 'name' format a40
col c3 heading 'type' format a10

ttitle 'Invalid|Objects'

select 
   owner       c1, 
   object_type c3,
   object_name c2
from 
   dba_objects 
where 
   status != 'VALID'
order by
   owner,
   object_type
; 


select object_type,count(*) from dba_objects where status = 'INVALID' group by object_type;