#!/bin/bash

get_available_port()
{
	host=$1
	# scan for non-root ports
	for port in $(seq 1024 49151); do
	    if ! (echo > /dev/tcp/$host/$port) 2>/dev/null; then
		echo "$port"
		break
	    fi
	done
}

proot_cmd()
{
	local cmd_file=$1
#	local cmd_temp_file=$(mktemp)
#	cat $1 > $cmd_temp_file # accepts file
	pd login $distro -- bash --noprofile --norc -c "source $cmd_file"
#	rm $cmd_temp_file
}

proot_job()
{
	proot_cmd "$@" &
}

pgrep_alive()
{
	pids=$(ps -eo %cpu,pid,comm --sort=-%cpu --no-headers | grep $1 | awk '$1 > 0 {print $2}')
	[[ $pids ]] || return 1
	echo "$pids"
}

HOST=127.0.0.1
PORT=$(get_available_port $HOST)
[[ $1 ]] && PORT=$1

distro=debian
rootfs_dir=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs

bashrc_file=$rootfs_dir/$distro/root/.bashrc

# persistent variables for unoserver
env_dir=$rootfs_dir/$distro/root/unoserver
mkdir -p $env_dir
# declares env vars
env_vars="pid log port host cmd"
source <(echo -n $env_vars | xargs -d ' ' -I {} -n 1 echo {}_file=$env_dir/{})


__unoserver()
{

	{
		# kill existing unoservers
		pgrep_alive soffice.bin | xargs --no-run-if-empty kill -15
		# reset variables
		find $env_dir/* -maxdepth 0 | xargs -n 1 truncate -s 0
		echo -n $PORT > $port_file
		echo -n $HOST > $host_file
	}
	{
		cat << EOF > $cmd_file
			tail -f $log_file &
			SAL_USE_VCL_PLUGIN=gen \$(which unoserver) \
				--libreoffice-pid-file $pid_file \
				--interface=$HOST \
				--port=$PORT \
				< /dev/null >> $log_file 2>&1
EOF
		#daemonize $(which pd) login $distro -- source $cmd_file
		pd login $distro -- bash --noprofile --norc -c "source $cmd_file"
		#proot_cmd "$cmd_file"
	}
	{
		# wait until libreoffice is ready to be used
		while [[ ! -s $pid_file ]]; do continue; done
	}
}

__unoserver "$@"










#must_force_restart=false
#must_start=false

#__unoconvert()
#{
#	address=$(env_get host):$(env_get port)
#	echo $address
#	if pgrep_alive soffice.bin > /dev/null; then
#		echo unoserver is running
#		if curl -sI http://$address > /dev/null; then
#			echo unoserver is unreachable
#			must_start=true
#		fi
#	else
#		echo unoserver not found
#		must_start=true
#	fi
#
#
#	__unoserver "$@"
#	address=$(env_get host):$(env_get port)
#	echo $address
#}
#
#__unoconvert "$@"
