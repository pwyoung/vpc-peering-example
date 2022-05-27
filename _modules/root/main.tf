resource "aws_vpc" "this" {
  # Use the default "provider=aws" (which can be auto-generated)
  #provider = aws.us-east-2

  cidr_block = "10.101.0.0/16"

  tags = {
    #env      = "${var.environment}"
  }
}


