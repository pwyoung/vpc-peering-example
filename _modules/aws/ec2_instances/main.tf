# TODO
# - Add root block device options

locals {
  ec2_name_prefix = var.ec2_instance_name_prefix

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
  }

  default_ingress_with_cidr_blocks = [
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "udp"
      description = "Allow UDP to port 2049 for NFSv4"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow all TCP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]


}

module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.ec2_name_prefix
  description = "Security group for ${local.ec2_name_prefix}"

  vpc_id = var.vpc_id

  ingress_cidr_blocks = var.ingress_cidr_blocks

  ingress_rules = var.ingress_rules

  egress_rules = var.egress_rules

  ingress_with_cidr_blocks = length("${var.ingress_with_cidr_blocks}") > 0 ? "${var.ingress_with_cidr_blocks}" : "${local.default_ingress_with_cidr_blocks}"

  tags = local.tags
}

# Ubuntu AMI
#   https://cloud-images.ubuntu.com/locator/ec2/
data "aws_ami" "ubuntu_private_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ec2_image_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
module "ec2_instance" {
  count = var.number_of_ec2_instances

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${local.ec2_name_prefix}-${count.index}"

  ami                    = data.aws_ami.ubuntu_private_ami.id
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]
  subnet_id              = element("${var.subnets}", count.index % length("${var.subnets}") )
  availability_zone      = element("${var.azs}", count.index % length("${var.subnets}") )

  iam_instance_profile = var.iam_instance_profile

  monitoring = true

  #root_block_device =
  enable_volume_tags = false

  user_data = var.ec2_user_data

  tags = local.tags
}