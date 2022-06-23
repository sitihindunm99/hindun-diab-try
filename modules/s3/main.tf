/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : Create S3 bucket to log access to other S3 buckets
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_s3_bucket" "s3-ct-insights-logs" {
  bucket = var.s3_ct_insights_bucket_logs

  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_ct_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_acl" "s3-acl-ct-insights-logs" {
  bucket = aws_s3_bucket.s3-ct-insights-logs.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_access_logs_public_access_block" {
  bucket = aws_s3_bucket.s3-ct-insights-logs.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_lifecycle_configuration" "s3-lc-access-logs" {
  bucket = aws_s3_bucket.s3-ct-insights-logs.id

  rule {
    id = "${aws_s3_bucket.s3-ct-insights-logs.id}-storage-lifecycle-configuration"
    expiration {
      days = 90
    }
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "${aws_s3_bucket.s3-ct-insights-logs.id}-noncurrent-lifecycle-configuration"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : Create S3 Raw Bucket & insert data
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_s3_bucket" "s3-main" {
  bucket = var.s3_main_bucket
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_db_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# Create raw bucket folder in s3 bucket
resource "aws_s3_bucket_object" "s3-object-raw-folder" {
  bucket = aws_s3_bucket.s3-main.id
  acl    = "private"
  key    = var.s3_raw_folder_key
}

# Create processed bucket folder in s3 bucket
resource "aws_s3_bucket_object" "s3-object-processed-folder" {
  bucket = aws_s3_bucket.s3-main.id
  acl    = "private"
  key    = var.s3_proc_folder_key
}

# Create script bucket folder in s3 bucket
resource "aws_s3_bucket_object" "s3-object-script-folder" {
  bucket = aws_s3_bucket.s3-main.id
  acl    = "private"
  key    = var.s3_script_folder_key
}

# Upload flat files to raw folder
resource "aws_s3_bucket_object" "s3-object-csv-upload" {
  bucket = aws_s3_bucket.s3-main.id
  key    = var.s3_csv_upload_key
  source = var.s3_csv_upload_source
}

# Upload glue scripts to script folder
resource "aws_s3_bucket_object" "s3-object-glue-script-upload" {
  bucket = aws_s3_bucket.s3-main.id
  key    = var.s3_glue_script_upload_key
  source = var.s3_glue_script_upload_source
}

resource "aws_s3_bucket_public_access_block" "s3_main_public_access_block" {
  bucket = aws_s3_bucket.s3-main.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_logging" "s3-logging-main" {
  bucket = aws_s3_bucket.s3-main.id

  target_bucket = aws_s3_bucket.s3-ct-insights-logs.id
  target_prefix = "main-access-logs/"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3-lc-main" {
  bucket = aws_s3_bucket.s3-main.id

  rule {
    id = "${aws_s3_bucket.s3-main.id}-storage-lifecycle-configuration"
    expiration {
      days = 90
    }
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "${aws_s3_bucket.s3-main.id}-noncurrent-lifecycle-configuration"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Cloudtrail] Create S3 Bucket
/////////////////////////////////////////////////////////////////////////////////////////////////

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "s3-ct-insights" {
  bucket        = lower(var.s3_ct_insights_bucket)
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_ct_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${lower(var.s3_ct_insights_bucket)}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${lower(var.s3_ct_insights_bucket)}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "s3_ct_insights_public_access_block" {
  bucket = aws_s3_bucket.s3-ct-insights.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_logging" "s3-logging-ct-insights" {
  bucket = aws_s3_bucket.s3-ct-insights.id

  target_bucket = aws_s3_bucket.s3-ct-insights-logs.id
  target_prefix = "ct-insights-logs/"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3-lc-ct-insights" {
  bucket = aws_s3_bucket.s3-ct-insights.id

  rule {
    id = "${aws_s3_bucket.s3-ct-insights.id}-storage-lifecycle-configuration"
    expiration {
      days = 90
    }
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "${aws_s3_bucket.s3-ct-insights.id}-noncurrent-lifecycle-configuration"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [For Cloudtrail] Create S3 Bucket for Global logging
/////////////////////////////////////////////////////////////////////////////////////////////////

resource "aws_s3_bucket" "s3-ct-global" {
  bucket        = var.s3_ct_global_bucket
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_ct_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${lower(var.s3_ct_global_bucket)}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${lower(var.s3_ct_global_bucket)}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "s3_ct_global_public_access_block" {
  bucket = aws_s3_bucket.s3-ct-global.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_logging" "s3-logging-ct-global" {
  bucket = aws_s3_bucket.s3-ct-global.id

  target_bucket = aws_s3_bucket.s3-ct-insights-logs.id
  target_prefix = "ct-global-logs/"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3-lc-ct-global" {
  bucket = aws_s3_bucket.s3-ct-global.id

  rule {
    id = "${aws_s3_bucket.s3-ct-global.id}-storage-lifecycle-configuration"
    expiration {
      days = 90
    }
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "${aws_s3_bucket.s3-ct-global.id}-noncurrent-lifecycle-configuration"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION       : [ALB] Create S3 Bucket
/////////////////////////////////////////////////////////////////////////////////////////////////

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "s3-alb-access-logs" {
  bucket = var.s3_alb_access_logs_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        # using Amazon S3 master-key (SSE-S3)
        sse_algorithm = "aws:kms"
      }
    }
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSS3AlbLogBucketPut",
            "Effect": "Allow",
            "Principal": {
              "AWS": "${data.aws_elb_service_account.main.arn}"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.s3_alb_access_logs_name}/AWSLogs/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "s3-alb-access-logs-public-block-access" {
  bucket = aws_s3_bucket.s3-alb-access-logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "s3-logging-alb-access-logs" {
  bucket = aws_s3_bucket.s3-alb-access-logs.id

  target_bucket = aws_s3_bucket.s3-ct-insights-logs.id
  target_prefix = "alb-access-logs/"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3-lc-alb-access-logs" {
  bucket = aws_s3_bucket.s3-alb-access-logs.id

  rule {
    id = "${aws_s3_bucket.s3-alb-access-logs.id}-storage-lifecycle-configuration"
    expiration {
      days = 90
    }
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "${aws_s3_bucket.s3-alb-access-logs.id}-noncurrent-lifecycle-configuration"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}