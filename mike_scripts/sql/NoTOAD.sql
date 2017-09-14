rem -----------------------------------------------------------------------
rem Filename:   NoTOAD.sql
rem Purpose:    Block developers from using TOAD and other tools on 
rem             production databases.
rem Date:       19-Jan-2004
rem Author:     Frank Naude
rem -----------------------------------------------------------------------

CONNECT / AS SYSDBA;

CREATE OR REPLACE TRIGGER block_tools_from_prod
  AFTER LOGON ON DATABASE
DECLARE
  v_prog sys.v_$session.program%TYPE;
BEGIN
  SELECT program INTO v_prog 
    FROM sys.v_$session
  WHERE  audsid = USERENV('SESSIONID')
    AND  audsid != 0  -- Don't Check SYS Connections
    AND  rownum = 1;  -- Parallel processes will have the same AUDSID's

  IF UPPER(v_prog) LIKE '%TOAD%' OR UPPER(v_prog) LIKE '%T.O.A.D%' OR -- Toad
     UPPER(v_prog) LIKE '%SQLNAV%' OR	-- SQL Navigator
     UPPER(v_prog) LIKE '%PLSQLDEV%' OR -- PLSQL Developer
     UPPER(v_prog) LIKE '%BUSOBJ%' OR   -- Business Objects
     UPPER(v_prog) LIKE '%EXCEL%'       -- MS-Excel plug-in
  THEN
     RAISE_APPLICATION_ERROR(-20000, 'Development tools are not allowed on PROD DB!');
  END IF;
END;
/
SHOW ERRORS


