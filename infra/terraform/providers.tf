terraform {
  backend "s3" {
    bucket         = "joeboy-mgmtacc-terraform-state"
    encrypt        = true
    key            = "Joe-Org-Github-Actions-Env/infra/terraform.tfstate"
    dynamodb_table = "joeboy-aws-mgmtacct1-terraform-lock"
    region         = "ap-southeast-2"
    # assume_role = {
    #   role_arn     = "arn:aws:iam::670213391116:role/Joe-Org-Github-Actions-Env"
    #   duration     = "60m"
    #   session_name = "infra@app_platform_env"
    # }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.24.0"
    }
  }
}


provider "aws" {
  # Configuration options
  region              = local.region
  allowed_account_ids = [local.workspace["account_id"]]
  assume_role {
    role_arn     = "arn:aws:iam::${local.workspace["account_id"]}:role/Joe-Org-Github-Actions-Env"
    duration     = "1h"
    session_name = "infra@app_platform_env"
  }
}






















# locals {
#   policy_arns = {
#     for name, bucket in local.bucket_arns[local.workspace["environment"]] : format("policy_%s", name) => {
#       policy_1 = aws_iam_policy.rdp_rods_db_instance_role_policy[name].arn
#       policy_2 = aws_iam_policy.rdp_rods_db_instance_role_export_policy.arn
#     }
#   }

#   bucket_arns = {
#     arn = local.workspace["environment"] == "test" ? {
#       wholesale_bucket_arn       = aws_s3_bucket.eql-retail-rdp-wholesale-market-analytics[0].arn
#       digital_support_bucket_arn = aws_s3_bucket.eql-retail-rdp-digital-support.arn
#       wholesale_object_arn       = "${aws_s3_bucket.eql-retail-rdp-wholesale-market-analytics[0].arn}/*"
#       digital_support_object_arn = "${aws_s3_bucket.eql-retail-rdp-digital-support.arn}/*"
#       } : {
#       digital_support_bucket_arn = aws_s3_bucket.eql-retail-rdp-digital-support.arn
#       digital_support_object_arn = "${aws_s3_bucket.eql-retail-rdp-digital-support.arn}/*"
#     }
#   }

# }
# #========================================
# # RODS DB Subnet Group
# #========================================
# resource "aws_db_subnet_group" "rods_db_subnet_group" {
#   name       = "rods_db_subnet_group"
#   subnet_ids = data.aws_subnets.ergon_retail_data_platform_data_subnets.ids
# }

# #========================================
# # RODS DB Security Group
# #========================================

# resource "aws_security_group" "rods_db_sg" {
#   name        = "RODS ${local.workspace["environment"]} DB Security Group"
#   description = "Allow inbound traffic"
#   vpc_id      = data.aws_vpc.ergon_retail_data_platform_vpc.id
# }

# resource "aws_security_group_rule" "rods_db_sg_rule1" {
#   description       = "Outbound to DNS"
#   type              = "egress"
#   security_group_id = aws_security_group.rods_db_sg.id
#   from_port         = 53
#   to_port           = 53
#   protocol          = "udp"
#   cidr_blocks       = ["10.171.32.21/32", "10.171.36.21/32"]
# }

# resource "aws_security_group_rule" "rods_db_sg_rule2" {
#   description       = "Outbound to Kraken Postgress"
#   type              = "egress"
#   security_group_id = aws_security_group.rods_db_sg.id
#   from_port         = 5432
#   to_port           = 5432
#   protocol          = "tcp"
#   cidr_blocks       = ["10.0.0.0/8"]
# }

# resource "aws_security_group_rule" "rods_db_sg_rule3" {
#   count             = local.workspace["environment"] == "test" || local.workspace["environment"] == "prod" ? 1 : 0
#   description       = "Outbound to CCB"
#   type              = "egress"
#   security_group_id = aws_security_group.rods_db_sg.id
#   from_port         = 1521
#   to_port           = 1521
#   protocol          = "tcp"
#   cidr_blocks       = local.workspace["ccb_cidr"]
# }


