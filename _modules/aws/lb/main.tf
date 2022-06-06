# See
#   https://github.com/terraform-aws-modules/terraform-aws-alb/blob/master/examples/complete-nlb/main.tf

locals {


  # For now, the ec2 instances will be added to the first target group
  # TODO: fix this. See nlb_attach_FOO code.
  default_target_groups = [
    {
      name_prefix        = "tu1-"
      backend_protocol   = "TCP_UDP"
      backend_port       = 80
      target_type        = "instance"
      preserve_client_ip = true
      tags = {
        tcp_udp = true
      }

      # Register specific targets
      # https://github.com/terraform-aws-modules/terraform-aws-alb/blob/master/examples/complete-alb/main.tf#L389
      #targets = {
      #  my_ec2 = {
      #    target_id = aws_instance.this.id
      #    port      = 80
      #  },
      #  my_ec2_again = {
      #    target_id = aws_instance.this.id
      #    port      = 8080
      #  }
      #}

    },
    {
      name_prefix      = "u1-"
      backend_protocol = "UDP"
      backend_port     = 82
      target_type      = "instance"
    },
    {
      name_prefix          = "t1-"
      backend_protocol     = "TCP"
      backend_port         = 83
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }
    },
    {
      name_prefix      = "t2-"
      backend_protocol = "TLS"
      backend_port     = 84
      target_type      = "instance"
    },
  ]

}

resource "aws_eip" "this" {
  count = length("${var.subnet_ids}")

  vpc = true
}

##################################################################
# Network Load Balancer with Elastic IPs attached
##################################################################
module "nlb" {
  # https://registry.terraform.io/modules/terraform-aws-modules/alb/aws
  source  = "terraform-aws-modules/alb/aws"
  #version = "~> 7.0"
  version = "7.0.0"

  name = "complete-nlb-changeme"

  load_balancer_type = "network"

  vpc_id = "${var.vpc_id}"

  #   Use `subnets` if you don't want to attach EIPs
  #   subnets = tolist("${var.subnet_ids}")

  #   Use `subnet_mapping` to attach EIPs
  subnet_mapping = [for i, eip in aws_eip.this : { allocation_id : eip.id, subnet_id : tolist("${var.subnet_ids}")[i] }]

  #   # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  #   access_logs = {
  #     bucket = module.log_bucket.s3_bucket_id
  #   }


  #  TCP_UDP, UDP, TCP
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP_UDP"
      target_group_index = 0
    },
    {
      port               = 82
      protocol           = "UDP"
      target_group_index = 1
    },
    {
      port               = 83
      protocol           = "TCP"
      target_group_index = 2
    },
  ]


  #
  #  TLS
  # https_listeners = [
  #   {
  #     port               = 84
  #     protocol           = "TLS"
  #     certificate_arn    = module.acm.acm_certificate_arn
  #     target_group_index = 3
  #   },
  # ]
  #
  #https_listeners = []

  target_groups = local.default_target_groups

}