select * from so_job_table
where so_program = 'CONCMK'
order by so_module asc

select sjt.SO_MODULE, sjp.SO_PROMPT_DFLT 
from so_job_prompts sjp, so_job_table sjt
where sjp.SO_JOB_SEQ = sjt.SO_JOB_SEQ 
and sjp.so_prompt = 5
and sjt.SO_PROGRAM = 'CONCMK'


select sjt.so_module, sq.args 
from so_job_table sjt, (  
		select so_job_seq, count(*) args
		from so_job_prompts 
		where so_job_seq in  (
			select so_job_seq from so_job_table
			where so_program = 'CONCMK'
			and so_module <> 'CONCSUB')
		group by so_job_seq
		) sq
where sjt.so_job_seq = sq.so_job_seq			

 
