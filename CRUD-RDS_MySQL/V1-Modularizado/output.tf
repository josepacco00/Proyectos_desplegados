# output "security_group_ids" {
#     value = module.networking.db_security_group_id
# }

# output "subnet_ids" {
#     value = module.networking.private_subnet_ids
# }

output "api_url" {
    description = "URL del endpoint de la API Gateway"
    value = module.api_gateway.api_url
}