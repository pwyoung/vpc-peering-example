# The "peer" and "accepter" refer to the same VPC
data "aws_region" "peer" {
  provider = aws.accepter
}

data "aws_caller_identity" "peer" {
  provider = aws.accepter
}

resource "aws_vpc_peering_connection" "requester_to_accepter" {
  provider      = aws.requester
  vpc_id        = var.requester_vpc_id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_vpc_id   = var.accepter_vpc_id

  peer_region   = data.aws_region.peer.name

}

resource "aws_vpc_peering_connection_accepter" "requester_to_accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_to_accepter.id
  auto_accept               = true
}

# Options can't be set until the connection has been accepted and is active,
# so create an explicit dependency on the accepter when setting options.

locals {
  active_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.requester_to_accepter.id
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.requester
  vpc_peering_connection_id = local.active_vpc_peering_connection_id
  requester {
    # This will fail if the VPC isn't configured to support hostnames
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = local.active_vpc_peering_connection_id
  accepter {
    # This will fail if the VPC isn't configured to support hostnames
    allow_remote_vpc_dns_resolution = true
  }
}

# Routes

###################
# This VPC Routes #  Route from THIS route table to PEER cidr
###################
resource "aws_route" "this_routes" {
  provider = aws.this

  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  count                     = var.from_this ? length(local.this_routes) : 0
  route_table_id            = local.this_routes[count.index].rts_id
  destination_cidr_block    = local.this_routes[count.index].dest_cidr

}

###################
# Peer VPC Routes #  Route from PEER route table to THIS cidr
###################
resource "aws_route" "peer_routes" {
  provider = aws.peer

  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  count                     = var.from_peer ? length(local.peer_routes) : 0
  route_table_id            = local.peer_routes[count.index].rts_id
  destination_cidr_block    = local.peer_routes[count.index].dest_cidr

}