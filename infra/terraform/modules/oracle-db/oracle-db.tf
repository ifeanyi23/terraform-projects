#========================================
# Joes Oracle DB
#========================================

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.rds_db.db_subnet_group_name
  subnet_ids = var.subnet_ids
}

resource "aws_db_option_group" "db_option_group" {
  name                     = var.rds_db.db_option_group_name
  option_group_description = var.rds_db.option_group_description
  engine_name              = var.rds_db.engine_name
  major_engine_version     = var.rds_db.major_engine_version

  dynamic "option" {
    for_each = var.rds_db.options_group
    content {
      option_name                    = option.value["option_name"]
      port                           = option.value["attach_port"] ? 2482 : null
      vpc_security_group_memberships = option.value["attach_sg"] ? [var.vpc_security_group_memberships] : null

      dynamic "option_settings" {
        for_each = option.value["option_settings"]
        content {
          name  = option_settings.value["name"]
          value = option_settings.value["value"]
        }
      }
    }
  }
}

resource "aws_db_instance" "db" {
  allocated_storage       = var.rds_db.allocated_storage
  backup_retention_period = var.rds_db.backup_retention_period
  max_allocated_storage   = var.rds_db.max_allocated_storage
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.id
  engine                  = var.rds_db.engine
  engine_version          = var.rds_db.engine_version
  identifier              = "${var.rds_db.identifier}-${var.environment}"
  instance_class          = var.rds_db.instance_class
  license_model           = var.rds_db.license_model
  multi_az                = var.rds_db.multi_az
  # manage_master_user_password = var.rds_db.manage_master_user_password
  username                  = var.rds_db.username
  password                  = jsondecode(data.aws_secretsmanager_secret_version.current_secrets.secret_string)["password"]
  storage_encrypted         = var.rds_db.storage_encrypted
  skip_final_snapshot       = var.rds_db.skip_final_snapshot
  apply_immediately         = var.rds_db.apply_immediately
  deletion_protection       = var.rds_db.deletion_protection
  copy_tags_to_snapshot     = var.rds_db.copy_tags_to_snapshot
  publicly_accessible       = var.rds_db.publicly_accessible
  vpc_security_group_ids    = [var.vpc_security_group_memberships]
  final_snapshot_identifier = var.rds_db.final_snapshot_identifier
  option_group_name         = aws_db_option_group.db_option_group.id
  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
  enabled_cloudwatch_logs_exports       = var.rds_db.enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.rds_db.monitoring_interval
  monitoring_role_arn                   = aws_iam_role.rds_enhanced_monitoring.arn
  performance_insights_enabled          = var.rds_db.performance_insights_enabled
  performance_insights_retention_period = var.rds_db.performance_insights_retention_period
  tags = {
    AutoStop  = true
    AutoStart = true
  }
}

##############################################################################
# Create an IAM role to allow enhanced monitoring
##############################################################################

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name_prefix        = "${local.workspace["environment"]}-rds-enhanced-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# backup_window               = "13:00-15:00"