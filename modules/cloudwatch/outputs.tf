output "cw_log_group_glue_name" {
  value = aws_cloudwatch_log_group.cw-log-group-glue.name
}

output "cw_lg_ct_insights_events_name" {
  value = aws_cloudwatch_log_group.cw-lg-ct-insights-events.name
}

output "cw_lg_ct_insights_events_arn" {
  value = aws_cloudwatch_log_group.cw-lg-ct-insights-events.arn
}

output "cw_lg_ct_global_events_arn" {
  value = aws_cloudwatch_log_group.cw-lg-ct-global-events.arn
}

output "cw_lg_lambda_rds_secrets_rotation_arn" {
  value = aws_cloudwatch_log_group.cw-lg-lambda-rds-secrets-rotation.arn
}

output "cw_lg_alb_waf_arn" {
  value = aws_cloudwatch_log_group.cw-lg-alb-waf.arn
}