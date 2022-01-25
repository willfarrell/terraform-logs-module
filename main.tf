resource "aws_s3_bucket" "default" {
  bucket = "${var.name}-logs"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    tags = {
      rule      = "log"
      autoclean = "true"
    }

    transition {
      days          = var.transition_infrequent_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.transition_glacier_days
      storage_class = "GLACIER"
    }


    expiration {
      days = var.expiration_days
    }
  }

  dynamic "logging" {
    for_each = var.logging_bucket != "" ? [var.logging_bucket] : []
    content {
      target_bucket = logging.value
      target_prefix = "AWSLogs/${local.account_id}/S3/${var.name}-logs/"
    }
  }

  // TODO not support yet - https://github.com/terraform-providers/terraform-provider-aws/issues/9459
  /*object_level_logging {
    target_trail = var.target_trail
    events       = "Read/Write"
  }*/

  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  /*tags = merge(
  var.tags,
  {
    Security = "SSE:AWS"
  }
  )*/
}

resource "aws_s3_bucket_public_access_block" "default" {
  depends_on = [
    aws_s3_bucket.default]
  bucket     = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# https://docs.aws.amazon.com/macie/latest/userguide/macie-setting-up.html#macie-setting-up-enable
# https://www.terraform.io/docs/providers/aws/r/macie_s3_bucket_association.html
# move to AWS s3 example
//resource "aws_macie_s3_bucket_association" "example" {
//  bucket_name = "tf-macie-example"
//  prefix      = "data"
//
//  classification_type {
//    one_time = "FULL"
//  }
//}
