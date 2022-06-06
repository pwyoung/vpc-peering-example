variable "virtualization_type" {
  type = list(string)
}

variable "ec2_image_name" {
  type = list(string)
}

variable "owners" {
  type = list(string)
}


data "aws_ami" "this" {
  # Provider
  # The region is handled by TG

  most_recent = true

  filter {
    name   = "name"
    values = var.ec2_image_name
  }

  filter {
    name   = "virtualization-type"
    values = var.virtualization_type
  }

  owners = var.owners
}
