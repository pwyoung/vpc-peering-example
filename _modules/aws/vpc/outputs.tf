# https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/outputs.tf

output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "VPC public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "VPC private subnets"
  value       = module.vpc.private_subnets
}

output "azs" {
  description = "VPC azs"
  value       = module.vpc.azs
}


