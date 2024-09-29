data "archive_file" "UPDATE-Function" {
  type        = "zip"
  source_file = "UPDATE.py"
  output_path = "lambda_function_payload_${local.fourth_lambda_function_name}.zip"
}

# Extrae el primer elemento de la lista
locals {
  fourth_lambda_function_name = element(var.lambda_function_names, 3)
}

resource "aws_lambda_function" "UPDATE-Function" {
  filename      = "lambda_function_payload_${local.fourth_lambda_function_name}.zip"
  function_name = local.fourth_lambda_function_name
  role          = aws_iam_role.Role_for_Lambda.arn
  handler       = "UPDATE.lambda_handler"

  source_code_hash = data.archive_file.UPDATE-Function.output_base64sha256

  runtime = "python3.9"
  environment {
    variables = {
      TABLE_NAME = var.Table_DynamoDB_CRUD_Name
    }
  }
}

# {
#   "id": "123",
#   "data": "Updated data"
# }
