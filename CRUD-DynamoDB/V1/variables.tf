variable "region" {
    type = string
    description = "Región de AWS en donde se desplegara el proyecto"
}

variable "global_tags" {
    type = map(string)
    description = "Tags globales para todos los recursos"
}

# variable "lambda_function_name" {
#     type = string
#     description = "Nombre de la primera function lambda"
# }
variable "lambda_function_names" {
  type = list(string)
  description = "Lista de nombres de las funciones lambda"
}


variable "Table_DynamoDB_CRUD_Name"{
    type = string
    description = "Nombre de la tabla DynamoDB_CRUD"
}