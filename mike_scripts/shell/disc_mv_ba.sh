# mv_ba.sh - moves business areas between instances
# usage: mv_ba.sh <eul_owner>/<eul_pass>@<source db> <eul_owner>/<eul_pass>@<target db> <business_area_name>

eulapi_sp -connect $1 -export ba_temp.eex -business_area_and_contents "$3" -log ba_ex.log

eulapi -connect $2 -import ba_temp.eex -log ba_im.log -import_rename_mode refresh
