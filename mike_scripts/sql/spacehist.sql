rem -----------------------------------------------------------------------
rem Filename:   spacehist.sql
rem Purpose:    Save summary of database space history over time
rem Notes:      Set JOB_QUEUE_PROCESSES to a value > 0 or schedule from
rem             an external scheduler (corn, at...)
rem Date:       15-May-2002
rem Author:     Frank Naude, Oracle FAQ
rem -----------------------------------------------------------------------

---------------------------------------------------------------------------
-- Create history table...
---------------------------------------------------------------------------
drop table db_space_hist;
create table db_space_hist (
	timestamp    date,
	total_space  number(8),
	used_space   number(8),
	free_space   number(8),
        pct_inuse    number(5,2),
        num_db_files number(5)
);

---------------------------------------------------------------------------
-- Stored proc to populate table...
---------------------------------------------------------------------------
create or replace procedure db_space_hist_proc as
begin
   -- Delete old records...
   delete from db_space_hist where timestamp > SYSDATE + 364;
   -- Insert current utilization values...
   insert into db_space_hist 
	select sysdate, total_space,
	       total_space-nvl(free_space,0) used_space,
	       nvl(free_space,0) free_space,
	       ((total_space - nvl(free_space,0)) / total_space)*100 pct_inuse,
	       num_db_files
	from ( select sum(bytes)/1024/1024 free_space
	       from   sys.DBA_FREE_SPACE ) FREE,
	     ( select sum(bytes)/1024/1024 total_space,
	              count(*) num_db_files
	       from   sys.DBA_DATA_FILES) FULL;
   commit;
end;
/
show errors

---------------------------------------------------------------------------
-- Schedule the job using the DB Job System. This section can be removed if 
-- the job is sceduled via an external scheduler.
---------------------------------------------------------------------------
declare
  v_job number;
begin
  select job into v_job from user_jobs where what like 'db_space_hist_proc%';
  dbms_job.remove(v_job);
  dbms_job.submit(v_job, 'db_space_hist_proc;', sysdate,
                        'sysdate+7');   -- Run every 7 days
  dbms_job.run(v_job);
  dbms_output.put_line('Job '||v_job||' re-submitted.');
exception
  when NO_DATA_FOUND then
       dbms_job.submit(v_job, 'db_space_hist_proc;', sysdate,
                      'sysdate+7');   -- Run every 7 days
       dbms_job.run(v_job);
       dbms_output.put_line('Job '||v_job||' submitted.');
end;
/

---------------------------------------------------------------------------
-- Generate a space history report...
---------------------------------------------------------------------------
select to_char(timestamp, 'DD Mon RRRR HH24:MI') "Timestamp",
       total_space "DBSize (Meg)",
       used_space  "Free (Meg)",
       free_space  "Used (Meg)",
       pct_inuse   "% Used",
       num_db_files "Num DB Files"
  from db_space_hist
 order by timestamp;


