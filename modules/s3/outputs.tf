output "s3_main_id" {
  value = aws_s3_bucket.s3-main.id
}

output "s3_main_arn" {
  value = aws_s3_bucket.s3-main.arn
}

output "s3_main_bucket" {
  value = aws_s3_bucket.s3-main.bucket
}

output "s3_object_raw_folder_id" {
  value = aws_s3_bucket_object.s3-object-raw-folder.id
}

output "s3_object_processed_folder_id" {
  value = aws_s3_bucket_object.s3-object-processed-folder.id
}

output "s3_object_script_folder_id" {
  value = aws_s3_bucket_object.s3-object-processed-folder.id
}

output "s3_object_csv_upload_key"  {
  value = aws_s3_bucket_object.s3-object-csv-upload.key
}

output "s3_object_script_upload_key"  {
  value = aws_s3_bucket_object.s3-object-script-folder.key
}

output "s3_ct_insights_id" {
  value = aws_s3_bucket.s3-ct-insights.id
}

output "s3_ct_insights_arn" {
  value = aws_s3_bucket.s3-ct-insights.arn
}

output "s3_ct_global_id" {
  value = aws_s3_bucket.s3-ct-global.id
}

output "s3_ct_global_arn" {
  value = aws_s3_bucket.s3-ct-global.arn
}

output "s3_alb_access_logs_id"  {
  value = aws_s3_bucket.s3-alb-access-logs.id
}