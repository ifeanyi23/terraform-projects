# resource "aws_efs_file_system" "rds_efs_integration" {
#   creation_token  = "${local.workspace["environment"]}-rds-efs-integration"
#   throughput_mode = "elastic"
#   encrypted       = true
#   lifecycle_policy {
#     transition_to_ia = "AFTER_30_DAYS"
#   }
#   tags = {
#     Name = "${local.workspace["environment"]}-rds-efs-integration"
#   }
# }

# resource "aws_efs_backup_policy" "rds_efs_integration_backup_policy" {
#   file_system_id = aws_efs_file_system.rds_efs_integration.id

#   backup_policy {
#     status = "ENABLED"
#   }
# }

# resource "aws_efs_mount_target" "az1" {
#   file_system_id  = aws_efs_file_system.rds_efs_integration.id
#   subnet_id       = aws_subnet.subnet_1.id
#   security_groups = [aws_security_group.efs_mount_target_sg.id]
# }
# resource "aws_efs_mount_target" "az2" {
#   file_system_id  = aws_efs_file_system.rds_efs_integration.id
#   subnet_id       = aws_subnet.subnet_2.id
#   security_groups = [aws_security_group.efs_mount_target_sg.id]
# }
# resource "aws_efs_mount_target" "az3" {
#   file_system_id  = aws_efs_file_system.rds_efs_integration.id
#   subnet_id       = aws_subnet.subnet_3.id
#   security_groups = [aws_security_group.efs_mount_target_sg.id]
# }


# data "aws_iam_policy_document" "rds_efs_integration_file_system_policy" {
#   statement {
#     sid    = "efs-statement-99089cab-f487-4d4e-8063-3bb36bf6d560"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }

#     actions = [
#       "elasticfilesystem:ClientMount",
#       "elasticfilesystem:ClientWrite",
#       "elasticfilesystem:ClientRootAccess"
#     ]

#     resources = [aws_efs_file_system.rds_efs_integration.arn]

#     condition {
#       test     = "Bool"
#       variable = "elasticfilesystem:AccessedViaMountTarget"
#       values   = ["true"]
#     }
#   }

#   statement {
#     sid    = "efs-statement-554dc0fa-5ee9-4a43-beac-bae618ec65f3"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = [module.rds-db["joes-oracle-db"].db_role_arn] #aws_iam_role.datasync_service_role.arn
#     }

#     actions = [
#       "elasticfilesystem:ClientMount",
#       "elasticfilesystem:ClientWrite",
#       "elasticfilesystem:ClientRootAccess"
#     ]

#     resources = [aws_efs_file_system.rds_efs_integration.arn]
#   }
# }

# resource "aws_efs_file_system_policy" "rds_efs_integration_file_system_policy" {
#   file_system_id = aws_efs_file_system.rds_efs_integration.id
#   policy         = data.aws_iam_policy_document.rds_efs_integration_file_system_policy.json
# }