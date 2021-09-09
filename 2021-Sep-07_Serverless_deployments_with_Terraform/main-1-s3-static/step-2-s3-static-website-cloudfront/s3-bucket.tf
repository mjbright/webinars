
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
      allowed_origins = ["https://www.${var.domain_name}", "https://website.${var.domain_name}"]
      max_age_seconds = 3000
  }

  # Allow Terraform to destroy this bucket even if non-empty:
  force_destroy = true

}

# S3 bucket for non-www addressing:

resource "aws_s3_bucket" "nonwww_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = templatefile("s3-policy.json", { bucket = var.bucket_name })

  website {
      redirect_all_requests_to = "https://www.${var.domain_name}"
  }
}

