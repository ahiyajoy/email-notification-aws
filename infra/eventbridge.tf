# module "schedule_test_module" {
#   source = "../_modules/.."
#   config = module.config
#   schedule = "cron(0/10 * ? * MON-FRI *)"
# }

resource "aws_cloudwatch_event_rule" "notification_event" {
  name        = "notification-event"
  description = "Triggers lambda at a schedule"

  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.notification_event.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.notification_app.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notification_app.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.notification_event.arn
}