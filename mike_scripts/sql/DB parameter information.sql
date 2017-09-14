-- Find DB parameter information from init.ora 
SELECT name,value,isses_modifiable,issys_modifiable
FROM v$parameter

-- Free memory in the sga 
select * from v$sgastat where name = 'free memory'

-- View NLS Parameters 
select * from v$nls_parameters;


