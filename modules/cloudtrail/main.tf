/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : Create a CloudTrail using Event selector
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudtrail" "ct-insights" {
  name                          = var.ct_insights_name
  s3_bucket_name                = var.s3_ct_insights_id
  include_global_service_events = false
  enable_log_file_validation    = true
  is_multi_region_trail         = false
  is_organization_trail         = false
  kms_key_id                    = var.kms_key_ct_arn

  cloud_watch_logs_group_arn = "${var.cw_lg_ct_insights_events_arn}:*"
  cloud_watch_logs_role_arn  = var.iam_role_cw_arn

  dynamic "advanced_event_selector" {
    for_each = toset(var.ct_insights_advanced_event_selector)

    content {
      name = advanced_event_selector.value.name

      dynamic "field_selector" {
        for_each = toset(advanced_event_selector.value.field_selector)

        content {
          field  = field_selector.value.field
          equals = field_selector.value.equals
        }
      }
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : Create a CloudTrail to enable global logging (For VAPT)
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_cloudtrail" "ct-global" {
  name                          = "diab-gt-global"
  s3_bucket_name                = var.s3_ct_global_id
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  is_organization_trail         = false
  kms_key_id                    = "arn:aws:kms:ap-southeast-1:798370739211:key/58fccd0f-8b3f-4ada-9329-17959728dfbf"

  cloud_watch_logs_group_arn = "${var.cw_lg_ct_global_events_arn}:*"
  cloud_watch_logs_role_arn  = var.iam_role_cw_arn

}
