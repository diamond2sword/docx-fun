#!/bin/bash


distro=debian
rootfs_dir=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs

proot_cmd_bashrc()
{
	local rootfs=$1
	local cmd_file=$2
	local bashrc_file=$rootfs/root/.bashrc
	local bashrc_temp=$(mktemp)
	{
		mkdir -p $(dirname $bashrc_file)
		cat $bashrc_file > $bashrc_temp
		cat $cmd_file > $bashrc_file
		echo -en "\nexit" >> $bashrc_file
	}
	{
		pd login $distro
	}
	{
		cat $bashrc_temp > $bashrc_file
		rm $bashrc_temp
	}
}

proot_cmd()
{
	local cmd_temp_file=$(mktemp)
	cat $1 > $cmd_temp_file # accepts file
	pd login $distro -- source $cmd_temp_file
	rm $cmd_temp_file
}

{
	# misc
	pkg install neovim termux-api 
}

{
	# repo
	pkg install gh git expect
	git clone https://github.com/diamond2sword/docx-fun
}

{
	# pdf converter server side
	pkg install proot-distro 
	pd install $distro
	proot_cmd_bashrc "$rootfs_dir/$distro" <(cat << "EOF"
		apt update
		apt install python3-pip python3-uno libreoffice-writer-nogui
		$(which pip) install unoserver --break-system-packages
EOF
	)
}

{
	# docx maker
	pkg install python-lxml openssl
	pip install python-docx

	# pdf converter client side
	pip install unoserver
}

termux-toast "INSTALL DONE"
