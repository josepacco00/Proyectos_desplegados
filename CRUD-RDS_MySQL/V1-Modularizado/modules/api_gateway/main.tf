resource "aws_api_gateway_rest_api" "crud_api" {
  name        = var.api_name
  description = "API para operaciones CRUD utilizando Lambda y DynamoDB"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "items_resource" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  parent_id   = aws_api_gateway_rest_api.crud_api.root_resource_id
  path_part   = var.path_api
}

resource "aws_api_gateway_method" "get_example" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.items_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_items_integration" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.get_example.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "allow_api_gateway_get_items" {
  statement_id  = "AllowAPIGatewayInvokeGetItems"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.crud_api.execution_arn}/*/${aws_api_gateway_method.get_example.http_method}${aws_api_gateway_resource.items_resource.path}"
}

resource "aws_api_gateway_stage" "production" {
  deployment_id = aws_api_gateway_deployment.crud_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  stage_name    = "production2"
}

resource "aws_api_gateway_deployment" "crud_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.get_items_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  
  lifecycle {
    create_before_destroy = true
  }
}