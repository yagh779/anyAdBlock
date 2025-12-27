#!/sbin/sh

SKIPUNZIP=1
ASH_STANDALONE=1

DATADIR="/data/adb/aab"
TIMESTAMP=$(date "+%Y%m%d%H%M")

if [ "$BOOTMODE" ! = true ]; then
	abort "Error: Please install in Magisk Manager, KernelSU Manager or APatch"
fi

if [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10670 ]; then
	abort "Error: Please update your KernelSU"
fi

if [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10683 ]; then
	service_dir="/data/adb/ksu/service.d"
else
	service_dir="/data/adb/service.d"
fi

if [ ! -d "$service_dir" ]; then
	mkdir -p $service_dir
fi

unzip -qo "${ZIPFILE}" -x 'META-INF/*' -d $MODPATH

if [ -d ${DATADIR} ]; then
	mkdir -p ${DATADIR}.old/${TIMESTAMP}/
	mv ${DATADIR}/* ${DATADIR}.old/${TIMESTAMP}/
	rm -rf ${DATADIR}
	ui_print "- User configuration have been move to ${DATADIR}.old/${TIMESTAMP}"
	ui_print "- please chage your configuration again befor reboot"
fi

mv $MODPATH/aab /data/adb/
mkdir -p /data/adb/aab/bin/
mkdir -p /data/adb/aab/run/

mv -f $MODPATH/aab_service.sh $service_dir/

rm -f customize.sh

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive /data/adb/aab/ 0 0 0755 0644
set_perm_recursive /data/adb/aab/scripts/ 0 0 0755 0700
set_perm_recursive /data/adb/aab/bin/ 0 0 0755 0700

set_perm $service_dir/aab_service.sh 0 0 0700

# fix "set_perm_recursive /data/adb/aab/scripts" not working on some phones.
chmod ugo+x /data/adb/aab/scripts/*
