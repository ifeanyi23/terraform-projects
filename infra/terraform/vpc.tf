# resource "aws_vpc" "vpc" {
#   cidr_block           = var.vpc_cidr_block
#   instance_tenancy     = "default"
#   enable_dns_hostnames = true
#   tags = {
#     Name = "${local.workspace["environment"]}-${var.vpc_name}"
#   }
# }

# resource "aws_subnet" "subnet_1" {
#   cidr_block              = var.subnet_1_cidr_block
#   vpc_id                  = aws_vpc.vpc.id
#   availability_zone       = var.availability_zone_1
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "${local.workspace["environment"]}-${var.subnet_1_name}"
#   }
# }

# resource "aws_subnet" "subnet_2" {
#   cidr_block              = var.subnet_2_cidr_block
#   vpc_id                  = aws_vpc.vpc.id
#   availability_zone       = var.availability_zone_2
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "${local.workspace["environment"]}-${var.subnet_2_name}"
#   }
# }

# resource "aws_subnet" "subnet_3" {
#   cidr_block              = var.subnet_3_cidr_block
#   vpc_id                  = aws_vpc.vpc.id
#   availability_zone       = var.availability_zone_3
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "${local.workspace["environment"]}-${var.subnet_3_name}"
#   }
# }

# resource "aws_internet_gateway" "gateway" {
#   vpc_id = aws_vpc.vpc.id
#   tags = {
#     Name = "${local.workspace["environment"]}-${var.internet_gw_name}"
#   }
# }

# resource "aws_eip" "eip" {
#   domain     = "vpc"
#   depends_on = [aws_internet_gateway.gateway]
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.subnet_1.id

#   tags = {
#     Name = "${local.workspace["environment"]}-${var.nat_gw_name}"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.gateway]
# }

# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.vpc.id


#   tags = {
#     Name = "${local.workspace["environment"]}-public-rt"
#   }
# }

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "${local.workspace["environment"]}-private-rt"
#   }
# }

# resource "aws_route" "public_route" {
#   route_table_id         = aws_route_table.public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.gateway.id
# }

# resource "aws_route" "public_route_2" {
#   route_table_id              = aws_route_table.public_rt.id
#   destination_ipv6_cidr_block = "::/0"
#   gateway_id                  = aws_internet_gateway.gateway.id
# }

# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gateway.id
# }

# resource "aws_route_table_association" "public-route-tb-1" {
#   subnet_id      = aws_subnet.subnet_1.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table_association" "private-route-tb-2" {
#   subnet_id      = aws_subnet.subnet_2.id
#   route_table_id = aws_route_table.private_rt.id
# }

# resource "aws_route_table_association" "private-route-tb-3" {
#   subnet_id      = aws_subnet.subnet_3.id
#   route_table_id = aws_route_table.private_rt.id
# }

