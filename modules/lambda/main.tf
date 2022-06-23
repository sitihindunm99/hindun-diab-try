#////////////////////////////////////////////////////////////////////////////////////////////////
# DESCRIPTION       : Lambda Function for RDS Secrets Rotation
#////////////////////////////////////////////////////////////////////////////////////////////////

// Create lambda function for rds password rotation
resource "aws_lambda_function" "lambda-rds-secrets-rotation" {
  function_name = var.lambda_rds_secrets_rotation_function_name
  description   = var.lambda_rds_secrets_rotation_description
  handler       = var.lambda_rds_secrets_rotation_handler
  role          = var.lambda_rds_secrets_rotation_role

  memory_size = var.lambda_rds_secrets_rotation_memory_size
  timeout     = var.lambda_rds_secrets_rotation_timeout

  filename         = var.lambda_rds_secrets_rotation_filename
  source_code_hash = var.lambda_rds_secrets_rotation_filename
  runtime          = var.lambda_rds_secrets_rotation_runtime

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.sg_ids
  }

  environment {
    variables = var.lambda_rds_secrets_rotation_function_env_var
  }
}

// Grant secrets manager permission to run lambda
resource "aws_lambda_permission" "lambda-permission-grant-sm" {
  statement_id  = "SecretsManagerRDSMySQLRotationSingleUser"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-rds-secrets-rotation.function_name
  principal     = "secretsmanager.amazonaws.com"
}