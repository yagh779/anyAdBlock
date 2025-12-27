#!/system/bin/sh

# Powered by Apad.pro
# https://apad.pro/easymosdns
# 仅建议按照注释更改参数

export PATH="/data/adb/magisk:/data/adb/ksu/bin:/data/adb/ap/bin:$PATH:/data/data/com.termux/files/usr/bin"

scripts=$(realpath $0)
scripts_dir=$(dirname ${scripts})

source ${scripts_dir}/aab.config

log() {
	export TZ=Asia/Shanghai
	now=$(date +"[%Y-%m-%d %H:%M:%S %Z]")
	case $1 in
	Info)
		[ -t 1 ] && echo -e "\033[1;32m${now} [Info]: $2\033[0m" || echo "${now} [Info]: $2"
		;;
	Warn)
		[ -t 1 ] && echo -e "\033[1;33m${now} [Warn]: $2\033[0m" || echo "${now} [Warn]: $2"
		;;
	Error)
		[ -t 1 ] && echo -e "\033[1;31m${now} [Error]: $2\033[0m" || echo "${now} [Error]: $2"
		;;
	*)
		[ -t 1 ] && echo -e "\033[1;30m${now} [$1]: $2\033[0m" || echo "${now} [$1]: $2"
		;;
	esac
}

mosdns_tmp_dir="${aab_path}/mosdns/tmp"
# 下面一行用于定义你的规则位置，可以按需更改
mosdns_working_dir="${aab_path}/mosdns/rules"

mkdir -p ${mosdns_tmp_dir}
mkdir -p ${mosdns_working_dir}

# up_url() 格式为：需更新的url:下载的url文件重命名的名字
# url:rename，按需更改自己的 url:rename
up_url=(
	https://fastly.jsdelivr.net/gh/pmkol/easymosdns@rules/china_domain_list.txt:china_domain_list.txt
	https://fastly.jsdelivr.net/gh/pmkol/easymosdns@rules/gfw_domain_list.txt:gfw_domain_list.txt
	https://fastly.jsdelivr.net/gh/pmkol/easymosdns@rules/cdn_domain_list.txt:cdn_domain_list.txt
	https://fastly.jsdelivr.net/gh/pmkol/easymosdns@rules/china_ip_list.txt:china_ip_list.txt.txt
	https://fastly.jsdelivr.net/gh/pmkol/easymosdns@rules/gfw_ip_list.txt:gfw_ip_list.txt
	https://fastly.jsdelivr.net/gh/pmkol/easymosdns@rules/ad_domain_list.txt:ad_domain_list.txt
)

up_server() {
	for item in "${up_url[@]}"; do
		url="${item%:*}"
		file="${item##*:}"
		if curl -L ${url} >${mosdns_tmp_dir}/${file}; then
			log Info "Update ${url} >${mosdns_tmp_dir}/${file} successful"
		else
			log Error "Update ${url} >${mosdns_tmp_dir}/${file} faild"
			return 2
		fi
	done
}

if up_server; then
	log Info "Update rules successful"
	cp -rf ${mosdns_tmp_dir}/*.txt ${mosdns_working_dir}/
else
	log Error "Update rules faild"
fi
rm -rf ${mosdns_tmp_dir}
