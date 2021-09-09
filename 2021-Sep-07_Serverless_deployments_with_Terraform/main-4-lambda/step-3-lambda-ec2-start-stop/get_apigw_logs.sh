#!/bin/bash

LOG_GROUP_NAME="/aws/lambda/ec2_describe_all"

if [ "$1" = "stop" ]; then
    LOG_GROUP_NAME="/aws/lambda/ec2_stop"
fi
if [ "$1" = "start" ]; then
    LOG_GROUP_NAME="/aws/lambda/ec2_start"
fi

LATEST_STREAM=$( aws logs describe-log-streams --descending --order-by LastEventTime --log-group-name "$LOG_GROUP_NAME" | jq -r -c '.logStreams[0] | .logStreamName' )

echo "Latest stream for $LOG_GROUP_NAME:" $LATEST_STREAM

#aws logs get-log-group-fields --log-group-name $LOG_GROUP_NAME
#aws logs get-log-events --log-group-name my-log-group --log-stream-name my-log-stream | grep '"message":' | awk -F '"' '{ print $(NF-1) }'

set -x
aws logs get-log-events --log-group-name $LOG_GROUP_NAME --log-stream-name $LATEST_STREAM | grep '"message":' | awk -F '"' '{ print $(NF-1) }'
exit 0


