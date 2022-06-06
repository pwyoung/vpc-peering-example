# See
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
#   https://github.com/hashicorp/terraform-provider-aws/issues/9901#issuecomment-888758619

locals {
  ports = var.ports
  ids = var.ec2_instance_ids
}

resource "aws_lb_target_group_attachment" "target_group" {
  for_each = {
     for pair in setproduct(local.ids,local.ports) : "${pair[1]} ${pair[0]}" => {
      target_id        = pair[0]
      port = pair[1]
    }
  }

  target_id = each.value.target_id
  port = each.value.port

  target_group_arn = "${var.target_group_arn}"

}
