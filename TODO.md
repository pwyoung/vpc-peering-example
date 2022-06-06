    Works, but should be cleaned up.

    These modules are needed:
    ec2_ami
    ec2_instances

    But, arguably, the code could directly call all or some of these modules:
    iam
    lb_attach_ec2_instances
    nlb
    vpc
    vpc-peering

    The modules that correctly use the Terragrunt pattern are the "ec2_" ones.
    For new modules, or refactoring old ones, look at:
    - The security group module, with files:
      - .../us-east-1/pub/sg/terragrunt.hcl
      - .../_env_common/aws/ec2-security-group.hcl
