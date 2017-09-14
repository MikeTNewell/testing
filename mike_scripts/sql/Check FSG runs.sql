select fcr.request_id, fu.user_name, rr.name,((nvl(actual_completion_date, sysdate) - nvl(actual_start_date, sysdate))*24*60) minutes, 
fcp.user_concurrent_program_name, fl0.meaning phase, fl1.meaning status,  
fcr.requested_start_date, fcr.actual_start_date, fcr.actual_completion_date,
fcr.number_of_copies, fcr.completion_text,fcr.printer, fcr.argument1 period, 
fcr.ARGUMENT2 rep_date,rr.NAME rep_name, rrasr.name row_set, rrasc.name col_set, fcr.ARGUMENT6 currency,
fcr.ARGUMENT7 SOB_ID, rrcs.name content_set, 
fcr.ARGUMENT11 segment_override,
rro.NAME row_order, rrds.NAME display_set
from fnd_concurrent_requests fcr, fnd_concurrent_programs_tl fcp,
rg_report_axis_sets rrasr, rg_report_axis_sets rrasc, rg_reports rr, rg_report_content_sets rrcs,
rg_row_orders rro, rg_report_display_sets rrds, fnd_user fu, fnd_lookups fl0, fnd_lookups fl1 
where fcr.CONCURRENT_PROGRAM_ID = fcp.CONCURRENT_PROGRAM_ID
and fcr.REQUESTED_BY = fu.user_id
and fcr.phase_code = fl0.lookup_code
and fcr.status_code = fl1.lookup_code
and fcr.argument4 = to_char(rrasr.AXIS_SET_ID)
and fcr.argument5 = to_char(rrasc.AXIS_SET_ID)
and fcr.argument3 = to_char(rr.report_id)
and fcr.argument8 = to_char(rrcs.content_set_id(+))
and fcr.argument13 = to_char(rro.ROW_ORDER_ID(+))
and fcr.argument16 = to_char(rrds.REPORT_DISPLAY_SET_ID(+))
and fcp.USER_CONCURRENT_PROGRAM_NAME like 'Fina%'
-- selects only FSGs
and fl0.lookup_type = 'CP_PHASE_CODE'
and fl1.lookup_type = 'CP_STATUS_CODE'
and phase_code = 'R'
-- selects only running requests
--and (trunc(sysdate)+6/24 between fcr.ACTUAL_START_DATE and fcr.ACTUAL_COMPLETION_DATE
--or trunc(sysdate)+  6/24 > fcr.ACTUAL_START_DATE and fcr.status_code = 'R')
--and fu.user_name like 'PRELIM'		
order by rr.name, fcr.request_id  asc

	  	 				   
