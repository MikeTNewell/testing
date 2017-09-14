select SO_MODULE, TO_CHAR(SO_JOB_STARTED,'DD-MON-YYYY HH24:MI:SS') AS STARTED, TO_CHAR(SO_JOB_FINISHED,'DD-MON-YYYY HH24:MI:SS') FINISHED, SO_STATUS_NAME, SO_CHAIN_ID 
     from so_job_history 
     where SO_START_DATE > TO_DATE('01-FEB-2005','DD-MON-YYYY') 
        AND SO_START_DATE < TO_DATE('16-JUN-2005','DD-MON-YYYY')
        and so_module like 'ESS%'
        and so_module not like 'ESS_MOVE%'
        and so_module not like 'ESS_SECU%'
        and so_module not like 'ESSMEMBR_BACKUP%' 
        and so_status_name='FINISHED'
union
select SO_MODULE, TO_CHAR(SO_JOB_STARTED,'DD-MON-YYYY HH24:MI:SS') AS STARTED, TO_CHAR(SO_JOB_FINISHED,'DD-MON-YYYY HH24:MI:SS') FINISHED, SO_STATUS_NAME, SO_CHAIN_ID 
     from so_job_history 
     where SO_START_DATE > TO_DATE('01-FEB-2005','DD-MON-YYYY') 
        AND SO_START_DATE < TO_DATE('16-JUN-2005','DD-MON-YYYY')
        and so_module like 'SCD%'
        and so_module not like 'SCD_CHECK%'
        and so_module not like 'SCD_MOVE%'
        and so_module not like 'SCD_ENABLELOGIN%'
        and so_module not like 'SCD_DATA_COPY%'
        and so_module not like 'SCD_CPY%'
        and so_module not like 'SCD_BACKUP%'
        and so_module not like 'SCD_AGENT%'
        and so_module not like '%COPY%'
        and so_module not like 'SCD_GET%'
        and so_module not like 'SCD_PUT%'
        and so_module not like 'SCD_SET%'
        and so_status_name='FINISHED'
union
select SO_MODULE, TO_CHAR(SO_JOB_STARTED,'DD-MON-YYYY HH24:MI:SS') AS STARTED, TO_CHAR(SO_JOB_FINISHED,'DD-MON-YYYY HH24:MI:SS') FINISHED, SO_STATUS_NAME, SO_CHAIN_ID 
     from so_job_history 
     where SO_START_DATE > TO_DATE('01-FEB-2005','DD-MON-YYYY') 
        AND SO_START_DATE < TO_DATE('16-JUN-2005','DD-MON-YYYY')
        and so_module like 'TGT%'
        and so_module not like 'TGT_CHECK%'
        and so_module not like 'TGT_RCP%'
        and so_module not like 'TGT_BACKUP%'
        and so_module not like 'TGT_AGENT%'
        and so_module not like 'TGT_CPY%'
        and so_module not like '%COPY%'
        and so_module not like 'TGT_ENABLE%'
        and so_module not like 'TGT_GET%'
        and so_module not like 'TGT_PUT%'
        and so_module not like 'TGT_SEND%'
        and so_status_name='FINISHED'
union
select SO_MODULE, TO_CHAR(SO_JOB_STARTED,'DD-MON-YYYY HH24:MI:SS') AS STARTED, TO_CHAR(SO_JOB_FINISHED,'DD-MON-YYYY HH24:MI:SS') FINISHED, SO_STATUS_NAME, SO_CHAIN_ID 
     from so_job_history 
     where SO_START_DATE > TO_DATE('01-FEB-2005','DD-MON-YYYY') 
        AND SO_START_DATE < TO_DATE('16-JUN-2005','DD-MON-YYYY')
        and so_module like 'MBR%'
        and so_module not like 'MBR_CHECK%'
        and so_module not like 'MBR_AGENT%'
        and so_module not like 'MBR_BACKUP%'
        and so_module not like 'MBR_MOVE%'
        and so_module not like '%COPY%'
        and so_module not like 'MBR_FTP%'
        and so_module not like 'MBR_CPY%'
        and so_status_name='FINISHED'

select so_module, to_char(so_job_started, 'DD-MON-YYYY HH24:MI:SS') as STARTED, to_char(so_job_finished, 'DD-MON-YYYY HH24:MI:SS') as FINISHED
from so_job_history
where so_chain_id in ('2820423')
and so_job_started like '%JUL%'
order by started
--and so_chain_id like '2793953'
--or so_module like 'CLUB_DEP_IS_GRP%'
--and so_chain_id like '2802121';
