data "aws_region" "current" {}

resource "aws_vpc_ipam" "ipam-vpc" {
  count = var.enable_ipam == true ? 1 : 0
  operating_regions {
    region_name = data.aws_region.current.region
  }
}

resource "aws_vpc_ipam_pool" "ipam-vpc" {
  count = var.enable_ipam == true ? 1 : 0
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam-vpc[count.index].private_default_scope_id
  locale         = data.aws_region.current.region
}

resource "aws_vpc_ipam_pool_cidr" "ipam-vpc" {
  count = var.enable_ipam == true ? 1 : 0
  ipam_pool_id = aws_vpc_ipam_pool.ipam-vpc[count.index].id
  cidr         = "172.20.0.0/16"
}

resource "aws_vpc" "ipam-vpc" {
  count = var.enable_ipam == true ? 1 : 0
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool[count.index].ipam-vpc.id
  ipv4_netmask_length = 28
  depends_on = [
    aws_vpc_ipam_pool_cidr.ipam-vpc
  ]

  tags = {
    Name = var.name
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.name
  }
}