# locals {
#   tableau_subnets = {
#     dev = {
#       Dev01-Apps-A1 : "10.170.32.0/24"
#       Dev01-Apps-B1 : "10.170.40.0/24"
#     }
#     test = {
#       Test01-Apps-A1 : "10.169.32.0/24"
#       Test01-Apps-B1 : "10.169.40.0/24"
#     }
#     prod = {
#       Prod01-Apps-A1 : "10.168.32.0/24"
#       Prod01-Apps-B1 : "10.168.40.0/24"
#     }
#   }
# }

# resource "aws_security_group_rule" "allow_ingress_from_tableau_subnets" {
#   for_each          = local.tableau_subnets[local.environment]
#   type              = "ingress"
#   from_port         = 5432
#   to_port           = 5432
#   protocol          = "tcp"
#   security_group_id = aws_security_group.rods_db_sg.id
#   description       = "Allow ingress from tableau server (Subnet ${each.key} in AWS Account EQ_AWS_Corp_${title(local.environment)}_Acct1)"
#   cidr_blocks       = [each.value]
# }

# resource "aws_security_group_rule" "allow_all_workspaces_in_non_prod" {
#   count             = local.workspace["environment"] != "prod" ? 1 : 0
#   type              = "ingress"
#   from_port         = 5432
#   to_port           = 5432
#   protocol          = "tcp"
#   security_group_id = aws_security_group.rods_db_sg.id
#   description       = "Allow ingress from all user Workspaces"
#   cidr_blocks       = ["10.171.52.0/24", "10.171.53.0/24"]
# }

# resource "aws_security_group_rule" "allow_team_members_in_prod" {
#   for_each          = { for user_id, workspace in(local.workspace["environment"] == "prod" ? local.workspace_allowlist : {}) : user_id => workspace }
#   type              = "ingress"
#   from_port         = 5432
#   to_port           = 5432
#   protocol          = "tcp"
#   security_group_id = aws_security_group.rods_db_sg.id
#   description       = "Allow ingress from user Workspace (user id: ${each.value.user_id}, Name: ${each.value.name}) "
#   cidr_blocks       = ["${each.value.ip}/32"]
# }

# #========================================
# # RODS DB
# #========================================

# #tfsec:ignore:AVD-AWS-0176 #Ignore MEDIUM Instance does not have IAM Authentication enabled
# resource "aws_db_instance" "rdp_rods_db" {
#   identifier     = "rads${local.workspace["environment"]}"
#   instance_class = local.workspace["rds_instance_class"]

#   allocated_storage       = local.workspace["rds_allocated_storage"]
#   max_allocated_storage   = local.workspace["rds_max_allocated_storage"]
#   backup_retention_period = 30 #backup rentention period

#   engine         = "postgres"
#   engine_version = "15.5"

#   db_subnet_group_name = aws_db_subnet_group.rods_db_subnet_group.name
#   multi_az             = local.workspace["rds_multi_az"]

#   db_name                             = "rads${local.workspace["environment"]}"
#   username                            = "master" #This username was requested
#   manage_master_user_password         = true
#   master_user_secret_kms_key_id       = aws_kms_key.rds.key_id
#   iam_database_authentication_enabled = true
#   storage_encrypted                   = true
#   apply_immediately                   = true
#   deletion_protection                 = local.workspace["rds_deletion_protection"] #tfsec:ignore:AVD-AWS-0177 #Ignore MEDIUM Instance does not have Deletion Protection enabled
#   vpc_security_group_ids              = [aws_security_group.rods_db_sg.id]
#   copy_tags_to_snapshot               = true
#   final_snapshot_identifier           = "${local.workspace["environment"]}-eql-rods"
#   parameter_group_name                = aws_db_parameter_group.rods_db_pg.name

#   timeouts {
#     create = "30m"
#     delete = "30m"
#     update = "30m"
#   }

#   performance_insights_enabled          = true
#   performance_insights_kms_key_id       = aws_kms_key.rds.arn
#   performance_insights_retention_period = 7
#   enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
#   #monitoring_interval = 30
#   #monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn

