variable "project_name" {
  description = "Name of the project"
  type        = string
  default = "LMS-Proyect"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default = "244.178.44.111/16"
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
