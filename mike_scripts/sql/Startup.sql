 ACCEPT strm_pwd_src PROMPT 'Enter Password of Streams Admin "strmadmin" at Source : ' HIDE  
 ACCEPT strm_pwd_dest PROMPT 'Enter Password of Streams Admin "strmadmin" at Destination : ' HIDE  
connect "STRMADMIN"/&strm_pwd_dest@"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=DALLINUX03.CLUBCORP.COM)(PORT=1669)))(CONNECT_DATA=(SID=DEVCCP1)(SERVER=DEDICATED)))";
set serverout on; 
BEGIN 
DBMS_APPLY_ADM.SET_SCHEMA_INSTANTIATION_SCN(
    source_schema_name   => '"MHORSTMAN"', 
   source_database_name => 'DEVMTX01.WORLD', 
   instantiation_scn    => 205065296,
   recursive            => true); 
END; 
/
DECLARE 
   v_started number; 
BEGIN 
SELECT DECODE(status, 'ENABLED', 1, 0) INTO v_started 
 FROM DBA_APPLY where apply_name = 'STREAMS_APPLY'; 
 if (v_started = 0) then 
  DBMS_APPLY_ADM.START_APPLY(apply_name => '"STREAMS_APPLY"'); 
 end if; 
END; 
/
connect "STRMADMIN"/&strm_pwd_src; 

set serverout on; 
DECLARE 
   v_started number; 
BEGIN 
SELECT DECODE(status, 'ENABLED', 1, 0) INTO v_started 
 FROM DBA_CAPTURE where CAPTURE_NAME = 'STREAMS_CAPTURE'; 
 if (v_started = 0) then 
  DBMS_CAPTURE_ADM.START_CAPTURE(capture_name => '"STREAMS_CAPTURE"'); 
 end if; 
END; 
/
BEGIN 
DBMS_OUTPUT.PUT_LINE('*** Progress Message ===> Started the capture process STREAMS_CAPTURE at source database DEVMTX01 and the apply process STREAMS_APPLY at the destination database successfully. ***');
END; 
/
