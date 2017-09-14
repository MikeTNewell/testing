 ACCEPT strm_pwd_src PROMPT 'Enter Password of Streams Admin "strmadmin" at Source : ' HIDE  
 ACCEPT strm_pwd_dest PROMPT 'Enter Password of Streams Admin "strmadmin" at Destination : ' HIDE  
connect "STRMADMIN"/&strm_pwd_dest@"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=DALLINUX03.CLUBCORP.COM)(PORT=1669)))(CONNECT_DATA=(SID=DEVCCP1)(SERVER=DEDICATED)))";
set serverout on; 
DECLARE 
  handle1 number; 
  ind number; 
  percent_done number; 
  job_state VARCHAR2(30); 
  le ku$_LogEntry; 
  js ku$_JobStatus; 
  jd ku$_JobDesc; 
  sts ku$_Status; 
BEGIN   
  handle1 := DBMS_DATAPUMP.OPEN('IMPORT','SCHEMA', 'DEVMTX01.WORLD'); 
  DBMS_DATAPUMP.ADD_FILE(handle1, 'StreamImport_1231445711184.log', '/home/oracst1/exp', '',  DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE); 
  DBMS_DATAPUMP.SET_PARAMETER(handle1, 'FLASHBACK_SCN', 205065284); 
   DBMS_DATAPUMP.METADATA_FILTER(handle1, 'SCHEMA_EXPR', 'IN (''MHORSTMAN'')'); 
  DBMS_DATAPUMP.SET_PARAMETER(handle1, 'INCLUDE_METADATA', 1); 
  DBMS_DATAPUMP.START_JOB(handle1);  
  percent_done :=0; 
  job_state := 'UNDEFINED'; 
  while (job_state != 'COMPLETED') and (job_state != 'STOPPED') loop 
  dbms_datapump.get_status(handle1, dbms_datapump.ku$_status_job_error + dbms_datapump.ku$_status_job_status + dbms_datapump.ku$_status_wip,-1,job_state,sts); 
  js := sts.job_status; 
  if js.percent_done != percent_done 
  then 
     dbms_output.put_line('*** Job percent done = ' || to_char(js.percent_done)); 
     percent_done := js.percent_done; 
  end if; 
  if(bitand(sts.mask, dbms_datapump.ku$_status_wip) != 0) 
  then 
    le := sts.wip; 
  else 
     if(bitand(sts.mask,dbms_datapump.ku$_status_job_error) != 0) 
     then 
       le := sts.error; 
     else 
       le := null; 
     end if; 
  end if; 
  if le is not null 
  then 
    ind := le.FIRST; 
    while ind is not null loop 
      dbms_output.put_line(le(ind).LogText); 
      ind := le.NEXT(ind); 
    end loop; 
  end if; 
  end loop; 
  dbms_output.put_line('Job has completed'); 
  dbms_output.put_line('Final job state = ' || job_state); 
  dbms_datapump.detach(handle1); 
END;   
/
