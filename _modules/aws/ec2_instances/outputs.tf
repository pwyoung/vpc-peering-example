# https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/blob/master/outputs.tf

output "public_ips" {
  description = "EC2 public IPs"
  value       = module.ec2_instance.*.public_ip
}

output "private_ips" {
  description = "EC2 private IPs"
  value       = module.ec2_instance.*.private_ip
}

output "ids" {
  description = "EC2 instance IDs"
  value       = module.ec2_instance.*.id
}

