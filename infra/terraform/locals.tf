locals {
  region = "ap-southeast-2"
  env = {
    joseph_account = {
      account_id  = "670213391116"
      environment = "dev"
    }
  }
  workspace = local.env["joseph_account"]
} 