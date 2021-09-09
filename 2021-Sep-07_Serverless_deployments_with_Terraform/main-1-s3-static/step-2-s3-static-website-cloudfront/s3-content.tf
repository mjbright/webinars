
# Upload content files:

resource "aws_s3_bucket_object" "object" {
  acl    = "public-read"
  bucket = aws_s3_bucket.www_bucket.id

  # See https://engineering.statefarm.com/blog/terraform-s3-upload-with-mime/
  #content_type = "text/html"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null) # if none found default to null (will result in binary/octet-stream)

  # just top-level files:
  # for_each = fileset("content/${var.content_subdir}/", "*")

  # take hierarchy: see https://acode.ninja/posts/recursive-file-upload-to-s3-in-terraform/
  for_each = fileset("content/${var.content_subdir}/", "**/*.*")
  key      = each.value

  source = "content/${var.content_subdir}/${each.value}"
  etag   = filemd5("content/${var.content_subdir}/${each.value}")
}

locals {
  mime_types = jsondecode(file("content/mime.json"))
}

