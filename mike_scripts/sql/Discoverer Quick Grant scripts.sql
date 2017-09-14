select 'CREATE USER '||:NewUser||' identified by '||:NewPass from dual
union 
select 'DEFAULT TABLESPACE NOETIXVIEWS TEMPORARY TABLESPACE NOETIX_TEMP  PROFILE DEFAULT  ACCOUNT UNLOCK;'
from dual



------------------------------------------------------------------
--SCRIPT TO CREATE DATABASE PRIVS FOR NEW USER (run in TOAD or SQL*Plus)
------------------------------------------------------------------

select 'grant '||dsp.privilege||' to '||:NewUser||';'
from dba_sys_privs dsp
where grantee like :SourceUser
union
select 'GRANT '||drp.granted_role||' to '||:NewUser||';'
from dba_role_privs drp
where grantee like :SourceUser
union
select 'grant select on '||owner||'.'||table_name||' to '||:NewUser||';'
from dba_tab_privs
where grantee like :SourceUser
and privilege like 'SELECT'
union
select 'grant execute on '||owner||'.'||table_name||' to '||:NewUser||';'
from dba_tab_privs
where grantee like :SourceUser
and privilege like 'EXECUTE'


-- SCRIPT TO CREATE EULAPI INPUT FILE 
----------------------------------
----------------------------------
-- run on Discoverer AS server  (ie dallinux60) 
-- 1) run $ORACLE_HOME/discoverer/discwb.sh
-- 2) save this query's output as a text file (user_grants.txt)
-- 3) run eulapi -connect eul_owner/eul_owner_pwd@db -cmdfile user_grants.txt -log mylog.txt
----------------------------------
----------------------------------
select '-grant_privilege -privilege all_user_privs -user '||:NewUser
from dual
union
select '-grant_privilege -identifier -business_area_access '||e5b.BA_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_BAS e5b
where ba_id in (
select gba_ba_id from eul5_owner.eul5_access_privs
where ap_type like 'GBA'
and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :SourceUser)
)
union
select '-grant_privilege -identifier -workbook_access '||ed.DOC_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_documents ed
where doc_id in (
select gd_doc_id from eul5_owner.eul5_access_privs
where ap_type like 'GD'
and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :SourceUser)
)
union
select '-grant_privilege -identifier -workbook_access '||ed.DOC_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_documents ed
where ed.DOC_EU_ID = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :SourceUser)




---

--SCRIPT TO IDENTIFY WHETHER THE NEW USER IS ALREADY PRESENT IN THE NOETIX QUERY USERS
select * from eul5_noetix_sys.n_query_users where user_name like :NewUser


--SCRIPT TO ADD THE NEW USER TO THE NOETIX QUERY USERS

insert into eul5_noetix_sys.n_query_users (
select :NewUser, user_type, language_code, create_optimizing_views, create_synonyms,
       security_rules, delete_flag, gl_security_type_code
from eul5_noetix_sys.n_query_users
where user_name like :SourceUser)


---------------------------------------
---------------------------------------
--SCRIPT TO IDENTIFY THE BUSINESS AREAS 
--RELATED TO OBJECTS 
--REFERENCED BY THE WORKBOOKS
--SHARED WITH A GIVEN USER ACCT
---------------------------------------
---------------------------------------
select * from eul5_owner.eul5_bas
where ba_id in (
select bol_ba_id from eul5_owner.EUL5_BA_OBJ_LINKS
where bol_obj_id in (
	  select obj_id from eul5_owner.eul5_objs
	  where obj_developer_key in (
		  select ex_to_par_devkey --* --ex_to_id
		  from eul5_owner.EUL5_ELEM_XREFS
		  where ex_to_type = 'ITE' 
		  and ex_from_type = 'DOC'
		  and ex_from_id in (
		  select gd_doc_id
		   from eul5_owner.eul5_access_privs
		    where ap_type like 'GD'
			 and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :NewUser)
			 )
			)	 
	      )
		)	

		



		
--EULAPI script to revoke all workbooks and business areas for a given user		
select '-revoke_privilege -identifier -workbook_access '||ed.DOC_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_documents ed
where doc_id in (
select gd_doc_id from eul5_owner.eul5_access_privs
where ap_type like 'GD'
and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :RemoveUser))
union
select '-revoke_privilege -identifier -business_area_access '||e5b.BA_DEVELOPER_KEY||' -user '||:NewUser
from eul5_owner.EUL5_BAS e5b
where ba_id in (
select gba_ba_id from eul5_owner.eul5_access_privs
where ap_type like 'GBA'
and ap_eu_id = (select eu_id from eul5_owner.eul5_eul_users where eu_username like :RemoveUser)
)
		
		
--Script to revoke all db privs from user
select 'revoke '||dsp.privilege||' from '||:NewUser||';'
from dba_sys_privs dsp
where grantee like :RemoveUser
union
select 'revoke '||drp.granted_role||' from '||:NewUser||';'
from dba_role_privs drp
where grantee like :RemoveUser
union
select 'revoke select on '||owner||'.'||table_name||' from '||:NewUser||';'
from dba_tab_privs
where grantee like :RemoveUser
and privilege like 'SELECT'
union
select 'revoke execute on '||owner||'.'||table_name||' from '||:NewUser||';'
from dba_tab_privs
where grantee like :RemoveUser
and privilege like 'EXECUTE'
		
		
--DOCUMENT ACCESS FOR NAMED USER		
select eeu.eu_username, edo.EU_USERNAME||'.'||ed.DOC_NAME 
from eul5_owner.eul5_eul_users eeu, eul5_owner.eul5_access_privs eap,
     eul5_owner.eul5_documents ed, eul5_owner.eul5_eul_users edo
where eeu.EU_ID = eap.AP_EU_ID
and eap.GD_DOC_ID = ed.DOC_ID
and ed.DOC_EU_ID = edo.EU_ID
and eeu.eu_username like :MyUser

	
--EXPORT OF WORKBOOKS FOR ID'ed USER	
select '-export /home/oradis1/eulapi_scripts/wbs/wb'||doc_id||'.xml -workbook '||doc_developer_key||' -identifier' 
from eul5_owner.eul5_documents
where doc_eu_id = 495970

select *--'-export /home/oradis1/eulapi_scripts/wbs/wb'||doc_id||'.xml -workbook '||doc_developer_key||' -identifier' 
from eul5_owner.eul5_documents
where doc_name like 'AHINKLE%'

select '-export /home/oradis1/eulapi_scripts/wbs/wb'||doc_id||'.xml -workbook '||doc_developer_key||' -identifier' 
from eul5_owner.eul5_documents
where doc_id = 838256	