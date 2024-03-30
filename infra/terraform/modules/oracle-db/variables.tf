variable "rds_db" {}

variable "rds_db_name" {}

variable "environment" {
  type        = string
  description = "This is the name of the environment"
}

variable "subnet_ids" {
  type        = list(string)
  description = "This is the subnet ids the database will belong too"
}

variable "vpc_security_group_memberships" {
  type        = string
  description = "This is the security group of the database"
}

variable "secret" {}