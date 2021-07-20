#!/bin/bash

#STATE_FILE=terraform.tfstate
#[ "${1#terraform.tfstate}" != "$1" ] && { STATE_FILE=$1; shift; }

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

[ "$1" = "-x" ]                      && { set -x; shift; }

case "$1" in
  terraform*) SET_STATE_FILE $*;  shift;;
esac

case "$1" in
 
  -I) jq '.resources[].instances[]' $STATE_FILE;;
  -ai) # TODO: pass type through
    jq -c '.resources[].instances[].attributes | { id, instance_state, public_ip, public_dns }' $STATE_FILE
    ;;
  -i)
    jq -c '.resources[] | select(.type == "aws_instance") | .instances[].attributes | { id, instance_state, public_ip, public_dns }' $STATE_FILE
    ;;

  -aws) aws ec2 describe-instances | jq '.';;

  -ai)
    aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | { State, InstanceId }'
    #aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | { State.Name, InstanceId }'
    ;;

  "") jq '.resources[].instances[]' $STATE_FILE;;


  *) echo "Bad option '$1'";;


esac

exit $?

jq '.resources[]' $STATE_FILE
 2226  jq '.resources[].instances[].public_ip' $STATE_FILE
 2227  jq '.resources[].instances[].attributes.public_ip' $STATE_FILE
 2228  jq '.resources[].instances[].attributes.public_ip' $STATE_FILE
 2229  jq '.resources[].instances[].attributes | { public_ip }' $STATE_FILE
 2230  jq '.resources[].instances[].attributes | { public_ip, public_dns }' $STATE_FILE
 2232  #jq '.resources[].instances[].attributes' | { state, public_ip, public_dns }' $STATE_FILE
 2231  jq '.resources[].instances[].attributes | { state, public_ip, public_dns }' $STATE_FILE
