select fu.user_name, fu.last_update_date, fu1.user_name, fu.* 
from fnd_user fu, fnd_user fu1
where fu.last_updated_by = fu1.user_id
and fu.last_update_date > sysdate - 3


select fr.last_update_date, fu1.user_name, fr.* 
from fnd_responsibility fr, fnd_user fu1
where fr.last_updated_by = fu1.user_id
and fr.last_update_date > sysdate - 20


select furg.last_update_date, fu1.user_name, furg.* 
from fnd_user_resp_groups furg, fnd_user fu1
where furg.last_updated_by = fu1.user_id
and furg.last_update_date > sysdate - 3

