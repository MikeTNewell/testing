# mv_workbook.sh - moves workbooks between instances
# usage: mv_workbook.sh <eul_owner>/<eul_pass>@<source db> <eul_owner>/<eul_pass>@<target db> <workbook identifier>
# note that the third parm is the value of DOC_DEVELOPER_KEY in EUL5_DOCUMENTS  #

eulapi -connect $1 -export workbook_temp.eex -identifier -workbook $3 -log workbook_ex.log

eulapi -connect $2 -import workbook_temp.eex -preserve_workbook_owner -log workbook_im.log -import_rename_mode refresh
