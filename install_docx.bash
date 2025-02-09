{
	# docx maker
	pkg install python-lxml
	pip install python-docx
}
	

{
	pkg install proot-distro
	pd install debian
}

rootfs_init=$(cat << "EOF"
		apt update
		apt install libreoffice-writer-nogui libreoffice-java-common
EOF
)

proot_cmd()
{
	pd login debian --env cmd="$@" -- bash -c '$cmd'
}

{
	# inside debian
	# docx to pdf
	proot_cmd "$rootfs_init"
}
