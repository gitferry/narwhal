#!/usr/bin/env bash

DEPLOY_NAME=$(jq '.auth.user' settings.json | sed 's/\"//g')
DEPLOY_FILE=$(jq '.server.dir' settings.json | sed 's/\"//g')
DEPLOY_IPS_FILE=$(jq '.server.ips_file' settings.json | sed 's/\"//g')

rand(){
        echo $(( $RANDOM % 10 ))
}

update(){
    count=1
    for line in $(cat $DEPLOY_IPS_FILE)
    do
	    {
	    if [ ${count} -le 10 ]
		then
		bw=100
		else
		bw=100
	    fi
	    let count=$((count+1))
	    echo "setting ${bw}Mbps to ${line}"
	    ssh $DEPLOY_NAME@$line "tc qdisc add dev eth0 root handle 1:0 htb default 1; tc class add dev eth0 parent 1:0 classid 1:1 htb rate ${bw}mbit; tc qdisc add dev eth0 parent 1:1 handle 2:0 netem delay 100ms 10ms"
    }&
    done
    wait
}

# update config.json to replicas
update
