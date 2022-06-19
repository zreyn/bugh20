resource "aws_s3_bucket" "bug_h20_data" {
  bucket = "bug-h20-data"
  versioning {
    enabled = true
  }
  tags = {
    Name = "data store for bug-h20"
  }
}


resource "aws_s3_bucket" "bug_h2o_external" {
  bucket = "bug-h2o-external"

  tags = {
    Name = "bug-h2o-external"
  }
}

resource "aws_s3_bucket_versioning" "bucket_vers" {
  bucket = aws_s3_bucket.bug_h2o_external.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bug_h2o_external.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encrypt" {
  bucket = aws_s3_bucket.bug_h2o_external.id

  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.bug_h2o_external.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_no_public_access" {
  bucket = aws_s3_bucket.bug_h2o_external.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership_controls
  ]
}
