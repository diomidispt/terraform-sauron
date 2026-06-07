resource "aws_vpc" "this" {

  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = "default"
  tags = tomap(
    {
      "Name" = format("%s", var.name),
    }
  )

}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = tomap(
    {
      "Name" = format("%s", "${var.name}-Default-SG")
    }
  )

}

resource "aws_internet_gateway" "this" {
  count  = var.enable_internet_access ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = tomap(
    {
      "Name" = format("%s-IGW", var.name),
    }
  )

}