#   tags = merge(module.tags.all_tags, {
#     Name = "${local.workspace["environment"]}-eql-rods"
#   })
# }

# resource "aws_db_parameter_group" "rods_db_pg" {
#   name   = "rods-${local.workspace["environment"]}-db-pg"
#   family = "postgres15"

#   parameter {
#     name         = "timezone"
#     value        = "Australia/Brisbane"
#     apply_method = "pending-reboot"
#   }

#   parameter {
#     name         = "shared_preload_libraries"
#     value        = "pg_cron,pgaudit,pg_stat_statements"
#     apply_method = "pending-reboot"
#   }

#   parameter {
#     name         = "rds.force_ssl"
#     value        = "1"
#     apply_method = "pending-reboot"
#   }

#   parameter {
#     name         = "log_statement"
#     value        = "none"
#     apply_method = "pending-reboot"
#   }

#   parameter {
#     name         = "pgaudit.log"
#     value        = "ddl,role"
#     apply_method = "pending-reboot"
#   }

#   parameter {
#     name         = "rds.custom_dns_resolution"
#     value        = "1"
#     apply_method = "pending-reboot"
#   }
# }

# # This is for the import role association to the rds instance
# resource "aws_db_instance_role_association" "rods_db_instance_role" {
#   # count = local.workspace["environment"] == "test" ? 1 : 0

#   db_instance_identifier = aws_db_instance.rdp_rods_db.identifier
#   feature_name           = "s3Import"
#   role_arn               = aws_iam_role.rdp_rods_db_instance_role.arn
# }

# # This is for the export role association to the rds instance
# resource "aws_db_instance_role_association" "rods_db_instance_export_role" {
#   # count = local.workspace["environment"] == "test" ? 1 : 0

#   db_instance_identifier = aws_db_instance.rdp_rods_db.identifier
#   feature_name           = "s3Export"
#   role_arn               = aws_iam_role.rdp_rods_db_instance_role.arn
# }
# # This is the role used by the rds to perform import/export functions on the RDS instance
# resource "aws_iam_role" "rdp_rods_db_instance_role" {
#   # count = local.workspace["environment"] == "test" ? 1 : 0

#   assume_role_policy    = data.aws_iam_policy_document.rds_assume_role.json
#   name                  = "eql-rads${local.workspace["environment"]}-s3-role"
#   permissions_boundary  = "arn:aws:iam::${local.workspace["account_id"]}:policy/EQL-Permissions-Boundary-Services"
#   force_detach_policies = true
# }

# # RDS S3 import IAM policy for test
# resource "aws_iam_policy" "rdp_rods_db_instance_role_policy" {
#   # count = local.workspace["environment"] == "test" ? 1 : 0

#   name        = "rads${local.workspace["environment"]}-s3-role-policy"
#   description = "RDS S3 import IAM policy"
#   policy      = data.aws_iam_policy_document.eql-retail-rdp-s3-import-policy.json
# }

# # RDS S3 Export IAM policy
# resource "aws_iam_policy" "rdp_rods_db_instance_role_export_policy" {
#   # count = local.workspace["environment"] == "test" ? 1 : 0

#   name        = "rads${local.workspace["environment"]}-s3-role-export-policy"
#   description = "RDS S3 Export IAM policy"
#   policy      = data.aws_iam_policy_document.eql-retail-rdp-s3-export-policy.json
# }

# # Attaching the s3 import policy to the role
# resource "aws_iam_role_policy_attachment" "rdp_rods_db_instance_role_policy_attach" {
#   # count = local.workspace["environment"] == "test" ? 1 : 0
#   for_each = local.policy_arns

#   role       = aws_iam_role.rdp_rods_db_instance_role.name
#   policy_arn = each.value
# }

# # RDS S3 import/export IAM policy document
# data "aws_iam_policy_document" "rds_assume_role" {
#   # count = local.workspace["environment"] == "test" ? 1 : 0

