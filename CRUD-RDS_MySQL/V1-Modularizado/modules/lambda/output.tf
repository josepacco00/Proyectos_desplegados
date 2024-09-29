output "function_name" {
  value = aws_lambda_function.jose-frank-proyect.function_name
  description = "El nombre de la función Lambda"
}

output "invoke_arn" {
  value = aws_lambda_function.jose-frank-proyect.invoke_arn
  description = "El ARN de invocación de la función Lambda"
}