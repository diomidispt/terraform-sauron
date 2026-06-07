locals {
  azs              = data.aws_availability_zone.current
  environment_name = "${var.env_name}-${var.env_type}"
  vpc_name         = "${local.environment_name}-VPC"
}
