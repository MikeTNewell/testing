. ~oracle/.profile > /dev/null #done for cron purposes
. ~oracle/login.sh

ORACLE_HOME=/u10/app/oracle/product/10.2.0
export ORACLE_HOME
PATH=/usr/sbin:/usr/ccs/bin:/usr/ccs/lib:/etc:/usr/ucb:/usr/bin/X11:/usr/lbin:/news/pub/bin:/usr/lpp/csd/bin:/usr/lpp/ssp/bin:/usr/lpp/ssp/kerberos/bin:/usr/bin:.:/u10/app/oracle/product/10.2.0/bin
export PATH
ORACLE_SID=lmdss
export ORACLE_SID

cd /u10/app/oracle/scripts/space/hot_spots

sqlplus -s <<ENDSQL >hotspot.out 2>&1
$DEV_LMDSS_SYSTEM

@/u10/app/oracle/scripts/space/hot_spots/hot_spot.sql

ENDSQL

 if grep "no rows selected" hotspot.out > /dev/null
    then
      echo >> hotspot.out
      echo "***** No Problem exists Hot Spots LOGISTICS03 LMDSS DEV*****  "`date` >> hotspot.out
      echo >> hotspot.out

      cat hotspot.out >> hotspot.log

    else
      echo >> hotspot.out
      echo "***** Space Problem may exist LOGISTICS03 LMDSS DEV DataBase *****  "`date` >> hotspot.out
      echo >> hotspot.out
mail -s "Hot Spot Exists on LOGISTICS03 LMDSS DEV" dbasup@navair.nalda.navy.mil < hotspot.out
mail -s "Hot Spot Exists on LOGISTICS03 LMDSS DEV" prnalda@scipax.com < hotspot.out

  fi


