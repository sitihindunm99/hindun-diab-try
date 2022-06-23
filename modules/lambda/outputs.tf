output "sm_rotation_lambda_function_arn" {
  value = aws_lambda_function.lambda-rds-secrets-rotation.arn
}

output "sm_rotation_lambda_function_name" {
  value = aws_lambda_function.lambda-rds-secrets-rotation.function_name
}

output "sm_rotation_lambda_function_iam_role_name" {
  value = aws_lambda_function.lambda-rds-secrets-rotation.role
}