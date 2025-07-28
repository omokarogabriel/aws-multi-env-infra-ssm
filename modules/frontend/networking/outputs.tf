# output "name" {
#   value = var.vpc_name
# }

# output "vpc_id" {
#   value = aws_vpc.vpc.id
# }

# output "public_subnet_ids" {
#   value = aws_subnet.public_subnet[*].id
# }

# output "private_subnet_ids" {
#   value = aws_subnet.private_subnet[*].id
# }





output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}
