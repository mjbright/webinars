
set -x

 aws apigatewayv2 get-apis

 API_NAME="test_lambda_gw"

 API_ID=$( aws apigatewayv2 get-apis | jq -r '.Items[] | select (.Name == "'$API_NAME'") | .ApiId ' )

 aws apigatewayv2 get-stages --api-id $API_ID

 aws apigatewayv2 get-routes --api-id $API_ID | jq -c '.Items[]'

 #curl https://ecofzmjo95.execute-api.us-west-1.amazonaws.com/test_lambda_stage/ec2_describe_all
 #url https://ecofzmjo95.execute-api.us-west-1.amazonaws.com/test_lambda_stage/ec2_stop
