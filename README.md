# S3 Logs
Bucket for logs with lifecycle archiving

## Use
```hcl-terraform
module "logs" {
  provider = "aws.edge"
  source   = "git@github.com:willfarrell/terraform-s3-logs-module"
  name     = "${var.name}-${terraform.workspace}"
  #kms_key_id = "${}" # Not possible as of 2018-07-15
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
