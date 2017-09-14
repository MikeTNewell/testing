select time,instance_number,
      max(decode(name,'free memory',shared_pool_bytes,null))
free_memory,
      max(decode(name,'library cache',shared_pool_bytes,null))
library_cache,
      max(decode(name,'sql area',shared_pool_bytes,null)) sql_area
 from (select to_char(begin_interval_time,'YYYY_MM_DD HH24:MI') time,
              dhs.instance_number,
              name,
              bytes - LAG(bytes, 1, NULL) OVER (ORDER BY
dhss.instance_number,name,dhss.snap_id) AS shared_pool_bytes
         from dba_hist_sgastat dhss,
              dba_hist_snapshot dhs
         where name in( 'free memory', 'library cache', 'sql area')
           and pool = 'shared pool'
           and dhss.snap_id = dhs.snap_id
           and dhss.instance_number = dhs.instance_number
         order by dhs.snap_id,name)
         group by time,
          instance_number
          
SELECT size_for_estimate, buffers_for_estimate, estd_physical_read_factor, estd_physical_reads
   FROM V$DB_CACHE_ADVICE
   WHERE name          = 'DEFAULT'
     AND block_size    = (SELECT value FROM V$PARAMETER WHERE name = 'db_block_size')
     AND advice_status = 'ON';
     
SELECT SIZE_FOR_ESTIMATE, BUFFERS_FOR_ESTIMATE, ESTD_PHYSICAL_READ_FACTOR, ESTD_PHYSICAL_READS
  FROM V$DB_CACHE_ADVICE
    WHERE NAME          = 'KEEP'
     AND BLOCK_SIZE    = (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'db_block_size')
     AND ADVICE_STATUS = 'ON';
     
SELECT * FROM V$SGASTAT 
 WHERE NAME = 'free memory'
   AND POOL = 'shared pool';
   
SELECT SUM(VALUE) || ' BYTES' "TOTAL MEMORY FOR ALL SESSIONS"
    FROM V$SESSTAT, V$STATNAME
    WHERE NAME = 'session uga memory'
    AND V$SESSTAT.STATISTIC# = V$STATNAME.STATISTIC#;

SELECT SUM(VALUE) || ' BYTES' "TOTAL MAX MEM FOR ALL SESSIONS"
    FROM V$SESSTAT, V$STATNAME
    WHERE NAME = 'session uga memory max'
    AND V$SESSTAT.STATISTIC# = V$STATNAME.STATISTIC#;
    
/*Assume that an Oracle instance is configured to run on a system with 4 GB of physical memory. Part of that memory should be left for the operating system and other non-Oracle applications running on the same hardware system. You might decide to dedicate only 80% (3.2 GB) of the available memory to the Oracle instance.
You must then divide the resulting memory between the SGA and the PGA.
For OLTP systems, the PGA memory typically accounts for a small fraction of the total memory available (for example, 20%), leaving 80% for the SGA.
For DSS systems running large, memory-intensive queries, PGA memory can typically use up to 70% of that total (up to 2.2 GB in this example).
Good initial values for the parameter PGA_AGGREGATE_TARGET might be:
For OLTP: PGA_AGGREGATE_TARGET = (total_mem * 80%) * 20%
For DSS: PGA_AGGREGATE_TARGET = (total_mem * 80%) * 50%
where total_mem is the total amount of physical memory available on the system.
In this example, with a value of total_mem equal to 4 GB, you can initially set PGA_AGGREGATE_TARGET to 1600 MB for a DSS system and to 655 MB for an OLTP system. */

SELECT * FROM V$PGASTAT;







