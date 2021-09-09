
resource "aws_lambda_function" "lambda_function" {
  filename      = var.zip_file
  #filename      = "lambda.zip"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  function_name    = "${var.function_name}"
  #source_code_hash = "${filebase64sha256("lambda.zip")}"
  source_code_hash = filebase64sha256(var.zip_file)
}

resource "aws_lambda_function" "lambda_function2" {
  filename      = var.zip_file
  #filename      = "lambda.zip"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  handler          = "${var.handler2}"
  runtime          = "${var.runtime2}"
  function_name    = "${var.function_name2}"
  #source_code_hash = "${filebase64sha256("lambda.zip")}"
  source_code_hash = filebase64sha256(var.zip_file)
}


