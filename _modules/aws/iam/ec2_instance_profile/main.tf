# This has IAM resources related to EC2 instance profiles:
#   aws_iam_policy
#   aws_iam_role
#   aws_iam_role_policy_attachment
#   aws_iam_instance_profile
# They each have a name given by the variable "ec2_name_prefix"

locals {
  ec2_name_prefix = var.ec2_instance_name_prefix

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
  }

  default_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:Get*",
            "s3:List*",
            "s3-object-lambda:Get*",
            "s3-object-lambda:List*"
          ],
          "Resource" : [
            "arn:aws:s3:::*"
          ]
        },
      ]
    }
  )

  default_assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = ["ec2.amazonaws.com"]
          }
        },
      ]
    }
  )

}

resource "aws_iam_policy" "ec2_iam_policy" {
  name        = local.ec2_name_prefix
  path        = "/"
  description = "Allow most things"

  policy = var.policy != "" ? var.policy : local.default_policy

  tags = local.tags
}


# Create a role and allow it to be assumed by an EC2 intance
resource "aws_iam_role" "ec2_custom_role" {
  name = local.ec2_name_prefix

  # This is called the "Trust Relationship" in the AWS Management Console
  assume_role_policy = var.assume_role_policy != "" ? var.assume_role_policy : local.default_assume_role_policy

  tags = local.tags
}

# Attach the ec2 IAM Policy to the ec2 IAM Role
resource "aws_iam_role_policy_attachment" "attach_ec2_policy_and_role" {
  role       = aws_iam_role.ec2_custom_role.name
  policy_arn = aws_iam_policy.ec2_iam_policy.arn
}


# Create the EC2 Instance Profile, which contains the EC2 custom role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = local.ec2_name_prefix
  role = aws_iam_role.ec2_custom_role.name
}
