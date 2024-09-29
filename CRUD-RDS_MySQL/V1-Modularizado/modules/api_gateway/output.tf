output "api_url" {
  description = "URL del endpoint de la API Gateway"
  value       = "${aws_api_gateway_deployment.crud_api_deployment.invoke_url}${aws_api_gateway_stage.production.stage_name}/${aws_api_gateway_resource.items_resource.path_part}"
}
