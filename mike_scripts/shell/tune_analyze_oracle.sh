. /u10/app/oracle/.profile
. ~oracle/login.sh

cd /u10/app/oracle/scripts/tune

./analyze_rebuild_airrs.sh > ./logs/analyze_rebuild_airrs.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_airrs.out | mailx -s "Analyze Rebuild AIRRS on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi

cd /u10/app/oracle/scripts/tune

./analyze_rebuild_decketr.sh > ./logs/analyze_rebuild_decketr.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_decketr.out | mailx -s "Analyze Rebuild DECKETR on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi

cd /u10/app/oracle/scripts/tune

./analyze_rebuild_kitmis.sh > ./logs/analyze_rebuild_kitmis.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_kitmis.out | mailx -s "Analyze Rebuild KITMIS on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi

cd /u10/app/oracle/scripts/tune

./analyze_rebuild_salts.sh > ./logs/analyze_rebuild_salts.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_salts.out | mailx -s "Analyze Rebuild SALTS on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi

cd /u10/app/oracle/scripts/tune

./analyze_rebuild_tdsa.sh > ./logs/analyze_rebuild_tdsa.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_tdsa.out | mailx -s "Analyze Rebuild TDSA on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi

cd /u10/app/oracle/scripts/tune


./analyze_rebuild_psr.sh > ./logs/analyze_rebuild_psr.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_psr.out | mailx -s "Analyze Rebuild PSR on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi

./analyze_rebuild_reserves.sh > ./logs/analyze_rebuild_reserves.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_reserves.out | mailx -s "Analyze Rebuild RESERVES on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi

./analyze_rebuild_scar.sh > ./logs/analyze_rebuild_scar.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_scar.out | mailx -s "Analyze Rebuild scar on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi

cd /u10/app/oracle/scripts/tune

./analyze_rebuild_decktd.sh > ./logs/analyze_rebuild_decktd.out
if [ $? -eq 0 ]    #0=found 1=notfound
then
cat ./logs/analyze_rebuild_decktd.out | mailx -s "Analyze Rebuild DECKTD on `hostname` Complete" dbasup@logistics.navair.navy.mil
fi
