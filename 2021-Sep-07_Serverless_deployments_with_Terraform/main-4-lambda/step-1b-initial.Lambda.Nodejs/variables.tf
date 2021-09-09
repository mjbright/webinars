
variable "region" {
  default = "us-west-1"
}

# RUNTIMES: nodejs nodejs4.3 nodejs6.10 nodejs8.10 nodejs10.x nodejs12.x nodejs14.x java8 java8.al2 java11 python2.7 python3.6 python3.7 python3.8 dotnetcore1.0 dotnetcore2.0 dotnetcore2.1 dotnetcore3.1 nodejs4.3-edge go1.x ruby2.5 ruby2.7 provided provided.al2


variable "function_name" {
  description = "name AWS Lambda will assign to this function"
  default = "step2_lambda_fn_node"
}

variable "handler" {
  description = "Our local function"
  default = "index.lambda_handler"
}

variable "runtime" {
  description = "What AWS Lambda runtime to use"
  default = "nodejs14.x"
}

variable "function_name2" {
  description = "name AWS Lambda will assign to this function"
  default = "step2_lambda_fn_node2"
}

variable "handler2" {
  description = "Our local function"
  default = "index.lambda_handler2"
}

variable "runtime2" {
  description = "What AWS Lambda runtime to use"
  default = "nodejs12.x"
}

variable "zip_file" {
  default = "lambda.zip"
}

