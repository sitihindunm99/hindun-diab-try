// overall
region = "ap-southeast-1"

project_name = "diab"
account_id   = "798370739211"

alb_tier_name      = "web"
transfer_tier_name = "app"
ec2_tier_name      = "app"
#rds_tier_name      = "data"

// iam
iam_permission_boundary = "arn:aws:iam::798370739211:policy/GCCIAccountBoundary"

iam_role_transfer_name                = "diab-iam-transfer-role"
iam_role_transfer_managed_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]

iam_role_ec2_harden_default_name                 = "diab-ec2-harden-default-service-role"
iam_role_ec2_harden_default_managed_policy_arns  = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"] #Needed for SSM
iam_instance_profile_ec2_harden_default_name     = "diab-ec2-harden-default-instance-profile"

iam_role_ec2_nginx_name                 = "diab-ec2-nginx-service-role"
iam_role_ec2_nginx_managed_policy_arns  = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"] #Needed for SSM
iam_instance_profile_ec2_nginx_name     = "diab-ec2-nginx-instance-profile"

iam_role_glue_name                = "diab-iam-glue-role"
iam_role_glue_managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess","arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole","arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"]

iam_role_sm_name                  = "diab-iam-sagemaker-role"
iam_role_sm_managed_policy_arns   = ["arn:aws:iam::aws:policy/service-role/AWSGlueServiceNotebookRole","arn:aws:iam::aws:policy/AWSGlueSchemaRegistryReadonlyAccess"]

iam_role_cw_name = "diab-iam-cloudwatch-role"

iam_role_cw_lambda_rds_secrets_function_name = "diab-iam-lambda-rds-secrets-role"

// s3
s3_main_bucket               = "diab-sample-bucket"
s3_raw_folder_key            = "raw/"
s3_proc_folder_key           = "processed/"
s3_script_folder_key         = "script/"
s3_csv_upload_key            = "raw/covid_sample_data.csv"
s3_csv_upload_source         = "data/csv/covid_sample_data.csv"
s3_glue_script_upload_key    = "script/sample_glue_script.py"
s3_glue_script_upload_source = "data/script/sample_glue_script.py"

s3_ct_insights_bucket      = "diab-cloudtrail-insights"
s3_ct_insights_bucket_logs ="diab-cloudtrail-insights-logs"
s3_ct_insights_prefix      = "ct-insights-bucket-logs/"

s3_ct_global_bucket = "diab-cloudtrail-global"

s3_alb_access_logs_name = "aws-alb-access-logs-diab"

// lambda
lambda_rds_secrets_rotation_function_name = "diab-rds-secrets-rotation-function"
lambda_rds_secrets_rotation_description   = "Secrets rotation function for RDS secrets"
lambda_rds_secrets_rotation_handler       = "lambda_function.lambda_handler"
lambda_rds_secrets_rotation_memory_size   = "128"
lambda_rds_secrets_rotation_timeout       = "20"
lambda_rds_secrets_rotation_runtime       = "python3.9"

// cloudwatch
cw_log_group_glue_name = "diab-sample-glue-job-log-group"

cw_lg_ct_insights_events_name = "diab-ct-insights-log-group"
cw_lg_ct_global_events_name   = "diab-ct-global-log-group"

cw_lg_lambda_rds_secrets_rotation_name = "diab-lambda-rds-secrets-log-group"

cw_lg_alb_waf_name = "diab-waf-log-group"

cw_event_rule_gd_name = "diab-cw-gd-event-rule"
cw_event_rule_gd_desc = "Guard Duty notification for Med to High findings"

// cloudtrail
ct_insights_name = "diab-ct-insights"

// sns
sns_topic_gd_findings_name         = "diab-guard-duty-sns-topic"
sns_topic_sub_gd_findings_endpoint = "ngleening@gmail.com"

sns_topic_config_findings_name         = "diab-config-sns-topic"
sns_topic_sub_config_findings_endpoint = "ngleening@gmail.com"

sns_topic_cw_name         = "diab-cloudwatch-sns-topic"
sns_topic_sub_cw_endpoint = "ngleening@gmail.com"