resource "aws_ecr_repository" "tika_lambda" {
  name                 = "tika-lambda"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
