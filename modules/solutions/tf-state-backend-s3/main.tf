module "terraform_state_backend" {
  source              = "cloudposse/tfstate-backend/aws"
  version             = "1.7.0"
  name                = "terraform"
  attributes          = ["state"]
  s3_bucket_name      = var.environment_name
  dynamodb_table_name = var.environment_name
  #   terraform_backend_config_file_path = "."
  #   terraform_backend_config_file_name = "backend.tf"
  force_destroy = false
}