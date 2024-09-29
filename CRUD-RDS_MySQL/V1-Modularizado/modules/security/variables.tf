variable "region" {
    type = string
    description = "Region de despliegue del proyecto"
}

variable "lambda_name" {
    type = string
    description = "Name of the lambda function"
}

variable "rds_instance_identifier" {
    type = string
    description = "Name of the RDS instance"
}
