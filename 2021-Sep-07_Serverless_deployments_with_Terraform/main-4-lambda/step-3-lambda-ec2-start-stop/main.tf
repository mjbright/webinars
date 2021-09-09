
resource "aws_iam_role" "lambda_exec_role" {
  name        = "lambda_exec_ec2_stop_start"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2-start-stop-list-policy" {
  name        = "ec2-start-stop-list-policy"
  description = "A ec2-start-stop-list policy"

  policy = templatefile("ec2-start-stop-policy.json", { tag_key = "env", tag_value = "start-stop" })
}


# Add a policy to the above role to allow to call out to AWS EC2
# This will allow to start/stop/describe VMs
resource "aws_iam_role_policy_attachment" "lambda_ec2_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  #policy_arn = "arn:aws:iam::aws:policy/service-role/xx"
  policy_arn = aws_iam_policy.ec2-start-stop-list-policy.arn
}

# Add a policy to the above role to allow to call out to AWS Services
# This will allow to use CloudWatch logs
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Define a log group for each function:

resource "aws_cloudwatch_log_group" "loggroups" {
  count = length(var.functions)
  name = "/aws/lambda/${aws_lambda_function.lambda_functions[count.index].function_name}"
  retention_in_days = 1
}

data "archive_file" "zip" {
  #excludes = [ ".gitignore", ".scenario-files", "*.md", "*.sh", ]
    # var.zip_file,
  #]
  
  source_dir = "${path.module}/src"
  type = "zip"
  output_path = "${path.module}/${var.zip_file}"
}

