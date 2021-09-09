
IDS=$(jq '.resources[] |  select(.type == "aws_instance") | .instances[].attributes.id' terraform.tfstate | sed 's/"//g')

if [ "$1" = "start" ]; then
    set -x; aws ec2 start-instances --instance-ids $IDS; set +x
    terraform output > output.after.start.txt
else
    terraform output > output.before.stop.txt
    set -x; aws ec2 stop-instances --instance-ids $IDS; set +x
fi


