
update_resolv_conf()
 {
	local rootfs=$1
 	pkg install traceroute
	cat <<- "EOF" > $rootfs/etc/resolv.conf
		nameserver 8.8.8.8
		nameserver 8.8.4.4
EOF
 	traceroute -n google.com | awk '$2 ~ /([0-9]{1,3}\.?){4}$/ {print $2}' | sed 's/^\s*/nameserver /' >> $rootfs/etc/resolv.conf
}

update_source_list()
{
	local rootfs=$1
	cat <<- "EOF" > $rootfs/etc/apt/sources.list
		# https://wiki.debian.org/SourcesList#Example_sources.list
		deb https://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
		deb-src https://deb.debian.org/debian bookworm main contrib non-free non-free-firmware

		deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
		deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

		deb https://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
		deb-src https://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF
}

