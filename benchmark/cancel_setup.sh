#!/usr/bin/env bash

DEPLOY_NAME=$(jq '.auth.user' settings.json | sed 's/\"//g')
DEPLOY_FILE=$(jq '.server.dir' settings.json | sed 's/\"//g')
DEPLOY_IPS_FILE=$(jq '.server.ips_file' settings.json | sed 's/\"//g')

update(){
    for line in $(cat $DEPLOY_IPS_FILE)
    do
       ssh $DEPLOY_NAME@$line "tc qdisc del dev eth0 root"&
    done
    wait
}

# update config.json to replicas
update
