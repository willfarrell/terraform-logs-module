# S3 Logs
Bucket for logs with lifecycle archiving

## Use
```hcl-terraform
module "logs" {
  source = "git@github.com:willfarrell/terraform-s3-logs-module"
  name = "${var.name}"
}
resource "aws_s3_bucket" "main" {
  ...
  logging {
    target_bucket = "${modules.logs.id}"
    target_prefix = "log/"
  }
  ...
}
```
