resource "aws_cloudwatch_metric_alarm" "cartsamount" {
  alarm_name                = "3-times-carts-amount-is-5-1043"
  namespace                 = "1043"
  metric_name               = "carts.value"

  comparison_operator       = "GreaterThanThreshold"
  threshold                 = "5"
  evaluation_periods        = "3"
  period                    = "30"

  statistic                 = "Maximum"

  alarm_description         = "This alarm goes off as soon as the carts amount has reached 5 after 3 times within 5 minutes."
  insufficient_data_actions = []
  alarm_actions       = [aws_sns_topic.alarms.arn]
}

resource "aws_sns_topic" "alarms" {
  name = "alarm-topic-${var.candidate_id}"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.candidate_email
}