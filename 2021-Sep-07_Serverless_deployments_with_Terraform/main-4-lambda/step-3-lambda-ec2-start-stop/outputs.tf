
output "function_names" {
  description = "Lambda function names"

  value =  [
    aws_lambda_function.lambda_functions.*.function_name
  ]
}

locals {
    function_url = aws_apigatewayv2_stage.lambda.invoke_url
    function_gw = split( "/", substr( local.function_url, 8, -1 ))[0]
    #aws_apigatewayv2_stage.lambda.invoke_url
}

output "function_url" {
  description = "Base URL for API Gateway stage/function names"

  value = local.function_url
}

output "function_gw" {
  value = local.function_gw
}

output "r53_url" {
  description = "to be done - setup cloudfront https frontend ..."
  # SHOULD BE:
  # value = "https://${aws_route53_record.test-record.name}/${aws_apigatewayv2_stage.lambda.name}"
  value = "https://${local.function_gw}/${aws_apigatewayv2_stage.lambda.name}"
}

#tbd:
# see: https://stackoverflow.com/questions/65840607/in-terraform-how-do-you-output-a-list-from-an-array-of-objects
#output "endpoints" {
  #count = length(functions)
  #value = "https://${local.function_gw}/${aws_apigatewayv2_stage.lambda.name}/${var.functions[count.index].name}/"
  #value = "https://${local.function_gw}/${aws_apigatewayv2_stage.lambda.name}/${values( var.functions )[*].name}/"
  #value = "https://${local.function_gw}/${aws_apigatewayv2_stage.lambda.name}/${values( var.functions[*] ).name}/"
#}
#output "website_endpoints" { value = values(aws_s3_bucket.map)[*].website_endpoint }



