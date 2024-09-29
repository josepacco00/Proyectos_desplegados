data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.py"
  output_path = "lambda_function_payload_${local.first_lambda_function_name}.zip"
}

# Extrae el primer elemento de la lista
locals {
  first_lambda_function_name = element(var.lambda_function_names, 0)
}

resource "aws_lambda_function" "Test_Connection_DynamoDB" {
  filename      = "lambda_function_payload_${local.first_lambda_function_name}.zip"
  function_name = local.first_lambda_function_name
  role          = aws_iam_role.Role_for_Lambda.arn
  handler       = "index.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"
  environment {
    variables = {
      TABLE_NAME = var.Table_DynamoDB_CRUD_Name
    }
  }
}