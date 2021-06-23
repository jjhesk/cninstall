#!/bin/bash


sudo apt-get install nfs-kernel-server -y
sudo apt-get install nfs-common upgrade -y
sudo apt install zfsutils-linux nvme-cli dstat sysstat glances smartmontools lm-sensors -y
sudo apt install htop mc xfsprogs mdadm -y
echo "alias plotmancfg='vi /home/ipant/.config/plotman/plotman.yaml'" >> ~/.bashrc

[ ! -d "/mnt/local/tmp" ] && mkdir -p /mnt/local/tmp
[ ! -d "/home/ipant/.config/plotman" ] && mkdir -p /home/ipant/.config/plotman/

REALGIT=/usr/bin/git

gitx(){
	local RETRIES=30
	local DELAY=10
	local COUNT=1
	while [ $COUNT -lt $RETRIES ]; do
	  $REALGIT $*
	  if [ $? -eq 0 ]; then
	    RETRIES=0
	    break
	  fi
	  let COUNT=$COUNT+1
	  sleep $DELAY
	done
}


cat <<"EOF" >/home/ipant/.config/plotman/plotman.yaml

user_interface:
        use_stty_size: True
directories:
        log: /home/ipant/.chia/mainnet
        tmp:
                - /mnt/local/tmp
        tmp_overrides:
                "/mnt/local/tmp":
                        tmpdir_max_jobs: 32
        dst:
                - /mnt/nfs/ipant101/chiaFinalData
                - /mnt/nfs/ipant102/chiaFinalData
        archive:
                #rsyncd_module: plots
                #rsyncd_path: /plots
                #rsyncd_bwlimit: 80000  # Bandwidth limit in KB/s
                #rsyncd_host: myfarmer
                #rsyncd_user: chia
                #   index: 0
scheduling:
        tmpdir_stagger_phase_major: 2
        tmpdir_stagger_phase_minor: 3
        tmpdir_stagger_phase_limit: 25
        tmpdir_max_jobs: 40
        global_max_jobs: 90
        global_stagger_m: 20
        polling_time_s: 30
plotting:
        k: 32
        e: True              # Use -e plotting option
        n_threads: 4         # Threads per job
        n_buckets: 128       # Number of buckets to split data into
        job_buffer: 17068     # Per job memory
        # If specified, pass through to the -f and -p options.  See CLI reference.
        farmer_pk: 861467df6768932f1c2f3a7c00a70f1e111b22b55de42c497fb93fd398eb4fd4b213f399e0930d265ffdc2b5655f96f5
        pool_pk: 8e211cb1118b95ac9da2f31fd159a74993bfcc8ab72bff79c880227185ba2b1f372b8e829bd99f5796eb4f68e41f30a9

apis:
        port: 19992
        api_polling_throttle_s: 5

EOF

[ ! -d "/home/ipant/chia-blockchain" ] && gitx clone https://github.com/Chia-Network/chia-blockchain.git -b latest

cat <<"EOF" >/home/ipant/chia-blockchain/plotmanc

#!/bin/bash
. /home/ipant/chia-blockchain/activate
pip3 install pip-versions
LATEST=$(pip-versions latest plotmanx)
NOWVER=$(pip freeze | grep plotmanx | sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,4\}[0-9][^.]\).*/\1/p')


if [ "$LATEST" != "$NOWVER" ]; then
    python3 -m pip uninstall plotman -y
    python3 -m pip uninstall plotmanx -y
    python3 -m pip install plotmanx==$LATEST
    plotman version
fi

sleep 3

echo "done operation in plotman updates"

ps aux | grep -i 'plotman plot' | awk '{print $2}'

COUNTPS=$(ps aux | grep -i 'plotman plot' | wc -l)

if [ $COUNTPS -eq 1 ]; then
    nohup plotman plot >> plotman.log &
    echo "no process on plotman and start a new one"
fi


EOF

echo "now setup and check for the mounted devices"
mountdiskIpant1(){
	declare -a arr_disk=(101 102 103 104 105 106 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130)

	sudo chmod -R 777 /mnt/nfs/
	sudo chown -R ipant:ipant /mnt/nfs/
	for i in "${arr_disk[@]}"
	do
	   :
	   # do whatever on $i
	   local pathx=/mnt/nfs/ipant$i
	   local chifinal=/mnt/nfs/ipant$i/chiaFinalData
	   sudo mkdir -p $pathx
	   sudo umount -l $pathx
	   if [ $i -eq 103 ]; then
	   	echo "mount drive 192.168.10.53"
	   	sudo mount -t nfs 192.168.10.53:/minerdata $pathx -o nolock
	   else
	   	echo "mount drive 192.168.10.$i"
	   	sudo mount -t nfs 192.168.10.$i:/minerdata $pathx -o nolock
	   fi
	   [ ! -d "$chifinal" ] && mkdir -p $chifinal
	   sudo chmod -R 777 $pathx
	done
}

mountdiskIpant2(){
	declare -a arr_disk=(236 237 238 239 240 241 242 243)

	sudo chmod -R 777 /mnt/nfs/
	sudo chown -R ipant:ipant /mnt/nfs/
	for i in "${arr_disk[@]}"
	do
	   :
	   # do whatever on $i
	   local pathx=/mnt/nfs/storage$i
	   local chifinal=/mnt/nfs/storage$i/chiaFinalData
	   sudo mkdir -p $pathx
	   sudo umount -l $pathx
	   
	   echo "mount drive 192.168.10.$i"
	   sudo mount -t nfs 192.168.10.$i:/minerdata $pathx -o nolock
	   
	   [ ! -d "$chifinal" ] && mkdir -p $chifinal

	   sudo chmod -R 777 $pathx
	done
}

chiainit(){
	if [ -d "/home/ipant/chia-blockchain" ]; then
		cd /home/ipant/chia-blockchain
		gitx submodule update --init mozilla-ca
		sh install.sh
		. /home/ipant/chia-blockchain/activate
		chia init
		sh plotmanc
	else
		echo "-----------"
		echo "sorry you have not install chia succesfully. there is an error please restart the process."
	fi
}

#mountdiskIpant1
#mountdiskIpant2
chiainit

