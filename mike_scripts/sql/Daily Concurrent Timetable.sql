--LIST OF JOBS RUNNING AT EACH CHECK TIME
select to_char(test_time, 'DD-MON-RR HH24:MI') test_time, count(*) job_count
from (
select fcr.request_id, sq.test_time
from fnd_concurrent_requests fcr,
	(
		select trunc(sysdate-1) test_time from dual
		union
		select trunc(sysdate-1) + 1/96 from dual
		union
		select trunc(sysdate-1) + 2/96 from dual
		union
		select trunc(sysdate-1) + 3/96 from dual
		union
		select trunc(sysdate-1) + 4/96 from dual
		union
		select trunc(sysdate-1) + 5/96 from dual
		union
		select trunc(sysdate-1) + 6/96 from dual
		union
		select trunc(sysdate-1) + 7/96 from dual
		union
		select trunc(sysdate-1) + 8/96 from dual
		union
		select trunc(sysdate-1) + 9/96 from dual
		union
		select trunc(sysdate-1) + 10/96 from dual
		union
		select trunc(sysdate-1) + 11/96 from dual
		union
		select trunc(sysdate-1) + 12/96 from dual
		union
		select trunc(sysdate-1) + 13/96 from dual
		union
		select trunc(sysdate-1) + 14/96 from dual
		union
		select trunc(sysdate-1) + 15/96 from dual
		union
		select trunc(sysdate-1) + 16/96 from dual
		union
		select trunc(sysdate-1) + 17/96 from dual
		union
		select trunc(sysdate-1) + 18/96 from dual
		union
		select trunc(sysdate-1) + 19/96 from dual
		union
		select trunc(sysdate-1) + 20/96 from dual
		union
		select trunc(sysdate-1) + 21/96 from dual
		union
		select trunc(sysdate-1) + 22/96 from dual
		union
		select trunc(sysdate-1) + 23/96 from dual
		union
		select trunc(sysdate-1) + 24/96 from dual
		union
		select trunc(sysdate-1) + 25/96 from dual
		union
		select trunc(sysdate-1) + 26/96 from dual
		union
		select trunc(sysdate-1) + 27/96 from dual
		union
		select trunc(sysdate-1) + 28/96 from dual
		union
		select trunc(sysdate-1) + 29/96 from dual
		union
		select trunc(sysdate-1) + 30/96 from dual
		union
		select trunc(sysdate-1) + 31/96 from dual
		union
		select trunc(sysdate-1) + 32/96 from dual
		union
		select trunc(sysdate-1) + 33/96 from dual
		union
		select trunc(sysdate-1) + 34/96 from dual
		union
		select trunc(sysdate-1) + 35/96 from dual
		union
		select trunc(sysdate-1) + 36/96 from dual
		union
		select trunc(sysdate-1) + 37/96 from dual
		union
		select trunc(sysdate-1) + 38/96 from dual
		union
		select trunc(sysdate-1) + 39/96 from dual
		union
		select trunc(sysdate-1) + 40/96 from dual
		union
		select trunc(sysdate-1) + 41/96 from dual
		union
		select trunc(sysdate-1) + 42/96 from dual
		union
		select trunc(sysdate-1) + 43/96 from dual
		union
		select trunc(sysdate-1) + 44/96 from dual
		union
		select trunc(sysdate-1) + 45/96 from dual
		union
		select trunc(sysdate-1) + 46/96 from dual
		union
		select trunc(sysdate-1) + 47/96 from dual
		union
		select trunc(sysdate-1) + 48/96 from dual
		union
		select trunc(sysdate-1) + 49/96 from dual
		union
		select trunc(sysdate-1) + 50/96 from dual
		union
		select trunc(sysdate-1) + 51/96 from dual
		union
		select trunc(sysdate-1) + 52/96 from dual
		union
		select trunc(sysdate-1) + 53/96 from dual
		union
		select trunc(sysdate-1) + 54/96 from dual
		union
		select trunc(sysdate-1) + 55/96 from dual
		union
		select trunc(sysdate-1) + 56/96 from dual
		union
		select trunc(sysdate-1) + 57/96 from dual
		union
		select trunc(sysdate-1) + 58/96 from dual
		union
		select trunc(sysdate-1) + 59/96 from dual
		union
		select trunc(sysdate-1) + 60/96 from dual
		union
		select trunc(sysdate-1) + 61/96 from dual
		union
		select trunc(sysdate-1) + 62/96 from dual
		union
		select trunc(sysdate-1) + 63/96 from dual
		union
		select trunc(sysdate-1) + 64/96 from dual
		union
		select trunc(sysdate-1) + 65/96 from dual
		union
		select trunc(sysdate-1) + 66/96 from dual
		union
		select trunc(sysdate-1) + 67/96 from dual
		union
		select trunc(sysdate-1) + 68/96 from dual
		union
		select trunc(sysdate-1) + 69/96 from dual
		union
		select trunc(sysdate-1) + 70/96 from dual
		union
		select trunc(sysdate-1) + 71/96 from dual
		union
		select trunc(sysdate-1) + 72/96 from dual
		union
		select trunc(sysdate-1) + 73/96 from dual
		union
		select trunc(sysdate-1) + 74/96 from dual
		union
		select trunc(sysdate-1) + 75/96 from dual
		union
		select trunc(sysdate-1) + 76/96 from dual
		union
		select trunc(sysdate-1) + 77/96 from dual
		union
		select trunc(sysdate-1) + 78/96 from dual
		union
		select trunc(sysdate-1) + 79/96 from dual
		union
		select trunc(sysdate-1) + 80/96 from dual
		union
		select trunc(sysdate-1) + 81/96 from dual
		union
		select trunc(sysdate-1) + 82/96 from dual
		union
		select trunc(sysdate-1) + 83/96 from dual
		union
		select trunc(sysdate-1) + 84/96 from dual
		union
		select trunc(sysdate-1) + 85/96 from dual
		union
		select trunc(sysdate-1) + 86/96 from dual
		union
		select trunc(sysdate-1) + 87/96 from dual
		union
		select trunc(sysdate-1) + 88/96 from dual
		union
		select trunc(sysdate-1) + 89/96 from dual
		union
		select trunc(sysdate-1) + 90/96 from dual
		union
		select trunc(sysdate-1) + 91/96 from dual
		union
		select trunc(sysdate-1) + 92/96 from dual
		union
		select trunc(sysdate-1) + 93/96 from dual
		union
		select trunc(sysdate-1) + 94/96 from dual
		union
		select trunc(sysdate-1) + 95/96 from dual
		union
		select trunc(sysdate-1) + 96/96 from dual
	) sq
where sq.test_time between fcr.actual_start_date and fcr.actual_completion_date	)
group by test_time 



