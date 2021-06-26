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
