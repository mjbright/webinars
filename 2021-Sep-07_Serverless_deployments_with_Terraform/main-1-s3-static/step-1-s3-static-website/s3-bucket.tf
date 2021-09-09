
# S3 bucket for www addressing:

resource "aws_s3_bucket" "www_bucket"  {
  bucket = "www.${var.bucket_name}"
  acl    = "public-read"
  policy = templatefile("s3-policy.json", { bucket = "www.${var.bucket_name}" })

  website {
      index_document = "index.html"
      error_document = "404.html"
  }

  cors_rule {
      allowed_headers = ["Authorization", "Content-Length"]
      allowed_methods = ["GET", "POST"]

      # NOTE: we have not yet a DNS entry for this domain_name:
      allowed_origins = ["https://www.${var.domain_name}"]

      max_age_seconds = 3000
  }
}


