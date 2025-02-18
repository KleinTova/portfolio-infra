locals {
  global = read_terragrunt_config(find_in_parent_folders("global.hcl")).locals
}

# Remote state configuration
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "tova-portfolio-terraform-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.global.region}"
    encrypt        = true
  }
}