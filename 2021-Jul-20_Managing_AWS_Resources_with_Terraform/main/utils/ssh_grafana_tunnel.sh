#!/bin/bash

die() { echo "$0: die - $*" >&2; exit 1; }

SET_STATE_FILE() {
    STATE_FILE=terraform.tfstate
    [ ! -z "$1" ] && STATE_FILE=$1

    STATE_FILE_SIZE=$(wc -c < $STATE_FILE)
    [ $STATE_FILE_SIZE -lt 160 ] && {
        ls -al $STATE_FILE
        echo
        echo "die: Error: looks like '$STATE_FILE' is empty" >&2
        exit 1
    }
}

SET_STATE_FILE $*

PUBLIC_IP=$( grep '"public_ip"' $STATE_FILE  | sed -e 's/.* "//' -e 's/".*//' )

[ -z "$PUBLIC_IP" ] && die "Failed to determine public_ip"

echo "Create ssh tunnel for ports 3000[grafana] and 9000[prometheus]"
set -x
ssh -Nv -L 0.0.0.0:3000:localhost:3000 -L 0.0.0.0:9090:localhost:9090 -i my_aws_key.pem ubuntu@${PUBLIC_IP}

