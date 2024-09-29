data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "Lambda-Proyect-IA" {
  filename      = "lambda_function_payload.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.Role_Lambda.arn
  handler       = "index.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"
  timeout = 300

  layers = [aws_lambda_layer_version.pillow_layer.arn]
  environment {
    variables = {
      TABLE_NAME = var.Table_DynamoDB #TABLE_NAME = os.environ['TABLE_NAME']
      S3_BUCKET_NAME = aws_s3_bucket.Bucket_IA.bucket
    }
  }
}

#probar que lambda recibe el evento de PUT-object de S3

######## Segunda funcion lambda para realizar el get de la imagen

data "archive_file" "lambda2" {
  type        = "zip"
  source_file = "get.py"
  output_path = "lambda2_function_payload.zip"
}

resource "aws_lambda_function" "Lambda-Proyect-IA-GET" {
  filename      = "lambda2_function_payload.zip"
  function_name = var.lambda_GET_name
  role          = aws_iam_role.Role_lambda_GET.arn
  handler       = "get.lambda_handler"

  source_code_hash = data.archive_file.lambda2.output_base64sha256

  runtime = "python3.9"
  environment {
    variables = {
      TABLE_NAME = var.Table_DynamoDB #TABLE_NAME = os.environ['TABLE_NAME']
      S3_BUCKET_NAME = aws_s3_bucket.Bucket_IA.bucket
    }
  }
}