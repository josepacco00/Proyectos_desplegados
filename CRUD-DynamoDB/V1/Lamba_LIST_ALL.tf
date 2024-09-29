data "archive_file" "LIST_ALL_Lambda" {
  type        = "zip"
  source_file = "LIST_ALL.py"
  output_path = "lambda_function_payload_${local.six_lambda_function_name}.zip"
}

# Extrae el primer elemento de la lista
locals {
  six_lambda_function_name = element(var.lambda_function_names, 5)
}

resource "aws_lambda_function" "LIST_ALL_Lambda" {
  filename      = "lambda_function_payload_${local.six_lambda_function_name}.zip"
  function_name = local.six_lambda_function_name
  role          = aws_iam_role.Role_for_Lambda.arn
  handler       = "LIST_ALL.lambda_handler"

  source_code_hash = data.archive_file.LIST_ALL_Lambda.output_base64sha256

  runtime = "python3.9"
  environment {
    variables = {
      TABLE_NAME = var.Table_DynamoDB_CRUD_Name
    }
  }
}