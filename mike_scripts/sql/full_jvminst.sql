 -- Start of File full_jvminst.sql
spool full_jvminst.log;
    set echo on
    connect / as sysdba
    startup mount
    alter system set "_system_trig_enabled" = false scope=memory;
    alter database open;
    select obj#, name from obj$
      where type#=28 or type#=29 or type#=30 or namespace=32;
    @$OH/javavm/install/initjvm.sql
    select count(*), object_type from all_objects
       where object_type like '%JAVA%' group by object_type;
    @$OH/xdk/admin/initxml.sql
    select count(*), object_type from all_objects
       where object_type like '%JAVA%' group by object_type;
    @$OH/xdk/admin/xmlja.sql
    select count(*), object_type from all_objects
       where object_type like '%JAVA%' group by object_type;
    @$OH/rdbms/admin/catjava.sql
    select count(*), object_type from all_objects
       where object_type like '%JAVA%' group by object_type;
    @$OH/rdbms/admin/catexf.sql
    select count(*), object_type from all_objects
       where object_type like '%JAVA%' group by object_type;
    shutdown immediate
    set echo off
    spool off
    exit
-- End of File full_jvminst.sql


