resource "aws_cloudwatch_event_rule" "lambda" {
  name                = var.event_bridge_name
  description         = var.event_bridge.description
  schedule_expression = var.event_bridge.schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda" {
  target_id = var.event_bridge.target_id
  arn       = var.lambda_arn
  rule      = aws_cloudwatch_event_rule.lambda.name
  #   role_arn  = aws_iam_role.ssm_lifecycle.arn
}