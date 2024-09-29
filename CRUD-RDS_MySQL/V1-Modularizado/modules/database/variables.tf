//modules/database/variables.tf
variable "project_name" {
    description = "Name of the project"
    type        = string
    default = "LMS-Proyect"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "The ID of the database security group"
  type        = set(string)
}

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
    
  default = {
    identifier           = "mydbjose"
    allocated_storage    = 20
    storage_type         = "gp3"
    engine               = "mysql"
    engine_version       = "8.0.35"
    instance_class       = "db.t3.micro"
    parameter_group_name = "default.mysql8.0"
  }
}

#############

variable "tags_Name_BD" {
    description = "Name of the database"
    type        = string
    default = "MyRDS"
}

