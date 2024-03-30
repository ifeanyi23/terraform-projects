module "rds_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.lambda_name
  handler       = var.lambda.handler
  runtime       = var.lambda.runtime

  vpc_subnet_ids                 = var.subnet_ids
  vpc_security_group_ids         = var.vpc_security_group_ids
  create_async_event_config      = var.lambda.create_async_event_config
  maximum_retry_attempts         = var.lambda.maximum_retry_attempts
  tracing_mode                   = var.lambda.tracing_mode
  reserved_concurrent_executions = var.lambda.reserved_concurrent_executions

  create_role = var.lambda.create_role
  lambda_role = "arn:aws:iam::${var.account_id}:role/rds-lambda-role"
  timeout     = var.lambda.timeout

  source_path = [
    "${path.module}/src/",
    {
      path             = "${path.module}/src/",
      pip_requirements = true
    }
  ]
  local_existing_package                  = "${path.module}/src/${var.lambda.zip_name}.zip"
  environment_variables                   = var.lambda.environment_variables
  kms_key_arn                             = "arn:aws:kms:ap-southeast-2:${var.account_id}:key/1c9859fd-f522-430a-8223-bc808c01be7f"
  publish                                 = true
  create_current_version_allowed_triggers = false
  allowed_triggers = {
    OneRule = {
      principal  = "events.amazonaws.com"
      source_arn = var.lambda.event_bridge_arn
    }
  }

  # depends_on = [
  #   var.event_bridge_resource
  # ]

  tags = var.lambda.tags
}