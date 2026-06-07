data "aws_availability_zones" "current" {}

data "aws_availability_zone" "current" {
  # Use up to 3 availability zones
  count = length(length(data.aws_availability_zones.current.names) <= 2 ? data.aws_availability_zones.current.names : slice(data.aws_availability_zones.current.names, 0, 3))
  name  = data.aws_availability_zones.current.names[count.index]
}