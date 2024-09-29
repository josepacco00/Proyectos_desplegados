resource "aws_api_gateway_rest_api" "API-Proyect-Recognition" {
  name        = "API-Proyect-Recognition"
  description = "API para realizar la operacion get de la BD Proyect-IA"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "id_resource" {
  rest_api_id = aws_api_gateway_rest_api.API-Proyect-Recognition.id
  parent_id   = aws_api_gateway_rest_api.API-Proyect-Recognition.root_resource_id
  path_part   = "{id}"
}

################## Método GET para /{id} (Obtener por ID)
resource "aws_api_gateway_method" "get_id_method" {
  rest_api_id   = aws_api_gateway_rest_api.API-Proyect-Recognition.id
  resource_id   = aws_api_gateway_resource.id_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

################# Configurar la Integración de los Métodos con Lambda

resource "aws_api_gateway_integration" "get_id_integration" {
  rest_api_id = aws_api_gateway_rest_api.API-Proyect-Recognition.id
  resource_id = aws_api_gateway_resource.id_resource.id
  http_method = aws_api_gateway_method.get_id_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.Lambda-Proyect-IA-GET.invoke_arn
}

############## Permisos para que API Gateway invoque Lambda
resource "aws_lambda_permission" "allow_api_gateway_get_id" {
  statement_id  = "AllowAPIGatewayInvokeGetId"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda-Proyect-IA-GET.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.API-Proyect-Recognition.execution_arn}/*/GET/{id}"
}

#Desplegar la API Gateway
resource "aws_api_gateway_deployment" "Proyect_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.get_id_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.API-Proyect-Recognition.id
  stage_name  = "production"

  lifecycle {
    create_before_destroy = true
  }
}