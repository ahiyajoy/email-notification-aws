



resource "aws_ses_configuration_set" "notification-ses" {
  name = "notification-app-ses"
}

resource "aws_ses_email_identity" "email_from" {
  email = "ahiyajoy@gmail.com"
}

resource "aws_ses_receipt_rule_set" "notification-ses-ruleset" {
  rule_set_name = "notification_ses_rule_set"
}

resource "aws_ses_template" "notification_app-template" {
  name    = "notification-template"
  subject = "Greetings, Ahiya!"
  html    = "<h1>Hello Ahiya,</h1><p>Your favorite animal is --.</p>"
  text    = "Hello Ahiya,\r\nYour favorite animal is --."
}

