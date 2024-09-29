# Sube el archivo ZIP de Pillow a S3
resource "random_string" "Bucket_Pillow_Layer" {
  length = 8
  special = false
  numeric = false
  upper = false
}

resource "aws_s3_bucket" "lambda_layers" {
  bucket = "proyect-ia-${random_string.Bucket_Pillow_Layer.result}"
  force_destroy = true
}

resource "aws_s3_object" "pillow_layer_zip" {
  bucket = aws_s3_bucket.lambda_layers.bucket
  key    = "pillow_layer.zip"
  source = "pillow_layer.zip"  # Ruta local al archivo ZIP que creaste
}

# Crea el layer de Lambda
resource "aws_lambda_layer_version" "pillow_layer" {
  layer_name          = "pillow-layer"
  s3_bucket           = aws_s3_bucket.lambda_layers.bucket
  s3_key              = aws_s3_object.pillow_layer_zip.key
  compatible_runtimes = ["python3.9"]  # Asegúrate de usar la misma versión de Python
  compatible_architectures = ["x86_64"]
}

# mkdir python
# pip install pillow -t python/
# zip -r pillow_layer.zip python --> linux
# Compress-Archive -Path python -DestinationPath "pillow_layer.zip" --> windows
#pillow_layer