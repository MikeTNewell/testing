REM* This script allows me to create a script to reset a users password after I
REM* change it to what I want for testing purposes.
REM*
set pagesize 0 verify off echo off
REM*
REM* Select the encrypted password form DBA_USERS.
set termout on
accept userid char prompt 'Enter userid of user to become: '
set termout off
spool resetid.sql
Select 'alter user &userid identified by values '||''''||password||''''||';'
from sys.dba_users where username = upper('&userid');
spool off
set termout on
accept passwd char prompt 'Enter new password: '
alter user &userid identified by &passwd;
connect &userid/&passwd
show user
prompt To reset &userid connect as system and run resetid
undefine userid
undefine passwd

