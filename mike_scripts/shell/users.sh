sqlplus <<EOF
/ as sysdba
@users_load_trigger.sql
exit
EOF
sqlldr control='users.ctl' log='users.log' rows=1 errors=100 <<EOF
/ as sysdba
EOF
sqlplus <<EOF
/ as sysdba
drop trigger scar2.users_load_trigger;
drop trigger scar2.contract_load_trigger;
drop trigger scar2.agreement_load_trigger;
exit
EOF
