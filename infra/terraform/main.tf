module "rds-db" {
  source                         = "./modules/oracle-db"
  for_each                       = var.rds-db
  rds_db                         = var.rds-db[each.key]
  rds_db_name                    = each.key
  environment                    = local.workspace["environment"]
  subnet_ids                     = [aws_subnet.subnet_2.id, aws_subnet.subnet_3.id]
  vpc_security_group_memberships = aws_security_group.joes-oracle-db-sg.id
  secret                         = aws_secretsmanager_secret.db_secret

}


# module "lambda" {
#   source                 = "./modules/lambda"
#   for_each               = var.lambda
#   lambda                 = var.lambda[each.key]
#   lambda_name            = each.key
#   account_id             = local.workspace["account_id"]
#   subnet_ids             = [aws_subnet.subnet_2.id, aws_subnet.subnet_3.id]
#   vpc_security_group_ids = [aws_security_group.lambda_sg.id]
#   # event_bridge_resource  = module.event_bridge[each.value.event_bridge_name].aws_cloudwatch_event_rule.lambda
# }

# module "event_bridge" {
#   source            = "./modules/event-bridge"
#   for_each          = var.event_bridge
#   event_bridge      = var.event_bridge[each.key]
#   event_bridge_name = each.key
#   lambda_arn        = module.lambda[each.value.function_name].lambda_arn
# }