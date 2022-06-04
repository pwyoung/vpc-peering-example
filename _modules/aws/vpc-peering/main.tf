
variable "this_vpc_id" {}
variable "peer_vpc_id" {}

variable "this_vpc_region" {}
variable "peer_vpc_region" {}

output "vpc_peering_accept_status" {
  value = module.single_account_multi_region.vpc_peering_accept_status
}

provider "aws" {
  alias      = "this"
  region     = var.this_vpc_region
}

provider "aws" {
  alias      = "peer"
  region     = var.peer_vpc_region
}

module "single_account_multi_region" {
  # Use a fork since that code has been manually scanned
  source = "git@github.com:pwyoung/terraform-aws-vpc-peering.git"

  providers = {
    aws.this = aws.this
    aws.peer = aws.peer
  }

  this_vpc_id = var.this_vpc_id
  peer_vpc_id = var.peer_vpc_id

  auto_accept_peering = true

  tags = {
    Name        = "tf-single-account-multi-region"
    Environment = "Test"
  }
}