locals {
  az_number = {
    a = 0
    c = 1
    d = 2
  }
}

data "aws_availability_zones" "az" {}

data "aws_availability_zone" "az" {
  for_each = toset(data.aws_availability_zones.az.names)
  name     = each.value
}
