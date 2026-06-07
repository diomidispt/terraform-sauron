module "this" {
  source              = "../../../modules/resources/s3-bucket"
  bucket_name         = var.bucket_name
  enable_versioning   = var.enable_versioning
  block_public_access = var.block_public_access
  bucket_policy       = var.bucket_policy
  directories         = var.directories
}