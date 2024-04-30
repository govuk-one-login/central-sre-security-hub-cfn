resource "aws_s3_bucket" "artifacts" {
  bucket = "di-central-sre-build-artifact"

  tags = {
    Product     = "GOV.UK"
    System      = "Central-SRE-build-service"
    Environment = "build"
    Owner       = "Central-SRE"
  }
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 30
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "BucketExpiry"
    status = "Enabled"
    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_logging" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  target_bucket = "di-central-sre-build-access-logs"
  target_prefix = "artifacts/"
}

data "local_file" "empty_lambda_zip" {
  filename = "${path.module}/files/empty-lambda.zip"
}

resource "aws_s3_object" "empty_lambda" {
  bucket = aws_s3_bucket.artifacts.id
  key    = "python/empty-lambda.zip"
  source = data.local_file.empty_lambda_zip.filename

  object_lock_mode              = "COMPLIANCE" # Change to GOVERNANCE once past 2025-02-19T12:00:00
  object_lock_retain_until_date = "2025-02-19T12:00:00Z"
}

resource "aws_s3_bucket_policy" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  policy = data.aws_iam_policy_document.artifacts.json
}

resource "aws_cloudformation_stack" "artifacts_kms_key" {
  name          = "artifacts-kms-key"
  template_body = file("${path.module}/../../../../../../service_catalog_portfolios/encryption/kms/template.yaml")
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_cloudformation_stack.artifacts_kms_key.outputs.KeyId
      sse_algorithm     = "aws:kms"
    }
  }
}