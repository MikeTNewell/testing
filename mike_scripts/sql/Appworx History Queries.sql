select * from aw_job_history
where so_module like 'OCM%ERP%'


select so_module, to_char(so_job_started, 'DD-MON-YYYY HH24:MI:SS'), to_char(so_job_finished, 'DD-MON-YYYY HH24:MI:SS'), so_chain_id, so_jobid 
from so_job_history
where so_chain_id in (2842967, 2842936)
order by so_chain_id, so_jobid

select so_module, so_start_date, so_job_finished, so_jobid, so_chain_id from so_job_history
where so_module like 'OCM_GENLED_RPTUS%'
order by so_start_date;

select * from so_job_args
where so_jobid > 2716326
and so_jobid < 2716337
order by so_jobid;

select * from so_job_history
where so_module like 'DEPAR%';

select * from so_job_history
where so_chain_id like '2793953'
or so_chain_id like '2802121';