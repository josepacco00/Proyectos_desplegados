data "archive_file" "READ-Function" {
  type        = "zip"
  source_file = "READ.py"
  output_path = "lambda_function_payload_${local.third_lambda_function_name}.zip"
}

# Extrae el primer elemento de la lista
locals {
  third_lambda_function_name = element(var.lambda_function_names, 2)
}

resource "aws_lambda_function" "READ-Function" {
  filename      = "lambda_function_payload_${local.third_lambda_function_name}.zip"
  function_name = local.third_lambda_function_name
  role          = aws_iam_role.Role_for_Lambda.arn
  handler       = "READ.lambda_handler"

  source_code_hash = data.archive_file.READ-Function.output_base64sha256

  runtime = "python3.9"
  environment {
    variables = {
      TABLE_NAME = var.Table_DynamoDB_CRUD_Name
    }
  }
}