data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/index1.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "jose-frank-proyect" {
  filename      = data.archive_file.lambda.output_path
  function_name = var.lambda_name
  role          = var.Role_for_Lambda
  handler       = "index1.lambda_handler"
  runtime = "python3.9"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  layers = [aws_lambda_layer_version.Layer_pymysql.arn]

  vpc_config {
    subnet_ids         = var.private_subnet_ids  # Usa las mismas subnets que tu RDS
    security_group_ids = var.db_security_group_id  # Usa el mismo security group que tu RDS
  }

  environment {
    variables = {
      DB_HOST     = var.db_endpoint
      DB_NAME     = var.db_name
      DB_USERNAME = var.db_username
      DB_PASSWORD = var.db_password
    }
}
}
# resource "aws_lambda_function" "rds_connection_test" {
#   filename      = "lambda_function.zip"  # Asegúrate de crear este archivo ZIP con tu código Python
#   function_name = "rds-connection-test"
#   role          = aws_iam_role.lambda_role.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = "python3.8"

#   vpc_config {
#     subnet_ids         = var.private_subnet_ids  # Usa las mismas subnets que tu RDS
#     security_group_ids = var.db_security_group_id  # Usa el mismo security group que tu RDS
#   }

#   environment {
#     variables = {
#       DB_HOST     = aws_db_instance.default.endpoint
#       DB_NAME     = data.aws_ssm_parameter.db_name.value
#       DB_USERNAME = data.aws_ssm_parameter.db_username.value
#       DB_PASSWORD = data.aws_ssm_parameter.db_password.value
#     }
#   }
# }