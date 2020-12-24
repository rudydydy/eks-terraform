data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_count = length(data.aws_availability_zones.available.names)
  az_names = data.aws_availability_zones.available.names
  az_ids   = [
    for i in data.aws_availability_zones.available.names:
    replace(i, data.aws_availability_zones.available.id, "")
  ]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name"                                      = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public" {
	count                   = local.az_count
	availability_zone       = local.az_names[count.index] 
	cidr_block              = "10.0.${count.index * 16}.0/20"
	vpc_id                  = aws_vpc.main.id
	map_public_ip_on_launch = true

	tags = {
    "Name"                                      = "${var.cluster_name}-public-${local.az_ids[count.index]}"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}
}

resource "aws_subnet" "private" {
	count                   = local.az_count
	availability_zone       = local.az_names[count.index] 
	cidr_block              = "10.0.${(local.az_count + count.index)  * 16}.0/20"
	vpc_id                  = aws_vpc.main.id
	map_public_ip_on_launch = false

	tags = {
    "Name"                                      = "${var.cluster_name}-private-${local.az_ids[count.index]}"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.cluster_name}-igw"
  }
}

resource "aws_eip" "main" {
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    "Name" = "${var.cluster_name}-nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count          = local.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = local.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
