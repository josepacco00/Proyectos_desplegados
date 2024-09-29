# Sube el archivo ZIP de Pillow a S3
resource "random_string" "Bucket_Layer_pymysql" {
  length = 8
  special = false
  numeric = false
  upper = false
}

resource "aws_s3_bucket" "lambda_layers" {
  bucket = "proyect-ia-${random_string.Bucket_Layer_pymysql.result}"
  force_destroy = true
}

resource "aws_s3_object" "pymysql_layer_zip" {
  bucket = aws_s3_bucket.lambda_layers.bucket
  key    = "pymysql_layer.zip"
  source = "${path.module}/pymysql_layer.zip"  # Ruta local al archivo ZIP que creaste
}

# Crea el layer de Lambda
resource "aws_lambda_layer_version" "Layer_pymysql" {
  layer_name          = "Layer_pymysql"
  s3_bucket           = aws_s3_bucket.lambda_layers.bucket
  s3_key              = aws_s3_object.pymysql_layer_zip.key
  compatible_runtimes = ["python3.9"]  # Asegúrate de usar la misma versión de Python
  compatible_architectures = ["x86_64"]
}