variable "name" {
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "transition_infrequent_days" {
  default = 30
  # cost is in multiple of 30d
  # cost for min of 128KB
}

variable "transition_glacier_days" {
  default = 60
  # cost is a min of 90d
}

variable "expiration_days" {
  default = 7*365+2 # 7y for financial, +2 for max number of leap years
}

variable "logging_bucket" {
  type = string
  default = ""
}

variable "sse_algorithm" {
  type = string
  default = "aws:kms:sse"
}
variable "kms_key_arn" {
  type = string
  default = null
}

//variable "target_trail" {
//  type = string
//}

