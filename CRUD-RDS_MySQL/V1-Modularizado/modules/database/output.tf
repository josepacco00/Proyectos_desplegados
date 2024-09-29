// modules/database/output.tf
output "db_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "db_identifier" {
  value = aws_db_instance.default.identifier
}

#########################################
output "db_name" {
  value     = data.aws_ssm_parameter.db_name.value
  sensitive = true
}

output "db_username" {
  value     = data.aws_ssm_parameter.db_username.value
  sensitive = true
}

output "db_password" {
  value     = data.aws_ssm_parameter.db_password.value
  sensitive = true
}