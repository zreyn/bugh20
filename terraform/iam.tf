data "aws_iam_policy_document" "bug_h20_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bug_h20_lambda" {
  name               = "bug-h20-lambda"
  assume_role_policy = data.aws_iam_policy_document.bug_h20_assume_role_policy.json
}

data "aws_iam_policy_document" "bug_h20_lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "cloudwatch:GetMetricStatistics"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "xray:PutTraceSegments"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:*"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::bug-h20-data",
      "arn:aws:s3:::bug-h20-data/*",
    ]
  }
}

resource "aws_iam_role_policy" "bug_h20_policy" {
  name   = "bug-h20-policy"
  role   = aws_iam_role.bug_h20_lambda.name
  policy = data.aws_iam_policy_document.bug_h20_lambda_policy.json
}


resource "aws_iam_user" "coldfusion_s3_reader_user" {
  name = "coldfusion_s3_reader_user"
}

resource "aws_iam_policy" "coldfusion_s3_reader_user_policy" {
  name   = "coldfusion_s3_reader_user_policy"
  policy = data.aws_iam_policy_document.coldfusion_s3_reader_user_policy_doc.json
}

data "aws_iam_policy_document" "coldfusion_s3_reader_user_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetBucketAcl",
      "s3:GetBucketCors",
      "s3:GetBucketWebsite",
      "s3:GetBucketVersioning",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketLogging",
      "s3:GetLifecycleConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
    ]
    resources = [
      "arn:aws:s3:::bug-h2o-external",
      "arn:aws:s3:::bug-h2o-external/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:us-east-1:957084485587:parameter/coldfusion/*"
    ]
  }
}

resource "aws_iam_user_policy_attachment" "coldfusion_s3_reader_user_policy_attach" {
  user       = aws_iam_user.coldfusion_s3_reader_user.name
  policy_arn = aws_iam_policy.coldfusion_s3_reader_user_policy.arn
}