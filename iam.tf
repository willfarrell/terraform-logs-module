# TODO move to CloudTrail module, output role for ingestion
data "aws_iam_policy_document" "cloudtrail" {
  # Ref: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
  # us-gov-* and cn-* are not allowed
  statement {
    sid       = "Access Logs"
    effect    = "Allow"
    actions   = [
      "s3:PutObject"
    ]
    principals {
      identifiers = [
        "arn:aws:iam::985666609251:root",
        "arn:aws:iam::897822967062:root",
        "arn:aws:iam::797873946194:root",
        "arn:aws:iam::783225319266:root",
        "arn:aws:iam::754344448648:root",
        "arn:aws:iam::718504428378:root",
        "arn:aws:iam::652711504416:root",
        "arn:aws:iam::600734575887:root",
        "arn:aws:iam::582318560864:root",
        "arn:aws:iam::507241528517:root",
        "arn:aws:iam::383597477331:root",
        "arn:aws:iam::156460612806:root",
        "arn:aws:iam::127311923021:root",
        "arn:aws:iam::114774131450:root",
        "arn:aws:iam::054676820928:root",
        "arn:aws:iam::033677994240:root",
        "arn:aws:iam::027434742980:root",
        "arn:aws:iam::009996457667:root",
      ]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.default.id}/*"]
  }

  # CloudTrail: https://github.com/QuiNovas/terraform-aws-cloudtrail/blob/master/s3-bucket.tf
  # AWS Config: https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html
  statement {
    sid       = "BucketPermissionsCheck"
    effect    = "Allow"
    actions   = [
      "s3:ListBucket",
      "s3:GetBucketAcl"
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
        "config.amazonaws.com",
        "delivery.logs.amazonaws.com",
        "firehose.amazonaws.com"
      ]
      type        = "Service"
    }
    resources = [
      aws_s3_bucket.default.arn,
    ]
  }
  
  # IAM Access Analyzer https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-policy-generation.html
  # statement {
  #   sid = "PolicyGenerationBucketPolicy"
  #   effect    = "Allow"
  #   principals  {
  #     type = "AWS"
  #     identifiers = ["*"]
  #   }
  #   actions = [
  #     "s3:GetObject",
  #     "s3:ListBucket"
  #   ]
  #   resources = [
  #     "arn:aws:s3:::${aws_s3_bucket.default.id}",
  #     "arn:aws:s3:::${aws_s3_bucket.default.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
  #   ]
  #   # condition {
  #   #   test     = "StringEquals"
  #   #   values   = ["organization-id"] # TODO
  #   #   variable = "aws:PrincipalOrgID"
  #   # }
  #   condition {
  #     test     = "StringLike"
  #     values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AccessAnalyzerMonitorServiceRole*"]
  #     variable = "aws:PrincipalArn"
  #   }
  # }

  statement {
    sid       = "BucketDelivery"
    effect    = "Allow"
    actions   = [
      "s3:PutObject",
    ]
    condition {
      test     = "StringEquals"
      values   = [
        "bucket-owner-full-control",
      ]
      variable = "s3:x-amz-acl"
    }
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
        "config.amazonaws.com",
        "delivery.logs.amazonaws.com",
        "firehose.amazonaws.com"
      ]
      type        = "Service"
    }
    resources = [
      "${aws_s3_bucket.default.arn}/*",
    ]
  }

  # General
  statement {
    actions   = [
      "s3:*",
    ]
    condition {
      test     = "Bool"
      values   = [
        "false",
      ]
      variable = "aws:SecureTransport"
    }
    effect    = "Deny"
    principals {
      identifiers = [
        "*",
      ]
      type        = "AWS"
    }
    resources = [
      aws_s3_bucket.default.arn,
      "${aws_s3_bucket.default.arn}/*",
    ]
    sid       = "DenyUnsecuredTransport"
  }
}

resource "aws_s3_bucket_policy" "main" {
  depends_on = [
    aws_s3_bucket.default,
    data.aws_iam_policy_document.cloudtrail]
  bucket     = aws_s3_bucket.default.id
  policy     = data.aws_iam_policy_document.cloudtrail.json
}

