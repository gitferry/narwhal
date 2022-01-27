#!/usr/bin/env bash
DEPLOY_NAME=$(jq '.auth.user' settings.json | sed 's/\"//g')
DEPLOY_FILE=$(jq '.server.dir' settings.json | sed 's/\"//g')
DEPLOY_IPS_FILE=$(jq '.server.ips_file' settings.json | sed 's/\"//g')

distribute(){
    for line in $(cat $DEPLOY_IPS_FILE)
    do
      ssh $DEPLOY_NAME@$line "mkdir ~/$DEPLOY_FILE"&
    done
    wait
    echo "Uploading repo..."
    for line in $(cat $DEPLOY_IPS_FILE)
    do
      scp -r ~/narwhal $DEPLOY_NAME@$line:~/$DEPLOY_FILE&
    done
    wait
    echo "Upload success!"
}

# distribute files
distribute
