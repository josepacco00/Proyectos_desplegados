variable "region" {
  type        = string
  description = "Region de despliegue del proyecto"
}

variable "global_tags" {
  type        = map(any)
  description = "Tags globales"
}
########################################## variables_network
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["244.178.0.0/24", "244.178.1.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

############################################ variables_database

variable "db_config" {
  type = object({
    identifier           = string
    allocated_storage    = number
    storage_type         = string
    engine               = string
    engine_version       = string
    instance_class       = string
    parameter_group_name = string
  })
  description = "Configuración de la base de datos"
}

variable "tags_Name_BD" {
  description = "Name of the database"
  type        = string
}

############################################ variables_security


############################################ variables_lambda

variable "lambda_name" {
  type        = string
  description = "Name of the lambda function"
}

########################################### variables_api_gateway

variable "api_name" {
  type        = string
  description = "Nombre de la API Gateway"
}

variable "path_api" {
  type        = string
  description = "Path de la API Gateway"
}