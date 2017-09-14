# mv_folder.sh - moves folders between instances
# usage: mv_folder.sh <eul_owner>/<eul_pass>@<source db> <eul_owner>/<eul_pass>@<target db> <folder_name>

eulapi_sp -connect $1 -export folder_temp.eex -folder "$3" -log folder_ex.log

eulapi -connect $2 -import folder_temp.eex -log folder_im.log -import_rename_mode refresh
