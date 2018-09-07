variable "name" {}
#variable "tag_name" {}
variable "transition_infrequent_days" {
  default = 30
}
variable "transition_glacier_days" {
  default = 60
}
variable "expiration_days" {
  default = 365
}
