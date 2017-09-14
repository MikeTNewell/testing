# refresh_ba.sh - refreshes specific business area
# usage: refresh_ba.sh <eul_owner>/<eul_pass>@<source db> <business_area identifier>
# note that the second parm is the value of BA_DEVELOPER_KEY in EUL5_BAS #


eulapi -connect $1 -refresh_business_area $2  -identifier -log refresh_ba.log
