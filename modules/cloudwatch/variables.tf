// For Glue
variable "cw_log_group_glue_name" {
  type = string
  description = "Name for Glue Cloudwatch log group"
}

// For CloudTrail
variable "cw_lg_ct_insights_events_name" {
  type = string
  description = "Name for CloudTrail Cloudwatch insights log group"
}

variable "cw_lg_ct_global_events_name" {
  type = string
  description = "Name for CloudTrail Cloudwatch global log group"
}

// * kms module output
variable "kms_key_ct_arn" {
  type        = string
  description = "KMS ARN for encryption"
}

// * sns module output
variable "sns_topic_cw_arn" {
  type        = string
  description = "SNS ARN for alarm"
}

// For Lambda RDS Secrets Rotation
variable "cw_lg_lambda_rds_secrets_rotation_name" {
  type = string
  description = "Name for Lambda RDS secret rotation Cloudwatch log group"
}

// For ALB, WAF
variable "cw_lg_alb_waf_name" {
  type        = string
  description = "Name for ALB WAF Cloudwatch log group"
}

// For GuardDuty
variable "cw_event_rule_gd_name" {
  type = string
  description = "Name for GuardDuty Cloudwatch event rule"
}

variable "cw_event_rule_gd_desc" {
  type = string
  description = "Description for GuardDuty Cloudwatch event rule"
}

// * sns module output
variable "sns_topic_gd_findings_arn" {
  type = string
  description = "ARN for SNS topic"
}