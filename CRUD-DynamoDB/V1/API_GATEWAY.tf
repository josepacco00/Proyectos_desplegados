resource "aws_api_gateway_rest_api" "crud_api" {
  name        = "CRUD_API"
  description = "API para operaciones CRUD utilizando Lambda y DynamoDB"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#Crear los Recursos (Rutas) en la API Gateway
resource "aws_api_gateway_resource" "items_resource" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  parent_id   = aws_api_gateway_rest_api.crud_api.root_resource_id
  path_part   = "items"
}

#################################################### METODOS EN LA API
#Método GET para /items (Listar ítems)
resource "aws_api_gateway_method" "get_items_method" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.items_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

#Método POST para /items (Crear ítem)
resource "aws_api_gateway_method" "post_items_method" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.items_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

#Método GET para /items/{id} (Leer ítem)
resource "aws_api_gateway_resource" "item_resource" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  parent_id   = aws_api_gateway_resource.items_resource.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_item_method" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.item_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

#Método PUT para /items/{id} (Actualizar ítem)
resource "aws_api_gateway_method" "put_item_method" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.item_resource.id
  http_method   = "PUT"
  authorization = "NONE"
}

#Método DELETE para /items/{id} (Borrar ítem)
resource "aws_api_gateway_method" "delete_item_method" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.item_resource.id
  http_method   = "DELETE"
  authorization = "NONE"
}

##################################################Configurar la Integración de los Métodos con las Funciones Lambda

#Integración GET /items (Listar TODOS los ítems)
resource "aws_api_gateway_integration" "get_items_integration" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.get_items_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.LIST_ALL_Lambda.invoke_arn
}

#Integración POST /items (Registrar un nuevo ítem)
resource "aws_api_gateway_integration" "post_items_integration" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.post_items_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.CREATE_Lambda.invoke_arn
}

#Integración GET /items/{id} (Leer UN SOLO ítem)
resource "aws_api_gateway_integration" "get_item_integration" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.item_resource.id
  http_method = aws_api_gateway_method.get_item_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.READ-Function.invoke_arn
}

#Integración PUT /items/{id} (Actualizar ítem)
resource "aws_api_gateway_integration" "put_item_integration" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.item_resource.id
  http_method = aws_api_gateway_method.put_item_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.UPDATE-Function.invoke_arn
}

#Integración DELETE /items/{id} (Borrar ítem)
resource "aws_api_gateway_integration" "delete_item_integration" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.item_resource.id
  http_method = aws_api_gateway_method.delete_item_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.DELETE_Lambda.invoke_arn
}


############################################################6. Permisos para que API Gateway Invoca las Funciones Lambda
#Permisos para get_items (Listar TODOS los ítems)
resource "aws_lambda_permission" "allow_api_gateway_get_items" {
  statement_id  = "AllowAPIGatewayInvokeGetItems"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LIST_ALL_Lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.crud_api.execution_arn}/*/GET/items"
}


#Permisos para create_item (Registrar un nuevo ítem)
resource "aws_lambda_permission" "allow_api_gateway_post_items" {
  statement_id  = "AllowAPIGatewayInvokePostItems"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CREATE_Lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.crud_api.execution_arn}/*/POST/items"
}

#Permisos para get_item (Leer UN SOLO ítem)
resource "aws_lambda_permission" "allow_api_gateway_get_item" {
  statement_id  = "AllowAPIGatewayInvokeGetItem"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.READ-Function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.crud_api.execution_arn}/*/GET/items/*"
}

#Permisos para put_item (Actualizar ítem)
resource "aws_lambda_permission" "allow_api_gateway_put_item" {
  statement_id  = "AllowAPIGatewayInvokePutItem"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.UPDATE-Function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.crud_api.execution_arn}/*/PUT/items/*"
}

#Permisos para delete_item (Borrar ítem)
resource "aws_lambda_permission" "allow_api_gateway_delete_item" {
  statement_id  = "AllowAPIGatewayInvokeDeleteItem"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.DELETE_Lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.crud_api.execution_arn}/*/DELETE/items/*"
}

#Desplegar la API Gateway
resource "aws_api_gateway_deployment" "crud_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.get_items_integration,
    aws_api_gateway_integration.post_items_integration,
    aws_api_gateway_integration.get_item_integration,
    aws_api_gateway_integration.put_item_integration,
    aws_api_gateway_integration.delete_item_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  stage_name  = "production"

  lifecycle {
    create_before_destroy = true
  }
}

# Definir el Stage para la API Desplegada
# resource "aws_api_gateway_stage" "prod_stage" {
#   stage_name    = "prod"
#   rest_api_id   = aws_api_gateway_rest_api.crud_api.id
#   deployment_id = aws_api_gateway_deployment.crud_api_deployment.id

#   variables = {
#     lambdaAlias = "production"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

############################################# OUTPUTs
output "GET_and_POST_url" {
  value = "${aws_api_gateway_deployment.crud_api_deployment.invoke_url}${aws_api_gateway_resource.items_resource.path}"
}

output "GET_UPDATE_and_DELETE_url" {
  value = "${aws_api_gateway_deployment.crud_api_deployment.invoke_url}${aws_api_gateway_resource.item_resource.path}"
}