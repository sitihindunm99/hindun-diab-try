variable "ct_insights_name" {
  type = string
  description = "Name of bucket to store CloudTrail Logs"
}

// * s3 module output
variable "s3_ct_insights_id" {
  type = string
  description = "Bucket Name for CloudTrail insights log group"
}

variable "s3_ct_global_id" {
  type = string
  description = "Bucket Name for CloudTrail global log group"
}

// * kms module output
variable "kms_key_ct_arn" {
  description = "KMS ARN for encryption"
  type        = string
}

// * cloudwatch module output
variable "cw_lg_ct_insights_events_arn" {
  type = string
  description = "ARN of cloudwatch log group"
}

variable "cw_lg_ct_global_events_arn" {
  type = string
  description = "ARN of cloudwatch log group"
}

// * iam module output
variable "iam_role_cw_arn" {
  type = string
  description = "ARN of cloudwatch iam role"
}

variable "ct_insights_advanced_event_selector" {
  description = "Specifies an advanced event selector for enabling data event logging"
  type        = list(any)
}