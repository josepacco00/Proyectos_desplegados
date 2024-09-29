resource "random_string" "Bucket_name" {
  length = 8
  special = false
  numeric = false
  upper = false
}

resource "aws_s3_bucket" "Bucket_IA" {
  bucket = "proyect-ia-${random_string.Bucket_name.result}"
  force_destroy = true
}

####################################################################

resource "aws_lambda_permission" "s3_to_lambda" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda-Proyect-IA.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.Bucket_IA.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.Bucket_IA.bucket
  lambda_function {
    events = ["s3:ObjectCreated:*"]
    lambda_function_arn = aws_lambda_function.Lambda-Proyect-IA.arn
  }
  depends_on = [
    aws_lambda_permission.s3_to_lambda
  ]
}








# output "name" {
#     value = random_string.Bucket_name.result
# }