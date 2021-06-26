
resource "aws_lambda_function" "tika_lambda" {
  image_uri     = "${aws_ecr_repository.tika_lambda.repository_url}:latest"
  package_type  = "Image"
  function_name = "tika_lambda"
  role          = aws_iam_role.bug_h20_lambda.arn
  image_config {
    command = ["src.handler.lambda_handler"]
  }
  timeout     = 300
  memory_size = 256

  environment {
    variables = {
      S3_BUCKET      = aws_s3_bucket.bug_h20_data.id
      PDF_PREFIX     = "pages"
      EXTRACT_PREFIX = "metadata"
      S3_REGION     = var.aws_region
    }
  }
}