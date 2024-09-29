#1° paso: definir la politica

resource "aws_iam_policy" "Policy_Cloud_Watch_Logs" {
  for_each = toset(var.lambda_function_names)
  
  name        = "Policy_${each.value}"
  description = "Politica que permitira enviar logs a CloudWatch desde una funcion lambda"
  policy = data.aws_iam_policy_document.Policy_Cloud_Watch_Logs_for_Lambda[each.key].json
}
# resource "aws_iam_policy" "lambda_logging_policy" {
#   for_each = toset(var.lambda_function_names)
  
#   name        = "${each.value}_lambda_logging_policy"
#   description = "Policy to allow logging for Lambda function ${each.value}"
#   policy      = data.aws_iam_policy_document.policy_cloud_watch_logs_for_lambda[each.key].json
# }

#2° paso: definir el rol
resource "aws_iam_role" "Role_for_Lambda" {
  name = "Role_for_Lambda"
  description = "Rol a asociar a la funcion lambda"
  assume_role_policy = data.aws_iam_policy_document.Policy_Assume_Rol_for_Lambda.json
}

#3° paso: Asociar la politica con el rol
resource "aws_iam_role_policy_attachment" "Attach_Policy_Cloud_Watch_Logs_TO_Role_for_Lambda" {
    for_each = toset(var.lambda_function_names)

    role = aws_iam_role.Role_for_Lambda.name
    policy_arn = aws_iam_policy.Policy_Cloud_Watch_Logs[each.key].arn
}
# resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attachment" {
#   for_each = toset(var.lambda_function_names)
  
#   policy_arn = aws_iam_policy.lambda_logging_policy[each.key].arn
#   role      = aws_iam_role.lambda_role.name
# }


resource "aws_iam_policy" "Policy_DynamoDB_CRUD" {
  name        = "Policy_DynamoDB_CRUD"
  description = "Politica que permitira acceder a la base de datos DynamoDB"
  policy      = data.aws_iam_policy_document.Policy_DynamoDB_CRUD.json
}

resource "aws_iam_role_policy_attachment" "Attach_Policy_DynamoDB_CRUD_TO_Role_for_Lambda" {
    role = aws_iam_role.Role_for_Lambda.name
    policy_arn = aws_iam_policy.Policy_DynamoDB_CRUD.arn
}


