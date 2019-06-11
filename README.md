# S3 Logs
Bucket for logs with lifecycle archiving

## Use
```hcl-terraform
module "logs" {
  source   = "git@github.com:willfarrell/terraform-s3-logs-module?ref=v0.3.0"
  name     = "${local.workspace["name"]}-${terraform.workspace}-edge"
  providers = {
    aws = aws.edge
  }
  #kms_key_id = "${}" # Not possible as of 2018-07-15
  tags     = "${merge(local.tags, map(
    "Name", "Edge Logs",
    "CostCenter", "Operations"
  ))}"
}
module "logs" {
  source   = "git@github.com:willfarrell/terraform-s3-logs-module?ref=v0.3.0"
  name     = "${local.workspace["name"]}-${terraform.workspace}-${local.workspace["region"]}"
  #kms_key_id = "${}" # Not possible as of 2018-07-15
  tags     = "${merge(local.tags, map(
    "Name", "${local.workspace["region"]} Logs",
    "CostCenter", "Operations"
  ))}"
}
resource "aws_s3_bucket" "bucket_name" {
  ...
  logging {
    target_bucket = "${modules.logs.id}"
    target_prefix = "S3/bucket_name/"
  }
  ...
}
```
