module "iam" {
  source = "./modules/iam"

  iam_permission_boundary = var.iam_permission_boundary

  iam_role_transfer_name                = var.iam_role_transfer_name
  iam_role_transfer_managed_policy_arns = var.iam_role_transfer_managed_policy_arns

  iam_role_glue_name                = var.iam_role_glue_name
  iam_role_glue_managed_policy_arns = var.iam_role_glue_managed_policy_arns

  iam_role_ec2_harden_default_name                 = var.iam_role_ec2_harden_default_name
  iam_role_ec2_harden_default_managed_policy_arns  = var.iam_role_ec2_harden_default_managed_policy_arns
  iam_instance_profile_ec2_harden_default_name     = var.iam_instance_profile_ec2_harden_default_name

  iam_role_ec2_nginx_name                = var.iam_role_ec2_nginx_name
  iam_role_ec2_nginx_managed_policy_arns = var.iam_role_ec2_nginx_managed_policy_arns
  iam_instance_profile_ec2_nginx_name    = var.iam_instance_profile_ec2_nginx_name

  iam_role_sm_name                  = var.iam_role_sm_name
  iam_role_sm_managed_policy_arns   = var.iam_role_sm_managed_policy_arns

  iam_role_cw_name             = var.iam_role_cw_name
  cw_lg_ct_insights_events_arn = module.cloudwatch.cw_lg_ct_insights_events_arn

  iam_role_cw_lambda_rds_secrets_function_name = var.iam_role_cw_lambda_rds_secrets_function_name
  cw_lg_lambda_rds_secrets_rotation_arn        = module.cloudwatch.cw_lg_lambda_rds_secrets_rotation_arn

  iam_policy_rds_secret_arn = module.secrets.sm_secret_arn
  iam_policy_rds_secret_rotation_lambda_arn = module.lambda.sm_rotation_lambda_function_arn
}

module "s3" {
  source = "./modules/s3"

  s3_main_bucket               = var.s3_main_bucket
  s3_raw_folder_key            = var.s3_raw_folder_key
  s3_proc_folder_key           = var.s3_proc_folder_key
  s3_script_folder_key         = var.s3_script_folder_key
  s3_csv_upload_key            = var.s3_csv_upload_key
  s3_csv_upload_source         = var.s3_csv_upload_source
  s3_glue_script_upload_key    = var.s3_glue_script_upload_key
  s3_glue_script_upload_source = var.s3_glue_script_upload_source

  s3_ct_insights_bucket      = var.s3_ct_insights_bucket
  s3_ct_insights_bucket_logs = var.s3_ct_insights_bucket_logs
  s3_ct_global_bucket        = var.s3_ct_global_bucket

  kms_key_db_arn = module.kms.kms_key_db_arn
  kms_key_ct_arn = module.kms.kms_key_ct_arn

  s3_alb_access_logs_name = var.s3_alb_access_logs_name
}

module "lambda" {
  source = "./modules/lambda"

  lambda_rds_secrets_rotation_function_name    = var.lambda_rds_secrets_rotation_function_name
  lambda_rds_secrets_rotation_description      = var.lambda_rds_secrets_rotation_description
  lambda_rds_secrets_rotation_handler          = var.lambda_rds_secrets_rotation_handler
  lambda_rds_secrets_rotation_role             = module.iam.iam_role_cw_rds_secrets_arn
  lambda_rds_secrets_rotation_memory_size      = var.lambda_rds_secrets_rotation_memory_size
  lambda_rds_secrets_rotation_timeout          = var.lambda_rds_secrets_rotation_timeout
  lambda_rds_secrets_rotation_filename         = data.archive_file.archive-file-lambda-rds-secrets-rotation.output_path
  lambda_rds_secrets_rotation_runtime          = var.lambda_rds_secrets_rotation_runtime
  subnet_ids                                   = module.vpc.sn_db_id
  sg_ids                                       = [module.vpc.sg_lambda_rds_rotation_id]
  lambda_rds_secrets_rotation_function_env_var = {
    EXCLUDE_CHARACTERS = <<EOF
    /@"'\
    EOF
  }
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  cw_log_group_glue_name = var.cw_log_group_glue_name

  cw_lg_ct_insights_events_name = var.cw_lg_ct_insights_events_name
  cw_lg_ct_global_events_name   = var.cw_lg_ct_global_events_name
  kms_key_ct_arn                = module.kms.kms_key_ct_arn
  sns_topic_cw_arn              = module.sns.sns_topic_cw_arn

  cw_lg_lambda_rds_secrets_rotation_name = var.cw_lg_lambda_rds_secrets_rotation_name

  cw_lg_alb_waf_name = var.cw_lg_alb_waf_name

  cw_event_rule_gd_name        = var.cw_event_rule_gd_name
  cw_event_rule_gd_desc        = var.cw_event_rule_gd_desc
  sns_topic_gd_findings_arn    = module.sns.sns_topic_gd_findings_arn
}

module "cloudtrail" {
  source = "./modules/cloudtrail"

  ct_insights_name                    = var.ct_insights_name
  s3_ct_insights_id                   = module.s3.s3_ct_insights_id
  kms_key_ct_arn                      = module.kms.kms_key_ct_arn
  cw_lg_ct_insights_events_arn        = module.cloudwatch.cw_lg_ct_insights_events_arn
  iam_role_cw_arn                     = module.iam.iam_role_cw_arn
  // Supposed to be a variable, but since we need to reference other modules, we will reference them here
  ct_insights_advanced_event_selector = [{name = "Log access main bucket",
    field_selector = [{
        field  = "resources.type",
        equals = ["AWS::S3::Object"]
      },
      {
        field  = "eventCategory",
        equals = ["Data"]
      },
      {
        field  = "resources.ARN",
        equals = ["${module.s3.s3_main_arn}/"]
      }]
  }]

  s3_ct_global_id            = module.s3.s3_ct_global_id
  cw_lg_ct_global_events_arn = module.cloudwatch.cw_lg_ct_global_events_arn
}

module "sns" {
  source = "./modules/sns"

  sns_topic_gd_findings_name         = var.sns_topic_gd_findings_name
  sns_topic_sub_gd_findings_endpoint = var.sns_topic_sub_gd_findings_endpoint

  sns_topic_config_findings_name         = var.sns_topic_config_findings_name
  sns_topic_sub_config_findings_endpoint = var.sns_topic_sub_config_findings_endpoint

  sns_topic_cw_name         = var.sns_topic_cw_name
  sns_topic_sub_cw_endpoint = var.sns_topic_sub_cw_endpoint
}