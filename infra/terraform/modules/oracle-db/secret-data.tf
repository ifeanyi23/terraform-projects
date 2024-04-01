# data "aws_secretsmanager_secret" "db_secrets" {
#   name = "secret/joes-db-secret-2"
#   depends_on = [
#     var.secret
#   ]
# }
# data "aws_secretsmanager_secret_version" "current_secrets" {
#   secret_id = data.aws_secretsmanager_secret.db_secrets.id
# }