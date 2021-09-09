
resource "aws_lambda_function" "lambda_functions" {
  filename         = var.zip_file
  source_code_hash = filebase64sha256(var.zip_file)

  count            = length(var.functions)
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  handler          = "lambda.${var.functions[count.index].name}"
  runtime          = "${var.functions[count.index].runtime}"
  function_name    = "${var.functions[count.index].name}"

  timeout          = 15
}


