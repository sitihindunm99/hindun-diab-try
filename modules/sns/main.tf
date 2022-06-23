/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For GuardDuty] Create SNS topic & policy
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_sns_topic" "sns-topic-gd-findings" {
  name = var.sns_topic_gd_findings_name
}

resource "aws_sns_topic_policy" "sns-topic-gd-findings-policy" {
  arn    = aws_sns_topic.sns-topic-gd-findings.arn
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Grant EventBridge permission to publish",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "${aws_sns_topic.sns-topic-gd-findings.arn}"
    }
  ]
}
EOF
}

// Set-up email notifications
resource "aws_sns_topic_subscription" "sns-topic-sub-gd-findings" {
  topic_arn = aws_sns_topic.sns-topic-gd-findings.arn
  protocol  = "email"
  endpoint  = var.sns_topic_sub_gd_findings_endpoint
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Config] Create SNS topic & policy
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_sns_topic" "sns-topic-config-findings" {
  name = var.sns_topic_config_findings_name
}

resource "aws_sns_topic_policy" "sns-topic-config-findings-policy" {
  arn    = aws_sns_topic.sns-topic-config-findings.arn
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Grant EventBridge permission to publish",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "${aws_sns_topic.sns-topic-config-findings.arn}"
    }
  ]
}
EOF
}

// Set-up email notifications
resource "aws_sns_topic_subscription" "sns-topic-sub-config-findings" {
  topic_arn = aws_sns_topic.sns-topic-config-findings.arn
  protocol  = "email"
  endpoint  = var.sns_topic_sub_config_findings_endpoint
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For CloudWatch] Create SNS topic & policy
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_sns_topic" "sns-topic-cw" {
  name = var.sns_topic_cw_name
}

resource "aws_sns_topic_policy" "sns-topic-policy-cw" {
  arn    = aws_sns_topic.sns-topic-cw.arn
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Grant EventBridge permission to publish",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "${aws_sns_topic.sns-topic-cw.arn}"
    }
  ]
}
EOF
}

// Set-up email notifications
resource "aws_sns_topic_subscription" "sns-topic-sub-cw" {
  topic_arn = aws_sns_topic.sns-topic-cw.arn
  protocol  = "email"
  endpoint  = var.sns_topic_sub_cw_endpoint
}