resource "aws_s3_bucket" "main" {
  bucket              = "${var.name}-logs"
  acl                 = "log-delivery-write"
  acceleration_status = "Enabled"

  versioning {
    enabled = false
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix  = "log/"
    tags {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    "Name"           = "${var.name}-logs"
    "Description"    = "Bucket of logs"
    "Terraform"      = "true"
    #"Application ID" = ""
    "Security"       = "SSE:AWS"
    #"Cost Center"    = "${var.tag_cost_center}"
  }
}
