
resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}

resource "aws_s3_bucket" "s3bucket" {
  #bucket = "${var.bucketnameprefix}${formatdate("YYYYMMMDD", timestamp())}-${random_string.random.result}"
  #bucket = "${var.bucketnameprefix}${formatdate("YYYYMMMDD", timestamp())}"
  bucket = "${var.bucketnameprefix}-${random_string.random.result}"

  tags = {
      terraform = "True"
  }


  # Allow Terraform to destroy this bucket even if non-empty:
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_sqs_queue" "q" {
  name = "s3-event-queue"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:s3-event-queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.s3bucket.arn}" }
      }
    }
  ]
}
EOF

}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3bucket.id

  queue {
    queue_arn     = aws_sqs_queue.q.arn
    events        = ["s3:ObjectCreated:*"]
  }
}


