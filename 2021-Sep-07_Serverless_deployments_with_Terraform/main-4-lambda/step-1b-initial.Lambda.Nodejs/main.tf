
resource "aws_iam_role" "lambda_exec_role" {
  # Note: Same role as for Python - just a different resource name
  name        = "lambda_exec_node"
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

data "archive_file" "zip" {
  #excludes = [ ".gitignore", ".scenario-files", "*.md", "*.sh", ]
    # var.zip_file,
  #]
  
  source_dir = "${path.module}/src"
  type = "zip"
  output_path = "${path.module}/${var.zip_file}"
}

