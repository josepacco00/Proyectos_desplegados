resource "aws_dynamodb_table" "CRUD_table" {
  name           = var.Table_DynamoDB_CRUD_Name     # Nombre de la tabla
  billing_mode    = "PAY_PER_REQUEST" # Modo de facturación para la capa gratuita
  hash_key        = "id"              # Clave primaria (hash key)
  attribute {
    name = "id"
    type = "S"                       # Tipo de dato para la clave primaria, en este caso String (S)
  }
}
