
# Upload content files:

resource "aws_s3_bucket_object" "object" {
    acl    = "public-read"
    bucket = aws_s3_bucket.www_bucket.id

    for_each = fileset("content/1.simple/", "*")
    key    = each.value
    source = "content/1.simple/${each.value}"
    etag   = filemd5("content/1.simple/${each.value}")
}

