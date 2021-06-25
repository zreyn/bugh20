resource "aws_s3_bucket" "bug_h20_data" {
    bucket = "bug-h20-data"
    versioning {
      enabled = true
    }
    tags = {
      Name = "data store for bug-h20"
    }
}