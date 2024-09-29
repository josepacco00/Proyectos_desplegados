data "archive_file" "CREATE_Lambda" {
  type        = "zip"
  source_file = "CREATE.py"
  output_path = "lambda_function_payload_${local.second_lambda_function_name}.zip"
}

# Extrae el primer elemento de la lista
locals {
  second_lambda_function_name = element(var.lambda_function_names, 1)
}

resource "aws_lambda_function" "CREATE_Lambda" {
  filename      = "lambda_function_payload_${local.second_lambda_function_name}.zip"
  function_name = local.second_lambda_function_name
  role          = aws_iam_role.Role_for_Lambda.arn
  handler       = "CREATE.lambda_handler"

  source_code_hash = data.archive_file.CREATE_Lambda.output_base64sha256

  runtime = "python3.9"
  environment {
    variables = {
      TABLE_NAME = var.Table_DynamoDB_CRUD_Name
    }
  }
}