resource "aws_subnet" "private" {
  for_each = toset(data.aws_availability_zones.az.names)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 100 + local.az_number[data.aws_availability_zone.az[each.value].name_suffix])
  availability_zone = each.value

  tags = {
    Name = "private-${each.value}"
  }
}

resource "aws_route_table" "private" {
  for_each = toset(data.aws_availability_zones.az.names)

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-${each.value}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = toset(data.aws_availability_zones.az.names)

  subnet_id      = aws_subnet.private[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}

resource "aws_route" "private" {
  for_each = toset(data.aws_availability_zones.az.names)

  route_table_id         = aws_route_table.private[each.value].id
  nat_gateway_id         = aws_nat_gateway.main[each.value].id
  destination_cidr_block = "0.0.0.0/0"
}