#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["rds.amazonaws.com"]

#     }

#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceArn"
#       values   = ["${aws_db_instance.rdp_rods_db.arn}"]
#     }
#   }
# }



# data "aws_iam_policy_document" "eql-retail-rdp-s3-import-policy" {
#   statement {
#     actions = ["s3:GetObject", "s3:ListBucket"]
#     effect  = "Allow"
#     resources = flatten([
#       for _, bucket in local.bucket_arns.arn : [
#         bucket.wholesale_bucket_arn,
#         bucket.wholesale_object_arn,
#         bucket.digital_support_bucket_arn,
#         bucket.digital_support_object_arn,
#       ]
#     ])
#   }
# }



# data "aws_iam_policy_document" "eql-retail-rdp-s3-export-policy" {
#   # count = local.workspace["environment"] == "test" ? 1 : 0

#   statement {
#     actions = ["s3:PutObject",
#       "s3:AbortMultipartUpload"
#     ]
#     effect = "Allow"
#     resources = [
#       "${aws_s3_bucket.eql-retail-rdp-digital-support.arn}/*"
#     ]
#   }
# }


# # resource "aws_db_instance" "rdp_rods_db_dbmate" {
# #   count = local.workspace["environment"] == "dev" ? 1 : 0

# #   identifier     = "rads${local.workspace["environment"]}-dbmate"
# #   instance_class = local.workspace["rds_instance_class"]

# #   allocated_storage       = local.workspace["rds_allocated_storage"]
# #   max_allocated_storage   = local.workspace["rds_max_allocated_storage"]
# #   backup_retention_period = 5

# #   engine         = "postgres"
# #   engine_version = "15.3"

# #   db_subnet_group_name = aws_db_subnet_group.rods_db_subnet_group.name
# #   multi_az             = local.workspace["rds_multi_az"]

# #   db_name                             = "rads${local.workspace["environment"]}"
# #   username                            = "master" #This username was requested
# #   manage_master_user_password         = true
# #   master_user_secret_kms_key_id       = aws_kms_key.rds.key_id
# #   iam_database_authentication_enabled = true
# #   storage_encrypted                   = true
# #   apply_immediately                   = true
# #   deletion_protection                 = local.workspace["rds_deletion_protection"] #tfsec:ignore:AVD-AWS-0177 #Ignore MEDIUM Instance does not have Deletion Protection enabled
# #   vpc_security_group_ids              = [aws_security_group.rods_db_sg.id]
# #   copy_tags_to_snapshot               = true
# #   skip_final_snapshot                 = true
# #   final_snapshot_identifier           = "MIGRATIONDBFINALSNAP"
# #   parameter_group_name                = aws_db_parameter_group.rods_db_pg.name

# #   timeouts {
# #     create = "30m"
# #     delete = "30m"
# #     update = "30m"
# #   }

# #   performance_insights_enabled          = true
# #   performance_insights_kms_key_id       = aws_kms_key.rds.arn
# #   performance_insights_retention_period = 7
# #   enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
# #   #monitoring_interval = 30
# #   #monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn

# #   tags = merge(module.tags.all_tags, {
# #     Name = "${local.workspace["environment"]}-eql-rods"
# #   })
# # }

# # resource "aws_security_group" "rods_db_sg_dbmate" {
# #   count       = local.workspace["environment"] == "dev" ? 1 : 0
# #   name        = "RODS ${local.workspace["environment"]} DB Security Group2"
# #   description = "Allow inbound traffic"
# #   vpc_id      = data.aws_vpc.ergon_retail_data_platform_vpc.id
# # }


# # # RDS S3 import IAM policy for other environment
# # resource "aws_iam_policy" "rdp_rods_db_instance_role_import_policy" {
# #   # count = local.workspace["environment"] == "test" ? 1 : 0

# #   name        = "rads${local.workspace["environment"]}-s3-role-policy"
# #   description = "RDS S3 import IAM policy"
# #   policy      = data.aws_iam_policy_document.eql-retail-rdp-s3-import-policy.json
# }
