region = "us-east-2"

global_tags = {
  "User"         = "Jose"
  "Proyect_Name" = "SML_Proyect"
  "Region"       = "us-east-2"
}

################################# variables_network

project_name = "lms-proyect"

vpc_cidr = "244.178.0.0/16"

private_subnet_cidrs = ["244.178.0.0/24", "244.178.1.0/24"]

availability_zones = ["us-east-2a", "us-east-2b"]

################################ variables_database

db_config = {
  identifier           = "mydbjose"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql8.0"
}

tags_Name_BD = "MyRDS"

############################### variables_security


############################### variables_lambda

lambda_name = "jose-frank-proyect"

############################## variables_api_gateway

api_name = "jose_api"

path_api = "test"