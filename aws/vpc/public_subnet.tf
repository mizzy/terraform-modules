resource "aws_subnet" "public" {
  for_each = toset(data.aws_availability_zones.az.names)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, local.az_number[data.aws_availability_zone.az[each.value].name_suffix])
  map_public_ip_on_launch = true
  availability_zone       = each.value

  tags = {
    Name = "public-${each.value}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_gateway" {
  for_each = toset(data.aws_availability_zones.az.names)

  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  for_each = toset(data.aws_availability_zones.az.names)

  allocation_id = aws_eip.nat_gateway[each.value].id
  subnet_id     = aws_subnet.public[each.value].id
  depends_on    = [aws_internet_gateway.main]
}
