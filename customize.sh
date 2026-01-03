#!/sbin/sh

SKIPUNZIP=1
ASH_STANDALONE=1

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

if [ ! -d "${service_dir}" ]; then
	mkdir -p ${service_dir}
fi

unzip -qo "${ZIPFILE}" -x 'META-INF/*' -d $MODPATH

if [ -d /data/adb/aab ]; then
	cp /data/adb/aab/scripts/aab.config /data/adb/aab/scripts/aab.config.bak
	cp -f $MODPATH/aab/scripts/* /data/adb/aab/scripts/
	ui_print "- 用户配置文件已更改为 aab.config.bak"
	ui_print "- 如有需要请在重启前自行更改配置"
	rm -rf $MODPATH/aab
else
	mv $MODPATH/aab /data/adb/
fi

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
