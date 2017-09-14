SELECT * --SES_ADDR, START_SCNB 
    FROM V$TRANSACTION
    --ORDER BY START_SCNB;
    
select dbms_flashback.get_system_change_number from dual;

-- Get the current scn from the database 
select current_scn from v$database;

-- Get SCN time using the SCN number. 
select scn_to_timestamp(10289353945341) as timestamp from dual;

-- Get the SCN by the time. 
select timestamp_to_scn(to_timestamp("05/11/2010 4:06:51",’DD/MM/YYYY HH24:MI:SS’)) as scn from dual;

