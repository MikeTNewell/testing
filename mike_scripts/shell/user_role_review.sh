. /u10/app/oracle/.profile
. ~oracle/login.sh

cd /u10/app/oracle/scripts/stig_srr/

export LOG='/u10/app/oracle/scripts/stig_srr/logs/user_role_review.out'
export DIR='/u10/app/oracle/scripts/stig_srr/'

cd $DIR/AIRRS
./AIRRS_role_review.sh > $LOG


cd $DIR/DECKETR
./DECKETR_role_review.sh >> $LOG

cd $DIR/KITMIS
./KITMIS_role_review.sh >> $LOG

cd $DIR/LMDSS
./LMDSS_role_review.sh >> $LOG

cd $DIR/OOMA
./OOMA_role_review.sh >> $LOG

cd $DIR/SALTS
./SALTS_role_review.sh >> $LOG

cd $DIR/TDSA
./TDSA_role_review.sh >> $LOG

cd $DIR/ADMINDB
./ADMINDB_role_review.sh >> $LOG

exit

