#!/sbin/sh

module_dir="/data/adb/modules/anyAdBlock"

[ -n "$(magisk -v | grep lite)" ] && module_dir=/data/adb/lite_modules/anyAdBlock

scripts_dir="/data/adb/aab/scripts"

(
	until [ $(getprop sys.boot_completed) -eq 1 ]; do
		sleep 3
	done
	${scripts_dir}/start.sh
) &

inotifyd ${scripts_dir}/aab.inotify ${module_dir} >/dev/null 2>&1 &
