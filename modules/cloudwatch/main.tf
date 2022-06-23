/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Glue] Create a CloudWatch Log Group
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudwatch_log_group" "cw-log-group-glue" {
  name              = var.cw_log_group_glue_name
  retention_in_days = 14
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For CloudTrail] Insights - Create a CloudWatch Log Group
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudwatch_log_group" "cw-lg-ct-insights-events" {
  name              = "/aws/cloudtrail/${var.cw_lg_ct_insights_events_name}-log-group"
  retention_in_days = 14
  kms_key_id        = var.kms_key_ct_arn
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For CloudTrail] Global - Create a CloudWatch Log Group
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudwatch_log_group" "cw-lg-ct-global-events" {
  name              = "/aws/cloudtrail/${var.cw_lg_ct_global_events_name}-log-group"
  retention_in_days = 14
  kms_key_id        = var.kms_key_ct_arn
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Secrets Manager] Create a CloudWatch Log Group
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudwatch_log_group" "cw-lg-lambda-rds-secrets-rotation" {
  name              = "/aws/lambda/${var.cw_lg_lambda_rds_secrets_rotation_name}"
  retention_in_days = 14
}

////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For WAF] Create a Create a CloudWatch Log Group
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudwatch_log_group" "cw-lg-alb-waf" {
  # log group name must begin with 'aws-waf-logs-'
  name              = "aws-waf-logs-${var.cw_lg_alb_waf_name}"
  retention_in_days = 90
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For GuardDuty] Create a CloudWatch Event Rule & Event Target
//////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudwatch_event_rule" "cw-event-rule-gd-findings" {
  name        = var.cw_event_rule_gd_name
  description = var.cw_event_rule_gd_desc

  event_pattern = <<EOF
{
  "source": [
    "aws.guardduty"
  ],
  "detail-type": [
    "GuardDuty Finding"
  ],
  "detail": {
    "severity": [
      4,
      4.0,
      4.1,
      4.2,
      4.3,
      4.4,
      4.5,
      4.6,
      4.7,
      4.8,
      4.9,
      5,
      5.0,
      5.1,
      5.2,
      5.3,
      5.4,
      5.5,
      5.6,
      5.7,
      5.8,
      5.9,
      6,
      6.0,
      6.1,
      6.2,
      6.3,
      6.4,
      6.5,
      6.6,
      6.7,
      6.8,
      6.9,
      7,
      7.0,
      7.1,
      7.2,
      7.3,
      7.4,
      7.5,
      7.6,
      7.7,
      7.8,
      7.9,
      8,
      8.0,
      8.1,
      8.2,
      8.3,
      8.4,
      8.5,
      8.6,
      8.7,
      8.8,
      8.9
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "cw-event-target-gd-findings" {
  rule = aws_cloudwatch_event_rule.cw-event-rule-gd-findings.name
  arn  = var.sns_topic_gd_findings_arn

  input_transformer {
    input_paths = {
      severity            = "$.detail.severity",
      Account_ID          = "$.detail.accountId",
      Finding_ID          = "$.detail.id",
      Finding_Type        = "$.detail.type",
      region              = "$.region",
      Finding_description = "$.detail.description"
    }
    input_template = <<EOF
"AWS <Account_ID> has a severity <severity> GuardDuty finding type <Finding_Type> in the <region> region."
"Finding Description:"
"<Finding_description>."
"For more details open the GuardDuty console at https://console.aws.amazon.com/guardduty/home?region=<region>#/findings?search=id=<Finding_ID>"
EOF
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : Set Metrics and Alarms for VAPT
//////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global" {
  name           = "no mfa console sign in metric"
  pattern        = "{($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\")}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "no mfa console sign in metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global" {
  alarm_name          = "no-mfa-console-signin-alarm"
  alarm_description   = "This alarm is for no MFA sign-in"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "no mfa console sign in metric"
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-root" {
  name           = "root usage metric"
  pattern        = "{$.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\"}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "root usage metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-root" {
  alarm_name          = "root-usage-alarm"
  alarm_description   = "This alarm is for root usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "root usage metric"
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-iam" {
  name           = "iam changes metric"
  pattern        = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "iam changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-iam" {
  alarm_name          = "iam-changes-alarm"
  alarm_description   = "This alarm is for iam changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-iam.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-ct" {
  name           = "cloudtrail changes metric"
  pattern        = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "cloudtrail changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-ct" {
  alarm_name          = "cloudtrail-changes-alarm"
  alarm_description   = "This alarm is for cloudtrail changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-ct.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-sign-in" {
  name           = "sign in failure metric"
  pattern        = "{($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\")}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "sign in failure metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-sign-in" {
  alarm_name          = "sign-in-failure-alarm"
  alarm_description   = "This alarm is for sign in"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-sign-in.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-cmk" {
  name           = "cmk changes metric"
  pattern        = "{($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion))}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "cmk changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-cmk" {
  alarm_name          = "cmk-changes-alarm"
  alarm_description   = "This alarm is for cmk changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-cmk.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-s3" {
  name           = "s3 changes metric"
  pattern        = "{($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl)||($.eventName = PutBucketPolicy)||($.eventName = PutBucketCors)||($.eventName = PutBucketLifecycle)||($.eventName = PutBucketReplication)||($.eventName = DeleteBucketPolicy)||($.eventName = DeleteBucketCors)||($.eventName = DeleteBucketLifecycle)||($.eventName =DeleteBucketReplication)) }"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "s3 changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-s3" {
  alarm_name          = "s3-changes-alarm"
  alarm_description   = "This alarm is for s3 changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-s3.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-config" {
  name           = "config changes metric"
  pattern        = "{($.eventSource=config.amazonaws.com)&&(($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder))}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "config changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-config" {
  alarm_name          = "config-changes-alarm"
  alarm_description   = "This alarm is for config changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-config.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-sg" {
  name           = "security groups changes metric"
  pattern        = "{($.eventName=AuthorizeSecurityGroupIngress)||($.eventName=AuthorizeSecurityGroupEgress)||($.eventName = RevokeSecurityGroupIngress)||($.eventName = RevokeSecurityGroupEgress)||($.eventName = CreateSecurityGroup)||($.eventName = DeleteSecurityGroup)}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "security groups changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-sg" {
  alarm_name          = "security-groups-changes-alarm"
  alarm_description   = "This alarm is for security groups changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-sg.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-nacl" {
  name           = "NACL changes metric"
  pattern        = "{($.eventName = CreateNetworkAcl)||($.eventName = CreateNetworkAclEntry)||($.eventName = DeleteNetworkAcl)||($.eventName = DeleteNetworkAclEntry)||($.eventName = ReplaceNetworkAclEntry)||($.eventName = ReplaceNetworkAclAssociation)}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "NACL changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-nacl" {
  alarm_name          = "nacl-changes-alarm"
  alarm_description   = "This alarm is for NACL changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-nacl.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-gateway" {
  name           = "gateway changes metric"
  pattern        = "{($.eventName = CreateCustomerGateway)||($.eventName = DeleteCustomerGateway)||($.eventName = AttachInternetGateway)||($.eventName = CreateInternetGateway)||($.eventName = DeleteInternetGateway)||($.eventName = DetachInternetGateway) }"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "gateway changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-gateway" {
  alarm_name          = "gateway-changes-alarm"
  alarm_description   = "This alarm is for gateway changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-gateway.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-rt" {
  name           = "route table changes metric"
  pattern        = "{($.eventName = CreateRoute)||($.eventName = CreateRouteTable)||($.eventName = ReplaceRoute)||($.eventName = ReplaceRouteTableAssociation)||($.eventName = DeleteRouteTable)||($.eventName = DeleteRoute)||($.eventName = DisassociateRouteTable)}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "route table changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-rt" {
  alarm_name          = "route-table-changes-alarm"
  alarm_description   = "This alarm is for route table changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-rt.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-vpc" {
  name           = "vpc changes metric"
  pattern        = "{($.eventName = CreateVpc)||($.eventName = DeleteVpc)||($.eventName = ModifyVpcAttribute)||($.eventName = AcceptVpcPeeringConnection)||($.eventName = CreateVpcPeeringConnection)||($.eventName = DeleteVpcPeeringConnection)||($.eventName = RejectVpcPeeringConnection)||($.eventName = AttachClassicLinkVpc)||($.eventName = DetachClassicLinkVpc)||($.eventName = DisableVpcClassicLink)||($.eventName = EnableVpcClassicLink)}"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "vpc changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-vpc" {
  alarm_name          = "vpc-changes-alarm"
  alarm_description   = "This alarm is for vpc changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-vpc.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}

resource "aws_cloudwatch_log_metric_filter" "cw-lg-metric-filter-global-org" {
  name           = "org changes metric"
  pattern        = "{($.eventSource = organizations.amazonaws.com)&&(($.eventName = \"AcceptHandshake\")||($.eventName = \"AttachPolicy\")||($.eventName = \"CreateAccount\")||($.eventName = \"CreateOrganizationalUnit\")||($.eventName = \"CreatePolicy\")||($.eventName = \"DeclineHandshake\")||($.eventName = \"DeleteOrganization\")||($.eventName = \"DeleteOrganizationalUnit\")||($.eventName = \"DeletePolicy\")||($.eventName = \"DetachPolicy\")||($.eventName = \"DisablePolicyType\")||($.eventName = \"EnablePolicyType\")||($.eventName = \"InviteAccountToOrganization\")||($.eventName = \"LeaveOrganization\")||($.eventName = \"MoveAccount\")||($.eventName = \"RemoveAccountFromOrganization\")||($.eventName = \"UpdatePolicy\")||($.eventName = \"UpdateOrganizationalUnit\")) }"
  log_group_name = aws_cloudwatch_log_group.cw-lg-ct-global-events.id

  metric_transformation {
    name      = "org changes metric"
    namespace = "CISBenchmark"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cw-metric-alarm-global-org" {
  alarm_name          = "org-changes-alarm"
  alarm_description   = "This alarm is for org changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cw-lg-metric-filter-global-org.name
  namespace           = "CISBenchmark"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_topic_cw_arn]
}