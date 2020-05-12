resource "aws_security_group" "default" {
  name        = local.aws_security_group_name
  description = "etcd security group"
  vpc_id      = local.aws_vpc_id 
  tags = local.tags

  # etcd peer + client traffic within the etcd nodes themselves
  ingress {
    from_port = 2379
    to_port   = 2380
    protocol  = "tcp"
    self      = true
  }

  # etcd client traffic from ELB
  egress {
    from_port = 2379
    to_port   = 2380
    protocol  = "tcp"
    self      = true
  }

  # etcd client traffic from the VPC
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [local.aws_vpc_cidr_block]
  }

  egress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [local.aws_vpc_cidr_block]
  }
}

