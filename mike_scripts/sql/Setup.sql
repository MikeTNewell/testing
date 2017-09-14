set echo on;
 ACCEPT dba_pwd_src PROMPT 'Enter Password of user "system" to create Streams Admin at Source : ' HIDE  
 ACCEPT strm_pwd_src PROMPT 'Enter Password of Streams Admin "strmadmin" to be created at Source : ' HIDE  
 ACCEPT dba_pwd_dest PROMPT 'Enter Password of user "system" to create Streams Admin at Destination : ' HIDE  
 ACCEPT strm_pwd_dest PROMPT 'Enter Password of Streams Admin "strmadmin" to be created at Destination : ' HIDE 
connect "SYSTEM"/&dba_pwd_src;
create user "STRMADMIN" identified by &strm_pwd_src;
grant DBA, IMP_FULL_DATABASE, EXP_FULL_DATABASE to  "STRMADMIN"; 
BEGIN 
  DBMS_STREAMS_AUTH.GRANT_ADMIN_PRIVILEGE( 
    grantee => '"STRMADMIN"', 
    grant_privileges => true); 
END; 
/
connect "STRMADMIN"/&strm_pwd_src;
CREATE DATABASE LINK DEVCCP1 connect to  "STRMADMIN" identified by &strm_pwd_dest using '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=dallinux03.clubcorp.com)(PORT=1669)))(CONNECT_DATA=(SID=devccp1)(server=DEDICATED)))';
BEGIN 
  DBMS_STREAMS_ADM.SET_UP_QUEUE( 
    queue_table => '"STREAMS_CAPTURE_QT"', 
    queue_name  => '"STREAMS_CAPTURE_Q"', 
    queue_user  => '"STRMADMIN"'); 
END; 
/
grant select on AQ$STREAMS_CAPTURE_QT to dbsnmp; 
COMMIT;

BEGIN 
  DBMS_STREAMS_ADM.ADD_SCHEMA_RULES( 
    schema_name        => '"MHORSTMAN"', 
    streams_type       => 'capture', 
    streams_name       => '"STREAMS_CAPTURE"', 
    queue_name         => '"STRMADMIN"."STREAMS_CAPTURE_Q"', 
    include_dml        => true, 
    include_ddl        => false, 
    include_tagged_lcr => false, 
    inclusion_rule     => true); 
END; 
/
BEGIN 
  DBMS_STREAMS_ADM.ADD_SCHEMA_PROPAGATION_RULES( 
   schema_name            => '"MHORSTMAN"', 
   streams_name           => '"STREAMS_PROPAGATION"', 
    source_queue_name      => '"STRMADMIN"."STREAMS_CAPTURE_Q"', 
    destination_queue_name => '"STRMADMIN"."STREAMS_APPLY_Q"@DEVCCP1', 
    include_dml            => true, 
    include_ddl            => false, 
    source_database        => 'DEVMTX01.WORLD', 
    inclusion_rule           => true); 
END; 
/
COMMIT;
connect "SYSTEM"/&dba_pwd_dest@"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=DALLINUX03.CLUBCORP.COM)(PORT=1669)))(CONNECT_DATA=(SID=DEVCCP1)(SERVER=DEDICATED)))";
create user "STRMADMIN" identified by &strm_pwd_dest;
grant DBA, IMP_FULL_DATABASE, EXP_FULL_DATABASE to  "STRMADMIN"; 
BEGIN 
  DBMS_STREAMS_AUTH.GRANT_ADMIN_PRIVILEGE( 
    grantee => '"STRMADMIN"', 
    grant_privileges => true); 
END; 
/
COMMIT;
connect "STRMADMIN"/&strm_pwd_dest@"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=DALLINUX03.CLUBCORP.COM)(PORT=1669)))(CONNECT_DATA=(SID=DEVCCP1)(SERVER=DEDICATED)))";

CREATE DATABASE LINK DEVMTX01.WORLD connect to "STRMADMIN" identified by &strm_pwd_src using '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=dallinux03.clubcorp.com)(PORT=1669)))(CONNECT_DATA=(SID=DEVMTX01)(server=DEDICATED)))';
BEGIN 
  DBMS_STREAMS_ADM.SET_UP_QUEUE( 
    queue_table => '"STREAMS_APPLY_QT"', 
    queue_name  => '"STREAMS_APPLY_Q"', 
    queue_user  => '"STRMADMIN"'); 
END; 
/
grant select on AQ$STREAMS_APPLY_QT to dbsnmp;
BEGIN 
  DBMS_STREAMS_ADM.ADD_SCHEMA_RULES( 
    schema_name        => '"MHORSTMAN"', 
    streams_type       => 'apply', 
    streams_name       => '"STREAMS_APPLY"', 
    queue_name         => '"STRMADMIN"."STREAMS_APPLY_Q"', 
    include_dml        => true, 
    include_ddl        => false, 
    include_tagged_lcr => false, 
    inclusion_rule     => true); 
END; 
/
