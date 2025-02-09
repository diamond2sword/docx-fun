#!/bin/bash

# update_resolve_conf()
# {
# 	# edit our resolve conf
# 	rootfs_dir=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs
# 	pkg install traceroute
# 	traceroute -n4 google.com | awk '$2 ~ /([0-9]{1,3}\.?){4}$/ {print $2}' | sed 's/^\s*/nameserver /' > $1 
# }

distro=debian

proot_cmd()
{
	cmd_temp_file=$(mktemp)
	cat $1 > $cmd_temp_file # accepts file
	pd login $distro -- source $cmd_temp_file
	rm $cmd_temp_file
}

{
	# docx maker
	pkg install python-lxml
	pip install python-docx
}

	
{
	pkg install proot-distro
	pd install $distro 
	proot_cmd <(cat << "EOF"
		apt update
		apt install libreoffice-writer-nogui libreoffice-java-common
EOF
	)
}
