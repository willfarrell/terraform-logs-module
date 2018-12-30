variable "name" {}
variable "tags" {
  type = "map"
  default = {}
}
variable "transition_infrequent_days" {
  default = 30
}
variable "transition_glacier_days" {
  default = 60
}
variable "expiration_days" {
  default = 365
}
