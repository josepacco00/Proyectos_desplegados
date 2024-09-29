module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "database" {
  source = "./modules/database"

  private_subnet_ids   = module.networking.private_subnet_ids
  db_security_group_id = [module.networking.db_security_group_id]
  project_name         = var.project_name
  db_config            = var.db_config
}

module "security" {
  source = "./modules/security"

  region                  = var.region
  lambda_name             = var.lambda_name
  rds_instance_identifier = module.database.db_identifier
}

module "lambda" {
  source = "./modules/lambda"

  lambda_name          = var.lambda_name
  Role_for_Lambda      = module.security.Role_for_Lambda
  private_subnet_ids   = module.networking.private_subnet_ids
  db_security_group_id = [module.networking.db_security_group_id]

  db_endpoint = module.database.db_endpoint
  db_name     = module.database.db_name
  db_username = module.database.db_username
  db_password = module.database.db_password
}

module "api_gateway" {
  source = "./modules/api_gateway"  # Asegúrate de que esta ruta sea correcta

  api_name = var.api_name
  path_api = var.path_api
  lambda_function_name = module.lambda.function_name
  lambda_invoke_arn = module.lambda.invoke_arn
}