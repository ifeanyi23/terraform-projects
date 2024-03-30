resource "aws_secretsmanager_secret" "db_secret" {
  name        = "secret/${var.db_secret_name}"
  description = "Connection credentials to access the database."

  tags = {
    Name = "${local.workspace["environment"]}-${var.db_secret_name}"
  }
}

data "aws_iam_policy_document" "db_secret_policy" {
  version = "2012-10-17"

  statement {
    effect = "Deny"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "*"
      ]
    }

    condition {
      test     = "ArnNotEquals"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${local.workspace["account_id"]}:user/joeboy"
      ]
    }
  }
}

resource "aws_secretsmanager_secret_policy" "DB-Policy" {
  secret_arn = aws_secretsmanager_secret.db_secret.arn
  policy     = data.aws_iam_policy_document.db_secret_policy.json
}

# resource "aws_secretsmanager_secret_policy" "Joes-Master-User-Secret-Policy" {
#   secret_arn = module.rds-db["joes-oracle-db"].aws_db_instance.db.master_user_secret[0].secret_arn
#   policy     = data.aws_iam_policy_document.db_secret_policy.json
# }