output "ec2_instance_profile" {
  description = "name of the instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}
