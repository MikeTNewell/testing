#!/bin/sh
#
# nodemgr Oracle Weblogic NodeManager service
#
# chkconfig:   345 85 15
# description: Oracle Weblogic NodeManager service

### BEGIN INIT INFO
# Provides: nodemgr
# Required-Start: $network $local_fs
# Required-Stop:
# Should-Start:
# Should-Stop:
# Default-Start: 3 4 5
# Default-Stop: 0 1 2 6
# Short-Description: Oracle Weblogic NodeManager service.
# Description: Starts and stops Oracle Weblogic NodeManager.
### END INIT INFO

. /etc/rc.d/init.d/functions

# Your WLS home directory (where wlserver_10.3 is)
export MW_HOME="/oracle/product/mw11g"
export JAVA_HOME="/oracle/java/jdk1.6.0_29"
DAEMON_USER="oracle"
PROCESS_STRING="^.*/oracle/product/mw11g/.*weblogic.NodeManager.*"

source $MW_HOME/wlserver_10.3/server/bin/setWLSEnv.sh > /dev/null
export NodeManagerHome="$WL_HOME/common/nodemanager"
NodeManagerLockFile="$NodeManagerHome/nodemanager.log.lck"

PROGRAM="$MW_HOME/wlserver_10.3/server/bin/startNodeManager.sh"
SERVICE_NAME=`/bin/basename $0`
LOCKFILE="/var/lock/subsys/$SERVICE_NAME"

RETVAL=0

start() {
        OLDPID=`/usr/bin/pgrep -f $PROCESS_STRING`
        if [ ! -z "$OLDPID" ]; then
            echo "$SERVICE_NAME is already running (pid $OLDPID) !"
            exit
        fi

        echo -n $"Starting $SERVICE_NAME: "
        /bin/su $DAEMON_USER -c "$PROGRAM &"

        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && touch $LOCKFILE
}

stop() {
        echo -n $"Stopping $SERVICE_NAME: "
        OLDPID=`/usr/bin/pgrep -f $PROCESS_STRING`
        if [ "$OLDPID" != "" ]; then
            /bin/kill -TERM $OLDPID
        else
            /bin/echo "$SERVICE_NAME is stopped"
        fi
        echo
        /bin/rm -f $NodeManagerLockFile
        [ $RETVAL -eq 0 ] && rm -f $LOCKFILE

}

restart() {
        stop
        sleep 10
        start
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart|force-reload|reload)
        restart
        ;;
  condrestart|try-restart)
        [ -f $LOCKFILE ] && restart
        ;;
  status)
        OLDPID=`/usr/bin/pgrep -f $PROCESS_STRING`
        if [ "$OLDPID" != "" ]; then
            /bin/echo "$SERVICE_NAME is running (pid: $OLDPID)"
        else
            /bin/echo "$SERVICE_NAME is stopped"
        fi
        RETVAL=$?
        ;;
  *)
        echo $"Usage: $0 {start|stop|status|restart|reload|force-reload|condrestart}"
        exit 1
esac

exit $RETVAL