--LIST OF CHECK TIMES TO CROSSREF

select to_char(trunc(sysdate-1), 'DD-MON-RR HH24:MI') test_time from dual
union
select  to_char(trunc(sysdate-1) + 1/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 2/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 3/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 4/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 5/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 6/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 7/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 8/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 9/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 10/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 11/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 12/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 13/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 14/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 15/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 16/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 17/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 18/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 19/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 20/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 21/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 22/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 23/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 24/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 25/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 26/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 27/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 28/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 29/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 30/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 31/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 32/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 33/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 34/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 35/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 36/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 37/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 38/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 39/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 40/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 41/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 42/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 43/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 44/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 45/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 46/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 47/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 48/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 49/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 50/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 51/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 52/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 53/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 54/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 55/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 56/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 57/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 58/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 59/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 60/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 61/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 62/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 63/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 64/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 65/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 66/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 67/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 68/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 69/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 70/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 71/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 72/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 73/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 74/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 75/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 76/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 77/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 78/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 79/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 80/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 81/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 82/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 83/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 84/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 85/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 86/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 87/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 88/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 89/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 90/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 91/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 92/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 93/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 94/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 95/96, 'DD-MON-RR HH24:MI') from dual
union
select  to_char(trunc(sysdate-1) + 96/96, 'DD-MON-RR HH24:MI') from dual


