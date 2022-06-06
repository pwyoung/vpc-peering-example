
# https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
module "ec2_instance" {
  count = var.number_of_ec2_instances

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.ec2_instance_name_prefix}-${count.index}"

  instance_type          = var.ec2_instance_type

  key_name               = var.ec2_key_name

  vpc_security_group_ids = [var.security_group_id]

  subnet_id              = element("${var.subnets}", count.index % length("${var.subnets}") )

  availability_zone      = element("${var.azs}", count.index % length("${var.subnets}") )

  iam_instance_profile = var.iam_instance_profile

  monitoring = true

  #root_block_device =
  enable_volume_tags = false

  user_data = var.ec2_user_data

  ami = var.ami

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
  }

}