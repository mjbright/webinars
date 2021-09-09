
# Defines a name for the api gateway resource
# sets protocol to http

resource "aws_apigatewayv2_api" "lambda" {
  name          = "test_lambda_gw"
  protocol_type = "HTTP"
}

# Set up a single application stage for testing
# enable logging

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "test_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }

  # damage limitation: limit the number of requests/sec:
  default_route_settings {
    throttling_burst_limit = 50
    throttling_rate_limit  = 100
  }
}

# Configure API Gateways for our lambda functions

resource "aws_apigatewayv2_integration" "func_gws" {
  api_id = aws_apigatewayv2_api.lambda.id
  count  = length(var.functions)

  integration_uri    = aws_lambda_function.lambda_functions[count.index].invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# Configure API Gateway routes to our lambda functions

resource "aws_apigatewayv2_route" "func_routes" {
  api_id = aws_apigatewayv2_api.lambda.id
  count  = length(var.functions)

  route_key = "GET /${var.functions[count.index].name}"
  target    = "integrations/${aws_apigatewayv2_integration.func_gws[count.index].id}"
}

# Define a log group for the stage

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"
  retention_in_days = 1
}

# Allow the Gateway to call the functions

resource "aws_lambda_permission" "api_gw_fns" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  count         = length(var.functions)

  function_name = aws_lambda_function.lambda_functions[count.index].function_name
  principal     = "apigateway.amazonaws.com"

  # SAFER: source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*/${aws_lambda_function.lambda_functions[count.index].function_name}"
  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*/*"
}

