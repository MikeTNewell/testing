rem -----------------------------------------------------------------------
rem Filename:   repprep.sql
rem Purpose:    Setup users, DB Links and schedules for Oracle Advanced
rem             replication. Run this script on all replication sites.
rem             In this example replication is between sites TD1 and TD2
rem Date:       03-Oct-2000
rem Author:     Frank Naude, Oracle FAQ
rem -----------------------------------------------------------------------

set pages 50000
spool repprep

connect sys

-- @?/rdbms/admin/catrep.sql

REM Check if INIT.ORA parameters are OK for replication
select name, value from sys.v_$parameter
where  name in ('job_queue_processes', 'job_queue_interval', 
                'global_name')

REM Assign global name to the current DB
alter database rename global_name to TD1.world;    -- Change to your DB name + domain

REM Create public db link to the other master databses
create public database link TD2.world using 'TD2';

REM Create replication administrator / propagator / receiver
create user repadmin identified by repadmin
        default   tablespace USER_DATA
        temporary tablespace TEMP
        quota unlimited on USER_DATA;

REM Grant privs to the propagator, to propagate changes to remote sites
execute dbms_defer_sys.register_propagator(username=>'REPADMIN');

REM Grant privs to the receiver to apply deferred transactions
grant execute any procedure to repadmin;

REM Authorise the administrator to administer replication groups
execute dbms_repcat_admin.grant_admin_any_repgroup('REPADMIN');

REM Authorise the administrator to lock and comment tables
grant lock any table to repadmin;
grant comment any table to repadmin;

connect repadmin/repadmin

REM Create private db links for repadmin
create database link TD2.world
        connect to repadmin identified by repadmin;

REM Schedule job to push transactions to master sites
execute dbms_defer_sys.schedule_push(        -
        destination   => 'TD2.world',        -
        interval      => 'sysdate+1/24/60',  -
        next_date     => sysdate+1/24/60,    -
        stop_on_error => FALSE,              -
        delay_seconds => 0,                  -
        parallelism   => 1);

REM Schedule job to delete successfully replciated transactions
execute dbms_defer_sys.schedule_purge(       -
        next_date     => sysdate+1/24,       -
        interval      => 'sysdate+1/24');

REM Test database link
select global_name from global_name@TD2.world;

spool off

