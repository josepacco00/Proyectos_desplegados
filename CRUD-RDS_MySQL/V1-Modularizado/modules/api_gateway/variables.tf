variable "api_name" {
    type = string
    description = "Nombre de la API Gateway"
}

variable "path_api" {
    type = string
    description = "Path de la API Gateway"
}

variable "lambda_invoke_arn" {
    type = string
    description = "Invoke ARN de la lambda function"
}

variable "lambda_function_name" {
    type = string
    description = "Nombre de la lambda function"
}

