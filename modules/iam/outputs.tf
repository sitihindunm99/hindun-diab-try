output "iam_role_transfer_arn" {
  value = aws_iam_role.iam-role-transfer.arn
}

output "iam_role_ec2_harden_default_arn" {
  value = aws_iam_role.iam-role-ec2-harden-default.arn
}

output "iam_role_ec2_harden_default_name" {
  value = aws_iam_role.iam-role-ec2-harden-default.name
}

output "iam_instance_profile_ec2_harden_default_name" {
  value = aws_iam_instance_profile.iam-instance-profile-ec2-harden-default.name
}

output "iam_role_ec2_nginx_arn" {
  value = aws_iam_role.iam-role-ec2-nginx.arn
}

output "iam_role_ec2_nginx_name" {
  value = aws_iam_role.iam-role-ec2-nginx.name
}

output "iam_instance_profile_ec2_nginx_name" {
  value = aws_iam_instance_profile.iam-instance-profile-ec2-nginx.name
}

output "iam_role_glue_arn" {
  value = aws_iam_role.iam-role-glue.arn
}

output "iam_role_sm_arn" {
  value = aws_iam_role.iam-role-sm.arn
}

output "iam_role_cw_arn" {
  value = aws_iam_role.iam-role-cw.arn
}

output "iam_role_cw_rds_secrets_arn" {
  value = aws_iam_role.iam-role-cw-lambda-rds-secrets.arn
}