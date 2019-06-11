
// Ref: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
resource "aws_s3_bucket_policy" "main" {
  bucket = "${aws_s3_bucket.default.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {

      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.default.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Principal": {
        "AWS": [
          "127311923021",
          "033677994240",
          "027434742980",
          "797873946194",
          "985666609251",
          "054676820928",
          "156460612806",
          "652711504416",
          "009996457667",
          "897822967062",
          "754344448648",
          "582318560864",
          "600734575887",
          "383597477331",
          "114774131450",
          "783225319266",
          "718504428378",
          "507241528517",
          "048591011584",
          "190560391635",
          "638102146993",
          "037604701340"
        ]
      }
    }
  ]
}
POLICY
}

// Source: https://github.com/QuiNovas/terraform-aws-cloudtrail/blob/master/s3-bucket.tf
data "aws_iam_policy_document" "cloudtrail" {

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
      type = "Service"
    }
    resources = [
      "${aws_s3_bucket.default.arn}"
    ]
    sid = "CloudTrail Acl Check"
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    condition {
      test = "StringEquals"
      values = [
        "bucket-owner-full-control"
      ]
      variable = "s3:x-amz-acl"
    }
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
      type = "Service"
    }
    resources = [
      "${aws_s3_bucket.default.arn}/*"
    ]
    sid = "CloudTrail Write"
  }

  statement {
    actions = [
      "s3:*"
    ]
    condition {
      test = "Bool"
      values = [
        "false"
      ]
      variable = "aws:SecureTransport"
    }
    effect = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type = "AWS"
    }
    resources = [
      "${aws_s3_bucket.default.arn}",
      "${aws_s3_bucket.default.arn}/*"
    ]
    sid = "DenyUnsecuredTransport"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = "${aws_s3_bucket.default.id}"
  policy = "${data.aws_iam_policy_document.cloudtrail.json}"
}
