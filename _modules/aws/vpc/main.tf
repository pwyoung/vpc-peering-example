# All VARIABLEs (appearing as "${var.VARIABLE}" below)
# must be declared in ./variables.tf

# https://registry.terraform.io/modules/terraform-aws-modules/vpc
# https://github.com/terraform-aws-modules/terraform-aws-vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_id}-${var.environment}-${var.aws_region}"

  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  single_nat_gateway = var.single_nat_gateway

  enable_nat_gateway = var.enable_nat_gateway

  # https://registry.terraform.io/modules/terraform-aws-modules/vpn-gateway/aws/latest
  # enable_vpn_gateway = true

  # Support VPC endpoint interfaces DNS names
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
  }
}
