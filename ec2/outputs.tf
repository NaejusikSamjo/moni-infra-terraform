output "nat_instance_interface_id" {
  value = aws_instance.nat_instance.primary_network_interface_id
}

output "web1_id" {
  value = aws_instance.web1.id
}

output "web2_id" {
  value = aws_instance.web2.id
}

output "web3_id" {
  value = aws_instance.web3.id
}