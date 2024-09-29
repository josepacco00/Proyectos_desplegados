resource "aws_dynamodb_table" "vehicle_recognition_table" {
  name           = var.Table_DynamoDB
  billing_mode   = "PAY_PER_REQUEST" 
  hash_key       = "ImageID"

  attribute {
    name = "ImageID"
    type = "S" # S = String
  }

}
