// overall
variable region {
  type        = string
  description = "Region to deploy AWS resources"
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Name of project"
  type        = string
}

variable "account_id" {
  description = "Account ID"
  type        = string
}


// iam
variable "iam_permission_boundary" {
  type        = string
  description = "Permission boundary for IAM role creation"
}

variable "iam_role_transfer_name" {
  type        = string
  description = "Transfer IAM role name"
}

variable "iam_role_transfer_managed_policy_arns" {
  type        = list(string)
  description = "Transfer managed policies"
}

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

variable "iam_role_glue_name" {
  type        = string
  description = "Glue IAM role name"
}

variable "iam_role_glue_managed_policy_arns" {
  type        = list(string)
  description = "Glue managed policies"
}

variable "iam_role_sm_name" {
  type        = string
  description = "Sagemaker IAM role name"
}

variable "iam_role_sm_managed_policy_arns" {
  type        = list(string)
  description = "Sagemaker IAM managed policies"
}

variable "iam_role_cw_name" {
  type        = string
  description = "CloudWatch IAM role name"
}

variable "iam_role_cw_lambda_rds_secrets_function_name" {
  type        = string
  description = "Function Name for RDS Secrets Rotation Lambda"
}


// vpc
variable "sn_alb_vpc_id" {
  type        = string
  description = "GCC created VPC id"
}

variable "sn_alb_availability_zone" {
  type        = string
  description = "ALB subnet availaibility zone"
}

variable "sn_alb_cidr_block" {
  type        = string
  description = "CIDR block range of subnet"
}

variable "sn_alb2_vpc_id" {
  type        = string
  description = "GCC created VPC id"
}

variable "sn_alb2_availability_zone" {
  type        = string
  description = "ALB2 subnet availaibility zone"
}

variable "sn_alb2_cidr_block" {
  type        = string
  description = "CIDR block range of subnet"
}

variable "alb_tier_name" {
  type        = string
  description = "Name of the Tier"
}

variable "sn_transfer_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "sn_transfer_auto_assign_ip" {
  description = "Indicates whether to auto-assign public ip"
  type        = bool
  default     = false
}

variable "sn_transfer_cidr_block" {
  description = "List of cidr ranges to be used in the subnets creation"
  type        = string
}

variable "transfer_tier_name" {
  description = "Name of the Tier"
  type        = string
  default     = null
}

variable "sn_ec2_harden_default_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "sn_ec2_harden_default_auto_assign_ip" {
  description = "Indicates whether to auto-assign public ip"
  type        = bool
  default     = false
}

variable "sn_ec2_harden_default_availability_zone" {
  type        = string
  description = "EC2 subnet availaibility zone"
}

variable "sn_ec2_harden_default_cidr_block" {
  description = "List of cidr ranges to be used in the subnets creation"
  type        = string
}

variable "ec2_tier_name" {
  description = "Name of the Tier"
  type        = string
  default     = null
}

variable "sn_ec2_nginx_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "sn_ec2_nginx_auto_assign_ip" {
  description = "Indicates whether to auto-assign public ip"
  type        = bool
  default     = false
}

variable "sn_ec2_nginx_availability_zone" {
  type        = string
  description = "EC2 subnet availaibility zone"
}

variable "sn_ec2_nginx_cidr_block" {
  description = "List of cidr ranges to be used in the subnets creation"
  type        = string
}

variable "sn_db_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "sn_db_auto_assign_ip" {
  description = "Indicates whether to auto-assign public ip"
  type        = bool
  default     = false
}

variable "sn_db_az_list" {
  description = "Define the AZs for each subnet block"
  type        = list(string)
}

variable "sn_db_cidr_block" {
  description = "List of cidr ranges to be used in the subnets creation"
  type        = list(string)
}

variable "sg_ec2_harden_default_name" {
  type = string
  description = "EC2 security group name"
}

variable "sg_ec2_harden_default_vpc_id" {
  type = string
  description = "VPC ID"
}

variable "sg_ec2_harden_default_internet_jumphost_ip" {
  type = string
  description = "Allow ssh from internet jumphost"
}

variable "sg_ec2_harden_default_intranet_jumphost_ip" {
  type = string
  description = "Allow ssh from intranet jumphost"
}

variable "sg_ec2_nginx_name" {
  type = string
  description = "EC2 security group name"
}

variable "sg_ec2_nginx_vpc_id" {
  type = string
  description = "VPC ID"
}

