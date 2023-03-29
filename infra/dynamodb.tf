resource "aws_dynamodb_table" "notification-dynamodb-table" {
  name           = "NotificationApp"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "UserId"
  range_key      = "EmailId"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "EmailId"
    type = "S"
  }

  attribute {
    name = "SubscriptionEnd"
    type = "S"
  }



  global_secondary_index {
    name               = "GlobalNotification"
    hash_key           = "SubscriptionEnd"
    range_key          = "EmailId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "dynamodb-notification-app"
    Environment = "production"
  }
}