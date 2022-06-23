output "sns_topic_gd_findings_arn" {
  value = aws_sns_topic.sns-topic-gd-findings.arn
}

output "sns_topic_config_findings_arn" {
  value = aws_sns_topic.sns-topic-config-findings.arn
}

output "sns_topic_cw_arn" {
  value = aws_sns_topic.sns-topic-cw.arn
}