
variable "region" {
  default = "us-west-1"
}

variable "zip_file" {
  default = "lambda.zip"
}

## Function1 -----------------------------------------------------

variable "function_name" {
  description = "name AWS Lambda will assign to this function"
  default = "step1_lambda_fn"
}

variable "handler" {
  description = "Our local function"
  default = "lambda.lambda_handler"
}

variable "runtime" {
  description = "What AWS Lambda runtime to use"
  default = "python3.8"
}

## Function2 -----------------------------------------------------

variable "function_name2" {
  description = "name AWS Lambda will assign to this function"
  default = "step1_lambda_fn2"
}

variable "handler2" {
  description = "Our local function"
  default = "lambda.lambda_handler2"
}

variable "runtime2" {
  description = "What AWS Lambda runtime to use"
  default = "python3.6"
}


