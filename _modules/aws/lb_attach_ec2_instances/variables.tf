variable "target_group_arn" {
  type = string
}

variable "ec2_instance_ids" {
  type = list(string)
}

variable "ports" {
  type = list(any)
  default = [22,80]
}

