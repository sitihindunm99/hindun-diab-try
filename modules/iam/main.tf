/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Transfer Family] Create role
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_iam_role" "iam-role-transfer" {
  name                 = var.iam_role_transfer_name
  managed_policy_arns  = var.iam_role_transfer_managed_policy_arns
  permissions_boundary = var.iam_permission_boundary
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["transfer.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For EC2] Create role
/////////////////////////////////////////////////////////////////////////////////////////////////

// harden default
resource "aws_iam_role" "iam-role-ec2-harden-default" {
  name                 = var.iam_role_ec2_harden_default_name
  managed_policy_arns  = var.iam_role_ec2_harden_default_managed_policy_arns
  permissions_boundary = var.iam_permission_boundary
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "iam-instance-profile-ec2-harden-default" {
  name = var.iam_instance_profile_ec2_harden_default_name
  role = aws_iam_role.iam-role-ec2-harden-default.name
}

// nginx
resource "aws_iam_role" "iam-role-ec2-nginx" {
  name                 = var.iam_role_ec2_nginx_name
  managed_policy_arns  = var.iam_role_ec2_nginx_managed_policy_arns
  permissions_boundary = var.iam_permission_boundary
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "iam-instance-profile-ec2-nginx" {
  name = var.iam_instance_profile_ec2_nginx_name
  role = aws_iam_role.iam-role-ec2-nginx.name
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Glue] Create role
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_iam_role" "iam-role-glue" {
  name                 = var.iam_role_glue_name
  managed_policy_arns  = var.iam_role_glue_managed_policy_arns
  permissions_boundary = var.iam_permission_boundary
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["glue.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Sagemaker] Create role
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_iam_role" "iam-role-sm" {
  name                 = var.iam_role_sm_name
  permissions_boundary = var.iam_permission_boundary
  managed_policy_arns  = var.iam_role_sm_managed_policy_arns
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["sagemaker.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For CloudWatch] Create role
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_iam_role" "iam-role-cw" {
  name = var.iam_role_cw_name
  permissions_boundary = var.iam_permission_boundary

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
      }
  ]
}
EOF

  inline_policy {
    name   = "cloudwatch-policy"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "AWSCloudTrailCreateLogStream2014110",
          "Effect": "Allow",
          "Action": [
              "logs:CreateLogStream"
          ],
          "Resource": [
            "${var.cw_lg_ct_insights_events_arn}:log-stream:*"
          ]
      },
      {
          "Sid": "AWSCloudTrailPutLogEvents20141101",
          "Effect": "Allow",
          "Action": [
              "logs:PutLogEvents"
          ],
          "Resource": [
              "${var.cw_lg_ct_insights_events_arn}:log-stream:*"
          ]
      }
  ]
}
EOF
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Lambda RDS Secrets Rotation] Create role
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_iam_role" "iam-role-cw-lambda-rds-secrets" {
  name = "${var.iam_role_cw_lambda_rds_secrets_function_name}"
  permissions_boundary = var.iam_permission_boundary
  path = "/service/lambda/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  inline_policy {
    name   = "${var.iam_role_cw_lambda_rds_secrets_function_name}-minimum-policy"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
          ],
          "Resource": "${var.cw_lg_lambda_rds_secrets_rotation_arn}:*"
      }
  ]
}
EOF
  }
}

resource "aws_iam_policy" "rds-secrets-rotation-policy" {
  name        = "rds_secrets_rotation_function_policy"
  path        = "/service/lambda/"
  description = ""

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage"
      ],
      "Resource": "${var.iam_policy_rds_secret_arn}",
      "Condition": {
          "StringEquals": {
              "secretsmanager:resource/AllowRotationLambdaArn": "${var.iam_policy_rds_secret_rotation_lambda_arn}"
          }
      }
    },{
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetRandomPassword"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "rds-secrets-rotation" {
  role       = aws_iam_role.iam-role-cw-lambda-rds-secrets.name
  policy_arn = aws_iam_policy.rds-secrets-rotation-policy.arn
}