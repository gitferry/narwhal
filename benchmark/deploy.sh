#!/usr/bin/env bash
DEPLOY_NAME=$(jq '.auth.user' settings.json | sed 's/\"//g')
DEPLOY_FILE=$(jq '.server.dir' settings.json | sed 's/\"//g')
DEPLOY_IPS_FILE=$(jq '.server.ips_file' settings.json | sed 's/\"//g')

distribute(){
    echo "Uploading binaries..."
    for line in $(cat $DEPLOY_IPS_FILE)
    do
    {
	    scp ../target/release/benchmark_client ../target/release/node install.sh $DEPLOY_NAME@$line:~/
    }&
    done
    wait
    echo "Upload success!"
    echo "Installing..."
    for line in $(cat $DEPLOY_IPS_FILE)
    do
    {
	    ssh $DEPLOY_NAME@$line "chmod 777 install.sh; ./install.sh"
    }&
    done
    wait
    echo "Install success!"
}

# distribute files
distribute
