// modules/database/main.tf
####################################################################
resource "aws_db_subnet_group" "db_subnet_group" {
    name = "${var.project_name}-db-subnet-group"
    subnet_ids = var.private_subnet_ids
}

# Obtener parámetros de Parameter Store
data "aws_ssm_parameter" "db_name" {
  name = "/myapp/database/name"
  with_decryption = true
}

data "aws_ssm_parameter" "db_username" {
  name = "/myapp/database/username" 
  with_decryption = true
}

data "aws_ssm_parameter" "db_password" {
  name = "/myapp/database/password"
  with_decryption = true
}

# Instancia RDS
resource "aws_db_instance" "default" {
  identifier           = var.db_config.identifier
  allocated_storage    = var.db_config.allocated_storage
  storage_type         = var.db_config.storage_type
  engine               = var.db_config.engine
  engine_version       = var.db_config.engine_version
  instance_class       = var.db_config.instance_class
  db_name              = data.aws_ssm_parameter.db_name.value
  username             = data.aws_ssm_parameter.db_username.value
  password             = data.aws_ssm_parameter.db_password.value
  parameter_group_name = var.db_config.parameter_group_name
  skip_final_snapshot  = true
  auto_minor_version_upgrade  = false
  
  vpc_security_group_ids = var.db_security_group_id
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  
  publicly_accessible    = false
  
  tags = {
    Name = var.tags_Name_BD
  }
}

