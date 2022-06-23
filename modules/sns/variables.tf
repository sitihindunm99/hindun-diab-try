// For GuardDuty
variable "sns_topic_gd_findings_name" {
  type = string
  description = "Name for GuardDuty SNS topic"
}

variable "sns_topic_sub_gd_findings_endpoint" {
  type = string
  description = "Endpoint (email address) for GuardDuty subscription"
}

// For Config
variable "sns_topic_config_findings_name" {
  type = string
  description = "Name for Config SNS topic"
}

variable "sns_topic_sub_config_findings_endpoint" {
  type = string
  description = "Endpoint (email address) for Config subscription"
}

// For CloudWatch
variable "sns_topic_cw_name" {
  type = string
  description = "Name for Config SNS topic"
}

variable "sns_topic_sub_cw_endpoint" {
  type = string
  description = "Endpoint (email address) for CloudWatch subscription"
}