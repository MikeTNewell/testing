Spool recompile.sql

Select 'alter 'object_type' 'object_name' compile;'
From user_objects
Where status <> 'VALID'
And object_type IN ('VIEW','SYNONYM',
'PROCEDURE','FUNCTION',
'PACKAGE','TRIGGER');

Spool off
@recompile.sql


Note: VIEW,SYNONYM,PROCEDURE,PACKAGE,FUNCTION,TRIGGER


Spool pkg_body.sql

Select 'alter package 'object_name' compile body;'
From user_objects
where status <> 'VALID'
And object_type = 'PACKAGE BODY';

Spool off
@pkg_body.sql


Spool undefined.sql

select 'alter materizlized view 'object_name' compile;'
From user_objects
where status <> 'VALID'
And object_type ='UNDEFINED';

Spool off
@undefined.sql


Spool javaclass.sql

Select 'alter java class 'object_name' resolve;'
from user_objects
where status <> 'VALID'
And object_type ='JAVA CLASS';

Spool off
@javaclass.sql


Spool typebody.sql

Select 'alter type 'object_name' compile body;'
From user_objects
where status <> 'VALID'
And object_type ='TYPE BODY';

Spool off
@typebody.sql


Spool public_synonym.sql

Select 'alter public synonym 'object_name' compile;'
From user_objects
Where status <> 'VALID'
And owner = 'PUBLIC'
And object_type = 'SYNONYM';

Spool off
@public_synonym.sql
