variable "vpc_cidr_block" {
  type        = string
  description = "This is the cidr block for the vpc"
}

variable "vpc_name" {
  type        = string
  description = "This is the name of the vpc"
}

variable "subnet_1_cidr_block" {
  type        = string
  description = "This is the cidr block of the first subnet"
}

variable "subnet_1_name" {
  type        = string
  description = "This is the name of the the first subnet"
}

variable "subnet_2_cidr_block" {
  type        = string
  description = "This is the cidr block of the second subnet"
}

variable "subnet_2_name" {
  type        = string
  description = "This is the name of the the second subnet"
}

variable "subnet_3_cidr_block" {
  type        = string
  description = "This is the cidr block of the third subnet"
}

variable "subnet_3_name" {
  type        = string
  description = "This is the name of the the third subnet"
}

variable "availability_zone_1" {
  type        = string
  description = "This is the name of the first availability zone"
}

variable "availability_zone_2" {
  type        = string
  description = "This is the name of the second availability zone"
}

variable "availability_zone_3" {
  type        = string
  description = "This is the name of the third availability zone"
}

variable "internet_gw_name" {
  type        = string
  description = "This is the name of the internet gateway"
}

variable "nat_gw_name" {
  type        = string
  description = "This is the name of the nat gateway"
}

variable "db_secret_name" {
  type        = string
  description = "This is the name of the db secret"
}


variable "rds-db" {
  type = map(object({
    db_subnet_group_name     = string
    db_option_group_name     = string
    option_group_description = string
    engine_name              = string
    major_engine_version     = string
    options_group = list(object({
      option_name = string
      attach_port = bool
      attach_sg   = bool
      option_settings = list(object({
        name  = string
        value = string
      }))
    }))
    allocated_storage                     = number
    backup_retention_period               = number
    max_allocated_storage                 = number
    engine                                = string
    engine_version                        = string
    identifier                            = string
    instance_class                        = string
    license_model                         = string
    multi_az                              = bool
    manage_master_user_password           = bool
    username                              = string
    storage_encrypted                     = bool
    skip_final_snapshot                   = bool
    apply_immediately                     = bool
    deletion_protection                   = bool
    copy_tags_to_snapshot                 = bool
    publicly_accessible                   = bool
    final_snapshot_identifier             = string
    enabled_cloudwatch_logs_exports       = list(string)
    monitoring_interval                   = number
    performance_insights_enabled          = bool
    performance_insights_retention_period = number
  }))
}

variable "lambda" {
  type = map(object({
    function_name                  = string
    description                    = string
    handler                        = string
    runtime                        = string
    zip_name                       = string
    create_async_event_config      = bool
    maximum_retry_attempts         = number
    tracing_mode                   = string
    reserved_concurrent_executions = number
    memory_size                    = number
    create_role                    = bool
    timeout                        = number
    environment_variables          = map(string)
    event_bridge_arn               = string
    tags                           = map(string)

  }))
}

variable "event_bridge" {
  type = map(object({
    name                = string
    description         = string
    schedule_expression = string
    target_id           = string
    function_name       = string

  }))
}

variable "workspace_ip" {
  type = map(map(string))
  # default = {
  #   joseph = { ip = "10.0.0.0", user_id = "joey197", region = "ap-southeast-2" }
  #   # joel   = { ip = "10.0.2.12", user_id = "joel198", region = "ap-southeast-2" }
  # }
}

variable "s3_buckets" {
  type = map(object({
    force_destroy                         = bool
    block_public_acls                     = bool
    block_public_policy                   = bool
    ignore_public_acls                    = bool
    restrict_public_buckets               = bool
    attach_policy                         = bool
    attach_deny_insecure_transport_policy = bool
    attach_require_latest_tls_policy      = bool
    attach_lb_log_delivery_policy         = bool
    attach_cloudfront_policy              = bool
    cloudfront_distribution               = string
    custom_policy                         = string
    create_object                         = bool
    object_key                            = string
    object_source                         = string
    kms_master_key_id                     = string
    sse_algorithm                         = string
    versioning                            = string
    server_side_encryption                = string
    content_type                          = string
  }))
}

