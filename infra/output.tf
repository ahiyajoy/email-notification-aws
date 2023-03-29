//output of Terraform execution

output "lambda" {
  value = aws_lambda_function.notification_app.qualified_arn
}