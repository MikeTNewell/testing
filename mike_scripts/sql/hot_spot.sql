-- This script detects objects that are 50% full and cannot allocate 
-- their next extent in their respective tablespaces.
-- bgs
-- JBC
-- Added AND DBA_SEGMENTS.TABLESPACE_NAME NOT LIKE '%NDX'


set pages 30
set linesize 111
column "TS Size" format 9999
column "TS Free" format 9999
column biggest format 9999
column "%Used" format 990
column "TS %Used" format 990
column Next format 9999.99
column object_name format a15
column "Tot MB" format 9999
column segment_name format a25
column "Part" format a22
column "TS Name" format a13
set wrap on
exec system.load_ts
@/u10/app/oracle/scripts/space/hot_spots/load_seg_space.sql
spool hot_spot.lst
select a.segment_name, 
  a.partition_name Part,
  c.tablespace_name "TS Name",
  used_blocks*8192/1024/1024 "Tot MB",
  used_blocks/total_blocks*100 "%Used",
  b.next_extent/1024/1024 Next,
  pct_used "TS %Used", 
  available "TS Free", 
  biggest
from segment_space a, dba_segments b, ts_space c
where
  a.segment_name = b.segment_name
  and nvl(a.partition_name,'#') = nvl(b.partition_name,'#')
  and a.tablespace_name = c.tablespace_name
  and (b.next_extent/1024/1024 > biggest or biggest/(b.next_extent/1024/1024) < 4)
  and used_blocks/total_blocks*100 > 50
  and b.owner = 'NALDA'
  and b.segment_name not in (select table_name from ref_tabs) 
  and b.tablespace_name NOT LIKE '%NDX'
  order by a.segment_name, a.partition_name
/
spool off
