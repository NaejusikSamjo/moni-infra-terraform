output "vpc_id" {
  value = aws_vpc.main.id
}

output "route_table_id" {
  value = aws_route_table.main.id
}

output "route_table_id1" {
  value = aws_route_table.main1.id
}