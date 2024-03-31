locals {
  region = "ap-southeast-2"
  env = {
    joe-org-platform-env-dev = {
      account_id  = "211125691937"
      environment = "dev"
    }
    joe-org-platform-env-test = {
      account_id  = "975050099482"
      environment = "test"
    }
    joe-org-platform-env-prod = {
      account_id  = "058264509160"
      environment = "prod"
    }
  }
  workspace = local.env[terraform.workspace]
} 