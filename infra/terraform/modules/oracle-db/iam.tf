resource "aws_iam_role" "db_role" {

  assume_role_policy    = data.aws_iam_policy_document.rds_assume_role.json
  name                  = "rds-efs-${var.environment}-integration-role"
  force_detach_policies = true
}

data "aws_iam_policy_document" "rds_assume_role" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]

    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["${aws_db_instance.db.arn}"]
    }
  }
}

resource "aws_db_instance_role_association" "db_role" {

  db_instance_identifier = aws_db_instance.db.identifier
  feature_name           = "EFS_INTEGRATION"
  role_arn               = aws_iam_role.db_role.arn
}