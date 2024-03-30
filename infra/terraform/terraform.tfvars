vpc_cidr_block      = "10.0.0.0/16"
vpc_name            = "joes-vpc"
subnet_1_cidr_block = "10.0.1.0/24"
subnet_1_name       = "ec2-subnet"
subnet_2_cidr_block = "10.0.2.0/24"
subnet_2_name       = "database_subnet_1"
subnet_3_cidr_block = "10.0.3.0/24"
subnet_3_name       = "database_subnet_2"
availability_zone_1 = "ap-southeast-2a"
availability_zone_2 = "ap-southeast-2b"
availability_zone_3 = "ap-southeast-2c"
internet_gw_name    = "joes-igw"
nat_gw_name         = "joes-ngw"
db_secret_name      = "joes-db-secret-2"

workspace_ip = {
  joseph = { ip = "10.0.0.0", user_id = "joey197", region = "ap-southeast-2" }
}

rds-db = {
  joes-oracle-db = {
    db_subnet_group_name     = "joes-db-subnet-group"
    db_option_group_name     = "joes-db-option-group"
    option_group_description = "Option group for Joes DB"
    engine_name              = "oracle-se2"
    major_engine_version     = "19"
    options_group = [{
      option_name = "SSL"
      attach_port = true
      attach_sg   = true
      option_settings = [
        {
          name  = "SQLNET.SSL_VERSION"
          value = "1.2"
        },

        {
          name  = "SQLNET.CIPHER_SUITE"
          value = "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"
        },

        {
          name  = "FIPS.SSLFIPS_140"
          value = "TRUE"

        }
      ]
      },
      {
        option_name = "EFS_INTEGRATION"
        attach_port = false
        attach_sg   = false
        option_settings = [
          {
            name  = "EFS_ID"
            value = "fs-0f287e0acd147d19b"
          },

          {
            name  = "USE_IAM_ROLE"
            value = "FALSE"
          }
        ]
    }]
    allocated_storage                     = 500
    backup_retention_period               = 5
    max_allocated_storage                 = 2000
    engine                                = "oracle-se2"
    engine_version                        = "19.0.0.0.ru-2023-04.rur-2023-04.r1"
    identifier                            = "joes-db"
    instance_class                        = "db.t3.small"
    license_model                         = "license-included"
    multi_az                              = false
    manage_master_user_password           = true
    username                              = "joseph"
    storage_encrypted                     = true
    skip_final_snapshot                   = true
    apply_immediately                     = true
    deletion_protection                   = false
    copy_tags_to_snapshot                 = true
    publicly_accessible                   = false
    final_snapshot_identifier             = "MIGRATIONDBFINALSNAP"
    enabled_cloudwatch_logs_exports       = ["audit", "alert", "listener", "trace"]
    monitoring_interval                   = 30
    performance_insights_enabled          = true
    performance_insights_retention_period = 7
  }
}

s3_buckets = {
  terraform-state-bucket-001 = {
    force_destroy                         = true
    block_public_acls                     = true
    block_public_policy                   = true
    ignore_public_acls                    = true
    restrict_public_buckets               = true
    attach_policy                         = false
    attach_lb_log_delivery_policy         = false
    attach_cloudfront_policy              = false
    cloudfront_distribution               = ""
    attach_deny_insecure_transport_policy = false
    attach_require_latest_tls_policy      = false
    custom_policy                         = ""
    create_object                         = true
    object_key                            = "efs-files/index.html"
    object_source                         = "index.html"
    kms_master_key_id                     = "alias/cmk/s3"
    sse_algorithm                         = "aws:kms"
    versioning                            = "Enabled"
    server_side_encryption                = "AES256"
    content_type                          = "text/html"
  }
}

lambda = {
  stoprds = {
    function_name                  = "stoprds"
    description                    = "Auto Stop RDS Instance (from tag : AutoStop)"
    handler                        = "autostoprdsinstance.lambda_handler"
    runtime                        = "python3.9"
    zip_name                       = "autostopfunction"
    create_async_event_config      = true
    maximum_retry_attempts         = 0
    tracing_mode                   = "Active"
    reserved_concurrent_executions = 10
    memory_size                    = 128
    create_role                    = false
    timeout                        = 15
    environment_variables          = { KEY = "DEV-TEST", REGION = "ap-southeast-2", VALUE = "Auto-Shutdown" }
    event_bridge_arn               = "arn:aws:events:ap-southeast-2:670213391116:rule/AutoStopRDSRule"
    tags                           = { Name = "stoprds" }
  }
  startrds = {
    function_name                  = "startrds"
    description                    = "Auto Start RDS Instance (from tag : AutoStart)"
    handler                        = "autostartrdsinstance.lambda_handler"
    runtime                        = "python3.9"
    zip_name                       = "autostartfunction"
    create_async_event_config      = true
    maximum_retry_attempts         = 0
    tracing_mode                   = "Active"
    reserved_concurrent_executions = 10
    memory_size                    = 128
    create_role                    = false
    timeout                        = 15
    environment_variables          = { KEY = "DEV-TEST", REGION = "ap-southeast-2", VALUE = "Auto-Shutdown" }
    event_bridge_arn               = "arn:aws:events:ap-southeast-2:670213391116:rule/AutoStartRDSRule"
    tags                           = { Name = "stoprds" }
  }
}

event_bridge = {

  AutoStopRDSRule = {
    name                = "AutoStopRDSRule"
    description         = "Auto Stop RDS Instance (Mon-Fri 9:00 PM EST / 1:00 AM UTC)"
    schedule_expression = "cron(30 22 ? * MON-FRI *)"
    target_id           = "AutoStopRDSTarget"
    function_name       = "stoprds"
  }

  AutoStartRDSRule = {
    name                = "AutoStartRDSRule"
    description         = "Auto Start RDS Instance (Mon-Fri 9:00 AM EST / 1:00 PM UTC)"
    schedule_expression = "cron(0 22 ? * MON-FRI *)"
    target_id           = "AutoStartRDSTarget"
    function_name       = "startrds"
  }
}