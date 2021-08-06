#!/bin/bash

STATE_FILE=terraform.tfstate

# Functions: : ------------------------------------------------------------

CHECK_STATE_FILE() {
    STATE_FILE_SIZE=$(wc -c < $STATE_FILE)
    [ $STATE_FILE_SIZE -lt 160 ] && {
        ls -al $STATE_FILE
        echo
        echo "die: Error: looks like '$STATE_FILE' is empty" >&2
        exit 1
    }
}

SET_STATE_FILE() {
    STATE_FILE=terraform.tfstate
    [ ! -z "$1" ] && STATE_FILE=$1
    CHECK_STATE_FILE
}

DUMP_TF_INSTANCES() {
    # Dump all instance (types) in terraform state file:
    jq '.resources[].instances[]' $STATE_FILE
}

SHOW_TF_INSTANCE_SUMMARY() {
    # Show summary information for all instance (types) in terraform state file:
    jq -c '.resources[].instances[].attributes | { id, instance_state, public_ip, public_dns }' $STATE_FILE
}

SHOW_TF_AWS_INSTANCE_SUMMARY() {
    # Show summary information for only AWS EC2 (VM) instances in terraform state file:
    jq -c '.resources[] | select(.type == "aws_instance") | .instances[].attributes | { id, instance_state, public_ip, public_dns }' $STATE_FILE
}

DUMP_AWS_EC2_INSTANCES() {
    aws ec2 describe-instances | jq '.'
}

SHOW_AWS_EC2_INSTANCE_SUMMARY() {
    aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | { State, InstanceId }'
   #aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | { State.Name, InstanceId }'
}

# Main: ------------------------------------------------------------

DUMP_TF_INSTANCES=0
SHOW_TF_INSTANCE_SUMMARY=0
SHOW_TF_AWS_INSTANCE_SUMMARY=0
DUMP_AWS_EC2_INSTANCES=0
SHOW_AWS_EC2_INSTANCE_SUMMARY=0

while [ ! -z "$1" ]; do
    case $1 in
       -x) set -x;;

        terraform*) SET_STATE_FILE $1;;

        # DEFAULT ACTION:
       -i)  SHOW_TF_AWS_INSTANCE_SUMMARY=1;;

       -I)  DUMP_TF_INSTANCES=1;;
       -ai) SHOW_TF_INSTANCE_SUMMARY=1;;

       -aws)  DUMP_AWS_EC2_INSTANCES=1;;
       -awsi) SHOW_AWS_EC2_INSTANCE_SUMMARY=1;;

       *) echo "Bad option '$1'";;
    esac
    shift
done

# DEFAULT ACTION:
[ $DUMP_TF_INSTANCES -eq 0 ] &&
    [ $SHOW_TF_INSTANCE_SUMMARY -eq 0 ] &&
    [ $SHOW_TF_AWS_INSTANCE_SUMMARY -eq 0 ] &&
    [ $DUMP_AWS_EC2_INSTANCES -eq 0 ] &&
    [ $SHOW_AWS_EC2_INSTANCE_SUMMARY -eq 0 ] &&
    SHOW_TF_INSTANCE_SUMMARY=1

# If using state file check it's size:
[ $DUMP_TF_INSTANCES -ne 0 ] ||
    [ $SHOW_TF_INSTANCE_SUMMARY -ne 0 ] ||
    [ $SHOW_TF_AWS_INSTANCE_SUMMARY -ne 0 ] &&
    CHECK_STATE_FILE

[ $DUMP_TF_INSTANCES -ne 0 ] && DUMP_TF_INSTANCES
[ $SHOW_TF_INSTANCE_SUMMARY -ne 0 ] && SHOW_TF_INSTANCE_SUMMARY
[ $SHOW_TF_AWS_INSTANCE_SUMMARY -ne 0 ] && SHOW_TF_AWS_INSTANCE_SUMMARY
[ $DUMP_AWS_EC2_INSTANCES -ne 0 ] && DUMP_AWS_EC2_INSTANCES
[ $SHOW_AWS_EC2_INSTANCE_SUMMARY -ne 0 ] && SHOW_AWS_EC2_INSTANCE_SUMMARY

exit $?

