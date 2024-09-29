variable "lambda_name" {
    type = string
    description = "Name of the lambda function"
}

variable "Role_for_Lambda" {
    type = string
    description = "Role for lambda function"
}

variable "private_subnet_ids" {
    type = list(string)
    description = "List of private subnet ids"
    # default = ["subnet-0de8a8df80f0bf1ed", "subnet-00b3d6f1f4ac2f618"]
}

variable "db_security_group_id" {
    type = list(string)
    description = "DB security group id"
    # default = ["sg-0e9987137f14ea68a"]
}

########## variables enviroments
variable "db_endpoint" {
    type = string
    description = "DB endpoint"
}

variable "db_name" {
    type = string
    description = "DB name"
}

variable "db_username" {
    type = string
    description = "DB username"
}

variable "db_password" {
    type = string
    description = "DB password"
}