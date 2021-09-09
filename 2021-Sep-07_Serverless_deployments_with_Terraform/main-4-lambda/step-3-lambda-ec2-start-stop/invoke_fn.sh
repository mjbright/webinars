
#FN=test_lambda_fn
#REGION="--region us-east-1"
#PAYLOAD='{"key1":"value1", "key2":"value2", "key3":"value3"}'
#PAYLOAD='{"Request-TimeDate":"'$(date +%Y-%B-%d_%Hh%Mm%Ss)'"}'
#PAYLOAD='{"key1":"value1-'$(date +%Y-%B-%d_%Hh%Mm%Ss)'", "key2":"value2", "key3":"value3"}'
PAYLOAD='{}'


FN=ec2_describe_all
I1="i-0c3ff3116d7c8ce5e"
I2="i-0e142505b1f75245e"

if [ ! -z "$1" ]; then
    case "$1" in
        stop1)  FN=ec2_stop; PAYLOAD='{"id":"'$I1'"}';;
        start1) FN=ec2_start; PAYLOAD='{"id":"'$I1'"}';;

        stop2)  FN=ec2_stop; PAYLOAD='{"id":"'$I2'"}';;
        start2) FN=ec2_start; PAYLOAD='{"id":"'$I2'"}';;
            
        start) FN=ec2_start; shift
               [ ! -z "$1" ] &&  PAYLOAD='{"id":"'$1'"}'
               ;;
        stop) FN=ec2_stop; shift
               [ ! -z "$1" ] &&  PAYLOAD='{"id":"'$1'"}'
               ;;
    esac
fi

set -x
aws lambda invoke --invocation-type RequestResponse --function-name $FN $REGION --log-type Tail \
    --payload "$PAYLOAD" outputfile.txt |& jq -r '.LogResult' | base64 -d
set +x

echo
echo "---- cat outputfile.txt:"
cat outputfile.txt
echo

if [ "$FN" = "ec2_describe_all" ]; then
    running_PUB_IP=$( jq -r '.[0].instances[] | select (.state == "running") | .pub_ip ' outputfile.txt | head -1 )
    [ ! -z "$running_PUB_IP" ] && {
        LOGIN="ubuntu@$running_PUB_IP"
        KEY=../../main-3-ec2-start-stop/persist_key.pem
        [ -f $KEY ] && {
            set -x; ssh -i $KEY $LOGIN uptime; set +x
        }
    }
fi

