rem -----------------------------------------------------------------------
rem Filename:   dbgrowth.sql
rem Purpose:    Show database growth in Meg per month for the last year
rem DB Version: 8.0 or above
rem Note:       File extending is not factored in as it's not the available 
rem             in the dictionary.
rem Date:       19-Mar-2000
rem Author:     Frank Naude, Oracle FAQ
rem -----------------------------------------------------------------------

set pagesize 50000
tti "Database growth per month for last year"

select to_char(creation_time, 'RRRR Month') "Month",
       sum(bytes)/1024/1024 "Growth in Meg"
  from sys.v_$datafile
 where creation_time > SYSDATE-365
 group by to_char(creation_time, 'RRRR Month')
/

tti off