variable "sg_ec2_nginx_internet_jumphost_ip" {
  type = string
  description = "Allow ssh from internet jumphost"
}

variable "sg_ec2_nginx_intranet_jumphost_ip" {
  type = string
  description = "Allow ssh from intranet jumphost"
}

variable "sg_db_name" {
  description = "Name for RDS security group"
  type        = string
}

variable "sg_db_vpc_id" {
  description = "VPC ID of security group"
  type        = string
}

variable "sg_db_allowed_ips" {
  description = "Allowed IPs to access RDS instance"
  type        = list(string)
}

variable "sg_lambda_rds_rotation_name"{
  description = "Lambda RDS Rotation security group name"
  type        = string
}

variable "sg_lambda_rds_rotation_vpc_id" {
  description = "VPC ID"
  type        = string
}

// s3
variable "s3_main_bucket" {
  type        = string
  description = "Name of bucket"
}

variable "s3_raw_folder_key" {
  type        = string
  description = "Folder path for raw bucket"
}

variable "s3_proc_folder_key" {
  type        = string
  description = "Folder path for processed bucket"
}

variable "s3_script_folder_key" {
  type        = string
  description = "Folder path for Glue scripts"
}

variable "s3_csv_upload_key" {
  type        = string
  description = "S3 key for csv file"
}

variable "s3_csv_upload_source" {
  type        = string
  description = "Local file path for csv file"
}

variable "s3_glue_script_upload_key" {
  type        = string
  description = "S3 key for glue script"
}

variable "s3_glue_script_upload_source" {
  type        = string
  description = "Local file path for Glue script"
}

// S3 bucket for cloudtrail insights events
variable "s3_ct_insights_bucket" {
  type        = string
  description = "Name of bucket for insights Cloudtrail"
}

variable "s3_ct_insights_bucket_logs" {
  type        = string
  description = "Name of logging bucket for insights Cloudtrail"
}

variable "s3_ct_global_bucket" {
  type        = string
  description = "Name of bucket for global Cloudtrail"
}

variable "s3_alb_access_logs_name" {
  type        = string
  description = "Name of s3 bucket for alb access logs"
}


// lambda
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

variable "lambda_rds_secrets_rotation_memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
}

variable "lambda_rds_secrets_rotation_timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  type        = number
}

variable "lambda_rds_secrets_rotation_runtime" {
  description = "Identifier of the function's runtime"
  type        = string
}

variable "lambda_rds_secrets_rotation_function_env_var" {
  description = "Environment variables for Lambda function"
  type        = map(string)
  default     = { "null" = null }
}

// cloudwatch
variable "cw_log_group_glue_name" {
  type        = string
  description = "Name for Glue Cloudwatch log group"
}

variable "cw_lg_ct_insights_events_name" {
  type = string
  description = "Name for CloudTrail Cloudwatch insights log group"
}

variable "cw_lg_ct_global_events_name" {
  type = string
  description = "Name for CloudTrail Cloudwatch global log group"
}

variable "cw_lg_lambda_rds_secrets_rotation_name" {
  type        = string
  description = "Name for Lambda RDS secret rotation Cloudwatch log group"
}

variable "cw_lg_alb_waf_name" {
  type        = string
  description = "Name for ALB WAF Cloudwatch log group"
}

variable "cw_event_rule_gd_name" {
  type        = string
  description = "Name for GuardDuty Cloudwatch event rule"
}

variable "cw_event_rule_gd_desc" {
  type        = string
  description = "Description for GuardDuty Cloudwatch event rule"
}


// cloudtrail
variable "ct_insights_name" {
  type        = string
  description = "Name of bucket to store CloudTrail Logs"
}

// sns
variable "sns_topic_gd_findings_name" {
  type        = string
  description = "Name for GuardDuty SNS topic"
}

variable "sns_topic_sub_gd_findings_endpoint" {
  type        = string
  description = "Endpoint (email address) for GuardDuty subscription"
}

variable "sns_topic_config_findings_name" {
  type = string
  description = "Name for Config SNS topic"
}

variable "sns_topic_sub_config_findings_endpoint" {
  type = string
  description = "Endpoint (email address) for Config subscription"
}

variable "sns_topic_cw_name" {
  type = string
  description = "Name for Config SNS topic"
}

variable "sns_topic_sub_cw_endpoint" {
  type = string
  description = "Endpoint (email address) for CloudWatch subscription"
}