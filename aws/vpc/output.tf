output "id" {
  value = aws_vpc.main.id
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "private_subnet_route_tables" {
  value = aws_route_table.private
}

output "default_security_group_id" {
  value = aws_vpc.main.default_security_group_id
}
