provider "aws" {
  region = "us-east-1"
}

//zip file of our source code (js) to deploy it into lambda.


provider "archive" {}
data "archive_file" "lambda_zip" {

  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "/tmp/lambda_zip.zip"
}

data "aws_iam_policy_document" "policy_lambda" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}




resource "aws_iam_policy" "policy_ses" {
  name = "policy-ses"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["ses:*"],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_policy" {
  name = "dynamodb_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:*"],
        "Resource" : "${aws_dynamodb_table.notification-dynamodb-table.arn}"
      }
    ]
  })
}






resource "aws_iam_role" "notification_app_role" {
  name                = "notification_app_role"
  assume_role_policy  = data.aws_iam_policy_document.policy_lambda.json
  managed_policy_arns = [aws_iam_policy.policy_ses.arn, aws_iam_policy.dynamodb_policy.arn, "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

}
resource "aws_lambda_function" "notification_app" {
  function_name    = "notification_function_app"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.notification_app_role.arn
  handler          = "dist/index.handler"
  runtime          = "nodejs16.x"
}