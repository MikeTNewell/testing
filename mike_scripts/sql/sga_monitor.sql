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
