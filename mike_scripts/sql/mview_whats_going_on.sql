select ss.name mview_name 
, ss.refresh_method mview_type 
, ss.last_refresh 
, mv.last_refresh_type 
, decode(mv.refresh_method||mvj.operator_type 
, 'FASTI' , 'Fast' 
, 'FORCEI', 'Force' 
, 'FASTR' , 'Fast Right Outter Join' 
, 'FORCER', 'Force Right Outter Join' 
, 'FASTL' , 'Fast Left Outter Join' 
, 'FORCEL', 'Force Left Outter Join' 
, mv.refresh_method||mvj.operator_type 
) refresh_method 
, mv.build_mode 
, decode( ob.status 
, 'VALID', decode( ss.cr_operations 
, 'REGENERATE', 'Require Complete Refresh' 
, 'VALID', decode( mv.compile_state 
, 'VALID', decode ( mva.unusable 
, 'Y', 'MV is Unusables' 
, decode(mva.known_stale 
, 'Y', 'Unusable After Refresh' 
, 'N', 'Valid' 
) 
) 
, 'Require Complete Refresh' 
) 
) 
, 'Error in Object rebuild' 
) Status 
, log.master table_name 
, log.log_table mvlog 
, trigger_name 
from all_snapshots ss 
, all_mviews mv 
, all_objects ob 
, all_triggers trg 
, all_mview_logs log 
, all_mview_detail_relations mdr 
, all_mview_analysis mva 
, all_mview_joins mvj 
where ss.name like 'ENTER MV NAME' 
and ss.name = mv.mview_name 
and ob.object_name = mv.mview_name 
and ob.object_type = 'MATERIALIZED VIEW' 
and mv.owner = ob.owner 
and trg.table_name(+) = ob.object_name 
and trg.owner(+) = ob.owner 
and mdr.mview_name = mv.mview_name 
and mva.mview_name = mv.mview_name 
and mva.owner = mv.owner 
and mvj.detailobj1_relation = mdr.detailobj_name 
and mvj.mview_name = mv.mview_name 
and mvj.owner = mv.owner 
and log.master(+) = mdr.detailobj_name 