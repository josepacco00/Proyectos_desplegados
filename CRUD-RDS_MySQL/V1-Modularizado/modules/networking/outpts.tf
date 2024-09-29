output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.subnet_private[*].id
}

output "db_security_group_id" {
  description = "The ID of the database security group"
  value       = aws_security_group.db_security_group.id
}

#######################################################
# En el módulo de networking
# output "private_subnet_ids" {
#   description = "List of IDs of private subnets"
#   value       = aws_subnet.subnet_private[*].id
# }

# output "first_private_subnet_id" {
#   description = "ID of the first private subnet"
#   value       = aws_subnet.subnet_private[0].id
# }

# output "second_private_subnet_id" {
#   description = "ID of the second private subnet"
#   value       = aws_subnet.subnet_private[1].id
# }

# En el archivo principal o en otro módulo que use las subredes

# Recurso que usa la primera subred
# resource "aws_instance" "example_first_subnet" {
#   ... otras configuraciones ...
#   subnet_id = module.networking.first_private_subnet_id
# }

# Recurso que usa la segunda subred
# resource "aws_instance" "example_second_subnet" {
#   ... otras configuraciones ...
#   subnet_id = module.networking.second_private_subnet_id
# }

# Recurso que usa ambas subredes
# resource "aws_db_subnet_group" "example" {
#   name       = "my-db-subnet-group"
#   subnet_ids = module.networking.private_subnet_ids
# }

# Recurso que usa una subred específica por índice
# resource "aws_instance" "example_indexed_subnet" {
#   ... otras configuraciones ...
#   subnet_id = module.networking.private_subnet_ids[0]  # Usa la primera subred
# }