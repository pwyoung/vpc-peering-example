# https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/blob/master/outputs.tf

output "ami" {
  value       = data.aws_ami.this.id
}

