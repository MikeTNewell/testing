
set pagesize 20
column "Program Name" format a60

spool top_ten_progs.out

   select "Program Name", "Submissions" from  (						
			select substr(fcp.USER_CONCURRENT_PROGRAM_NAME, 1,60) "Program Name", 	
			       count(*) "Submissions",	
			       rank() over (order by count(*) desc) "Ranking"	
		        from fnd_concurrent_requests fcr, 	
			     fnd_concurrent_programs_tl fcp
  		       where fcr.CONCURRENT_PROGRAM_ID = fcp.CONCURRENT_PROGRAM_ID	
 		         and fcr.PROGRAM_APPLICATION_ID = fcp.APPLICATION_ID	
			 and fcr.actual_start_date 
			      between trunc(sysdate -1) 	
				  and trunc(sysdate -0)	
   		    group by fcp.USER_CONCURRENT_PROGRAM_NAME	
				 )		  
   where "Ranking" <= 10
   order by "Submissions" desc						
/
spool off
exit