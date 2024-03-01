data "aws_iam_policy_document" "artifacts" {
  
  statement {
    sid    = "AllowSSLRequestsOnly"

    principals {
      type = "*" 
      identifiers = ["*"]
    }

    effect = "Deny"

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*"
    ]

    condition {
      variable = "aws:SecureTransport"
      values = ["false"]
      test = "Bool"
    }
  }
}
