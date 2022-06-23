// Overall Variables
variable "iam_permission_boundary" {
  type        = string
  description = "Permission boundary for IAM role creation"
}

// For Transfer
variable "iam_role_transfer_name" {
  type        = string
  description = "Transfer IAM role name"
}

variable "iam_role_transfer_managed_policy_arns" {
  type        = list(string)
  description = "Transfer managed policies"
}

// For EC2
variable "iam_role_ec2_harden_default_name" {
  type        = string
  description = "EC2 IAM role name harden default ec2"
}

variable "iam_role_ec2_harden_default_managed_policy_arns" {
  type        = list(string)
  description = "EC2 managed policies for harden default ec2"
}

variable "iam_instance_profile_ec2_harden_default_name" {
  type        = string
  description = "Name of instance profile for harden default ec2"
}

variable "iam_role_ec2_nginx_name" {
  type        = string
  description = "EC2 IAM role name for nginx ec2"
}

variable "iam_role_ec2_nginx_managed_policy_arns" {
  type        = list(string)
  description = "EC2 managed policies for nginx ec2"
}

variable "iam_instance_profile_ec2_nginx_name" {
  type        = string
  description = "Name of instance profile for nginx ec2"
}


// For Glue
variable "iam_role_glue_name" {
  type        = string
  description = "Glue IAM role name"
}

variable "iam_role_glue_managed_policy_arns" {
  type        = list(string)
  description = "Glue managed policies"
}

// For Sagemaker
variable "iam_role_sm_name" {
  type        = string
  description = "Sagemaker IAM role name"
}

variable "iam_role_sm_managed_policy_arns" {
  type        = list(string)
  description = "Sagemaker IAM managed policies"
}

// For CloudWatch
variable "iam_role_cw_name" {
  type        = string
  description = "CloudWatch IAM role name"
}

variable "cw_lg_ct_insights_events_arn" {
  type        = string
  description = "CloudWatch IAM ARN"
}

// For Lambda RDS Secrets Rotation
variable "iam_role_cw_lambda_rds_secrets_function_name" {
  type        = string
  description = "Function Name for RDS Secrets Rotation Lambda"
}

variable "cw_lg_lambda_rds_secrets_rotation_arn" {
  type        = string
  description = "RDS Secrets Rotation Lambda CloudWatch IAM ARN"
}

variable "iam_policy_rds_secret_arn" {
  type        = string
  description = "Secret ARN"
}

variable "iam_policy_rds_secret_rotation_lambda_arn" {
  type        = string
  description = "Lambda rotation ARN"
}