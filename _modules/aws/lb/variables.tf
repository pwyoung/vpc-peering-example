variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "enable_cross_zone_load_balancing" {
  type = bool
  default = false
}
