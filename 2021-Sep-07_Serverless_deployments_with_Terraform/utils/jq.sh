#!/bin/bash

STATE_FILE=terraform.tfstate

# Functions: : ------------------------------------------------------------

die() {
    echo "die: $*" >&2; exit 1;
}

CHECK_STATE_FILE() {
    [ ! -f $STATE_FILE ] && {
        echo; die "Error: no such state file '$STATE_FILE'"
    }
    STATE_FILE_SIZE=$(wc -c < $STATE_FILE)
    [ $STATE_FILE_SIZE -lt 160 ] && {
        ls -al $STATE_FILE
        echo; die "Error: looks like '$STATE_FILE' is empty"
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

# EC2:
DUMP_AWS_EC2_INSTANCES() {
    aws ec2 describe-instances | jq '.'
}

SHOW_AWS_EC2_INSTANCE_SUMMARY() {
    aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | { State, InstanceId, Tags }'
   #aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | { State.Name, InstanceId }'
}

# Route53:
SHOW_AWS_R53_ZONES() {
    aws route53 list-hosted-zones | jq -c '.HostedZones[] | { Id, Name, Config }'
}

SHOW_AWS_R53_RECORDS() {
    aws route53 list-resource-record-sets  --hosted-zone-id $AWS_MYZONE | jq -c '.ResourceRecordSets[] | { Name, Type, ResourceRecords }'
}

SHOW_AWS_ELASTICIPS() {
    aws ec2 describe-addresses | jq -c '.Addresses[] | { InstanceId, PublicIp, PrivateIpAddress }'
}

SHOW_AWS_IAM_GROUPS() {
    aws iam list-groups | jq -c '.Groups[] | { GroupName, GroupId, CreateDate }'
}

SHOW_AWS_IAM_USERS() {
    aws iam list-users | jq -c '.Users[] | { UserName, UserId, CreateDate }'
}

SHOW_AWS_IAM_ROLES() {
    aws iam list-roles | jq -c '.Roles[] | { RoleName, RoleId, CreateDate }'
}


SHOW_CLOUDFRONT_DISTRIBS() {
  aws cloudfront list-distributions |
    jq -c '.DistributionList.Items[] | { Id,origins:.Origins.Items[].Id,origindomain:.Origins.Items[].DomainName,aliases:.Aliases.Items[] }'
}


# Main: ------------------------------------------------------------

SHOW_AWS_CLOUDFRONT=0

SHOW_AWS_R53_ZONES=0
SHOW_AWS_R53_RECORDS=0
SHOW_AWS_ELASTICIPS=0

DUMP_TF_INSTANCES=0
SHOW_TF_INSTANCE_SUMMARY=0
SHOW_TF_AWS_INSTANCE_SUMMARY=0
DUMP_AWS_EC2_INSTANCES=0
SHOW_AWS_EC2_INSTANCE_SUMMARY=0

SHOW_AWS_IAM_GROUPS=0
SHOW_AWS_IAM_USERS=0
SHOW_AWS_IAM_ROLES=0

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

       -awsz) SHOW_AWS_R53_ZONES=1;;
       -awsr) SHOW_AWS_R53_RECORDS=1;;
       -awsr53) SHOW_AWS_R53_RECORDS=1;;
       -awseip) SHOW_AWS_ELASTICIPS=1;;

       -awscf|cf) SHOW_AWS_CLOUDFRONT=1;;

       -aws-iam|-awsiam|-iam)
           SHOW_AWS_IAM_GROUPS=1
           SHOW_AWS_IAM_USERS=1
           SHOW_AWS_IAM_ROLES=1
           ;;

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
    [ $SHOW_AWS_R53_ZONES   -eq 0 ] &&
    [ $SHOW_AWS_R53_RECORDS -eq 0 ] && 
    [ $SHOW_AWS_ELASTICIPS  -eq 0 ] &&
    [ $SHOW_AWS_IAM_GROUPS -eq 0 ] &&
    [ $SHOW_AWS_IAM_USERS -eq 0 ] &&
    [ $SHOW_AWS_IAM_ROLES -eq 0 ] &&
    [ $SHOW_AWS_CLOUDFRONT -eq 0 ] &&
    SHOW_TF_INSTANCE_SUMMARY=1

# If using state file check it's size:
[ $DUMP_TF_INSTANCES -ne 0 ] ||
    [ $SHOW_TF_INSTANCE_SUMMARY -ne 0 ] ||
    [ $SHOW_TF_AWS_INSTANCE_SUMMARY -ne 0 ] &&
    CHECK_STATE_FILE

[ $DUMP_TF_INSTANCES            -ne 0 ] && DUMP_TF_INSTANCES
[ $SHOW_TF_INSTANCE_SUMMARY     -ne 0 ] && SHOW_TF_INSTANCE_SUMMARY
[ $SHOW_TF_AWS_INSTANCE_SUMMARY -ne 0 ] && SHOW_TF_AWS_INSTANCE_SUMMARY

[ $DUMP_AWS_EC2_INSTANCES        -ne 0 ] && DUMP_AWS_EC2_INSTANCES
[ $SHOW_AWS_EC2_INSTANCE_SUMMARY -ne 0 ] && SHOW_AWS_EC2_INSTANCE_SUMMARY

[ $SHOW_AWS_R53_ZONES   -ne 0 ] && SHOW_AWS_R53_ZONES
[ $SHOW_AWS_R53_RECORDS -ne 0 ] && SHOW_AWS_R53_RECORDS

[ $SHOW_AWS_ELASTICIPS  -ne 0 ] && SHOW_AWS_ELASTICIPS

[ $SHOW_AWS_IAM_GROUPS -ne 0 ] && SHOW_AWS_IAM_GROUPS
[ $SHOW_AWS_IAM_USERS  -ne 0 ] && SHOW_AWS_IAM_USERS
[ $SHOW_AWS_IAM_ROLES  -ne 0 ] && SHOW_AWS_IAM_ROLES

[ $SHOW_AWS_CLOUDFRONT -ne 0 ] && SHOW_CLOUDFRONT_DISTRIBS

exit $?

