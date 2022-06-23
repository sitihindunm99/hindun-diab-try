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
  description = "Folder path for glue scripts"
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
  description = "Local file path for glue script"
}

// For CloudTrail
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

// * kms module output
variable "kms_key_db_arn" {
  description = "KMS ARN for encryption"
  type        = string
}

variable "kms_key_ct_arn" {
  description = "KMS ARN for encryption"
  type        = string
}

// For ALB
variable "s3_alb_access_logs_name" {
  type        = string
  description = "Name of s3 bucket for alb access logs"
}
