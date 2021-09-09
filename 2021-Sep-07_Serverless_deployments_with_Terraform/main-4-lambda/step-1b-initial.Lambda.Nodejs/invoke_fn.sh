
FN=step2_lambda_fn_node
if [ "$1" = "2" ]; then
    FN=step2_lambda_fn_node2
fi
#REGION="--region us-east-1"

PAYLOAD='{"key1":"value1", "key2":"value2", "key3":"value3"}'
PAYLOAD='{"key1":"value1-'$(date +%Y-%B-%d_%Hh%Mm%Ss)'", "key2":"value2", "key3":"value3"}'
PAYLOAD='{"Request-TimeDate":"'$(date +%Y-%B-%d_%Hh%Mm%Ss)'"}'

set -x
aws lambda invoke --invocation-type RequestResponse --function-name $FN $REGION --log-type Tail \
    --payload "$PAYLOAD" outputfile.txt | jq -r '.LogResult' | base64 -d
set +x

echo
echo "cat outputfile.txt:"
cat outputfile.txt
echo

