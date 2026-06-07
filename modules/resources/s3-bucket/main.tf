resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_access
  ignore_public_acls      = var.block_public_access
  block_public_policy     = var.block_public_access
  restrict_public_buckets = var.block_public_access
}

resource "aws_s3_bucket_policy" "this" {
  count  = length(var.bucket_policy.Statement) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = jsonencode(var.bucket_policy)
}

resource "aws_s3_object" "directories" {
  for_each = toset(var.directories)
  bucket   = aws_s3_bucket.this.id
  key      = "${each.value}/"
}