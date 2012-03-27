#!/bin/sh

SCRIPT_NAME='wedro_mount.sh'
SCRIPT_START='17'
SCRIPT_STOP='03'

script_install() {
  cp $0 /etc/init.d/$SCRIPT_NAME
  chmod a+x /etc/init.d/$SCRIPT_NAME
  update-rc.d $SCRIPT_NAME defaults $SCRIPT_START $SCRIPT_STOP > /dev/null
}

script_remove() {
  update-rc.d -f $SCRIPT_NAME remove > /dev/null
  rm -f /etc/init.d/$SCRIPT_NAME
}

#######################################################################

CUSTOM="/DataVolume/custom"
C_OPT="$CUSTOM/opt"
C_ROOT="$CUSTOM/root"
C_VAR="$CUSTOM/var"

###################################################

start() {
if [ -z "$(mount | grep '\/opt')" ]; then
  echo "Mounting OPTWARE"
  mount --bind $C_OPT /opt
else
  echo "Error: OPTWARE seems already mounted" >&2
fi

if [ -z "$(mount | grep '\/root')" ]; then
  echo "Mounting ROOT"
  mount --bind $C_ROOT /root
else
  echo "Error: ROOT seems already mounted" >&2
fi

if [ -z "$(mount | grep '\/var\/opt')" ]; then
  echo "Mounting VAR/OPT"
  mount --bind $C_VAR /var/opt
else
  echo "Error: VAR/OPT seems already mounted" >&2
fi

}

stop() {
if [ -n "$(mount | grep '\/opt')" ]; then
  echo "Unmounting OPTWARE"
  umount /opt
else
  echo "Error: OPTWARE seems already unmounted" >&2
fi

if [ -n "$(mount | grep '\/root')" ]; then
  echo "Unmounting ROOT"
  umount /root
else
  echo "Error: ROOT seems already unmounted" >&2
fi

if [ -n "$(mount | grep '\/var\/opt')" ]; then
  echo "Unmounting VAR/OPT"
  umount /var/opt
else
  echo "Error: VAR/OPT seems already unmounted" >&2
fi

}


restart() {
    /etc/init.d/wedro_chroot.sh stop
    stop
    start
    /etc/init.d/wedro_chroot.sh start
}

case "$1" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
        restart
    ;;
    install)
        script_install
    ;;
    remove)
        script_remove
    ;;
    *)
        echo $"Usage: $0 {start|stop|restart}"
        exit 1
esac

exit $?
