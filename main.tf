resource "aws_s3_bucket" "main" {
  bucket              = "${var.name}-${terraform.workspace}-logs"
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
      days          = "${var.transition_infrequent_days}"
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = "${var.transition_glacier_days}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${var.expiration_days}"
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
