#!/bin/bash

RUN() {
    echo; echo "-- $*"
    echo "Press <enter>"
    read DUMMY
    [ "$DUMMY" = "q" ] && exit 0
    [ "$DUMMY" = "Q" ] && exit 0
    eval $*
}

echo "-- aws s3 ls"
aws s3 ls | grep ' mjbright-demo-'

BUCKET=$( aws s3 ls | awk '/ mjbright-demo-/ { print $3; }' )

echo "==== View SQS queue:"
RUN aws sqs list-queues # --region=us-west-1
SQS_QUEUE=$( aws sqs list-queues | jq -r '.QueueUrls[0]' )

echo "==== View SQS queue '$SQS_QUEUE' messages:"
RUN "aws sqs receive-message --queue-url $SQS_QUEUE | jq '.'"

echo "==== Bucket summary:"
RUN aws s3 ls --summarize s3://$BUCKET

RUN  aws s3 cp variables.tf s3://$BUCKET

echo "==== Bucket summary:"
RUN aws s3 ls --summarize s3://$BUCKET

echo "==== View SQS queue '$SQS_QUEUE' messages:"
sleep 3
RUN "aws sqs receive-message --queue-url $SQS_QUEUE | jq '.'"

