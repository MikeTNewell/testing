select fcq.concurrent_queue_name, fcq.concurrent_queue_id, 
       fcqt.user_concurrent_queue_name, fcq.RUNNING_PROCESSES, fcq.MAX_PROCESSES, 
       nvl(sq.req_running,0) running_jobs,
	   nvl(sqp.pendings,0) pending_jobs
from applsys.fnd_concurrent_queues fcq, applsys.fnd_concurrent_queues_tl fcqt, (
	select fcp.concurrent_queue_id, count(fcr.request_id) req_running
	from applsys.fnd_concurrent_processes fcp, applsys.fnd_concurrent_requests fcr
	where fcp.CONCURRENT_PROCESS_ID = fcr.CONTROLLING_MANAGER
	and fcr.phase_code = 'R'
	and fcr.status_code = 'R'
	group by fcp.concurrent_queue_id) sq, 
	(select fcwr.concurrent_queue_name, 
		   count(fcwr.request_id) pendings 
	from apps.fnd_concurrent_worker_requests fcwr
	where fcwr.phase_code not in 'R' and fcwr.status_code not in 'I'
	and fcwr.requested_start_date <= sysdate
	group by fcwr.concurrent_queue_name) sqp
where fcq.concurrent_queue_id = fcqt.concurrent_queue_id 
and fcq.CONCURRENT_QUEUE_ID = sq.concurrent_queue_id (+)
and fcq.CONCURRENT_QUEUE_name = sqp.concurrent_queue_name (+)
