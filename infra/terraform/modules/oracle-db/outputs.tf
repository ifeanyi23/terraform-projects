output "db_arn" {
  value = aws_db_instance.db.arn
}

output "db_role_arn" {
  value = aws_iam_role.db_role.arn
}