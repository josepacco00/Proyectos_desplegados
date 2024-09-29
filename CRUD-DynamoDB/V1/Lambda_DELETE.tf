data "archive_file" "DELETE_Lambda" {
  type        = "zip"
  source_file = "DELETE.py"
  output_path = "lambda_function_payload_${local.five_lambda_function_name}.zip"
}

# Extrae el primer elemento de la lista
locals {
  five_lambda_function_name = element(var.lambda_function_names, 4)
}

resource "aws_lambda_function" "DELETE_Lambda" {
  filename      = "lambda_function_payload_${local.five_lambda_function_name}.zip"
  function_name = local.five_lambda_function_name
  role          = aws_iam_role.Role_for_Lambda.arn
  handler       = "DELETE.lambda_handler"

  source_code_hash = data.archive_file.DELETE_Lambda.output_base64sha256

  runtime = "python3.9"
  environment {
    variables = {
      TABLE_NAME = var.Table_DynamoDB_CRUD_Name
    }
  }
}