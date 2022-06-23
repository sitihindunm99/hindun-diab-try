variable "lambda_rds_secrets_rotation_function_name" {
  description = "Name of Lambda function"
  type        = string
}

variable "lambda_rds_secrets_rotation_description" {
  description = "Description of Lambda function"
  type        = string
  default     = null
}

variable "lambda_rds_secrets_rotation_handler" {
  description = "Function entrypoint in your code"
  type        = string
}

variable "lambda_rds_secrets_rotation_role" {
  description = "Lambda IAM role"
  type        = string
}

variable "lambda_rds_secrets_rotation_memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
}

variable "lambda_rds_secrets_rotation_timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  type        = number
}

variable "lambda_rds_secrets_rotation_filename" {
  description = "Path to the function's deployment package within the local filesystem"
  type        = string
}

variable "lambda_rds_secrets_rotation_runtime" {
  description = "Identifier of the function's runtime"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "sg_ids" {
  description = "List of Security Group IDs"
  type        = list(string)
}

variable "lambda_rds_secrets_rotation_function_env_var" {
  description = "Environment variables for Lambda function"
  type        = map(string)
  default     = { "null" = null }
}