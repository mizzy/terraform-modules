resource "aws_subnet" "database" {
  for_each = toset(data.aws_availability_zones.az.names)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 200 + local.az_number[data.aws_availability_zone.az[each.value].name_suffix])
  availability_zone = each.value

  tags = {
    Name = "database-${each.value}"
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "database"
  }
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database.id
}
