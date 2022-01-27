#!/usr/bin/env bash
DEPLOY_NAME=$(jq '.auth.user' settings.json | sed 's/\"//g')
DEPLOY_FILE=$(jq '.server.dir' settings.json | sed 's/\"//g')
DEPLOY_IPS_FILE=$(jq '.server.ips_file' settings.json | sed 's/\"//g')

distribute(){
    echo "Uploading binaries..."
    for line in $(cat $DEPLOY_IPS_FILE)
    do
    {
      scp benchmark_client node $DEPLOY_NAME@$line:~/; chmod 777 benchmark_client; chmod 777 node
    }&
    done
    wait
    echo "Upload success!"
}

# distribute files
distribute
