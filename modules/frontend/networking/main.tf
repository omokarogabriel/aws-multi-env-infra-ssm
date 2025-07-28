

# data "aws_availability_zones" "available" {
  
# }


# ######VPC######

# resource "aws_vpc" "vpc" {
#   cidr_block = var.vpc_cidr
#   enable_dns_support = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = var.vpc_name
#     Env = var.env
#   }
# }

# #######Public Subnets######

# resource "aws_subnet" "public_subnet" {
#   count = length(data.aws_availability_zones.available.names)

#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
#   availability_zone = data.aws_availability_zones.name.names[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${var.vpc_name}-public-${count.index + 1}"
#     Env = var.env
#   }
# }


# #######Private Subnets######

# resource "aws_subnet" "private_subnet" {
#   count = length(data.aws_availability_zones.available.names)

#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(data.aws_availability_zones.available.names))
#   availability_zone = data.aws_availability_zones.name.names[count.index]

#   tags = {
#     Name = "${var.vpc_name}-private-${count.index + 1}"
#   }
# }

# #######IGW######

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "${var.vpc_name}-igw"
#   }
# }


# #######Route Table for Public Subnets######

# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "${var.vpc_name}-public-rt"
#     Env = var.env
#   }
# }


# #######Route Table Association for Public Subnets######

# resource "aws_route_table_association" "public_route_table_association" {
#   count = length(aws_subnet.public_subnet)

#   subnet_id      = aws_subnet.public_subnet[count.index].id
#   route_table_id = aws_route_table.public_route_table.id
# }


# #######NAT Gateway for Private Subnets######

# resource "aws_eip" "nat_eip" {
#   count = length(data.aws_availability_zones.available.names)
#   # vpc = true

#   tags = {
#     Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
#     Env = var.env
#   }
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   count = length(data.aws_availability_zones.available.names)

#   allocation_id = aws_eip.nat_eip[count.index].id
#   subnet_id     = aws_subnet.public_subnet[count.index].id

#   tags = {
#     Name = "${var.vpc_name}-nat-gateway-${count.index + 1}"
#     Env = var.env
#   }
# }


# #######Route Table for Private Subnets######

# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
#   }

#   tags = {
#     Name = "${var.vpc_name}-private-rt"
#     Env = var.env
#   }
# }

# #######Route Table Association for Private Subnets######

# resource "aws_route_table_association" "private_route_table_association" {
#   count = length(aws_subnet.private_subnet)

#   subnet_id      = aws_subnet.private_subnet[count.index].id
#   route_table_id = aws_route_table.private_route_table.id
# }   




data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    Env  = var.env
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
    Env  = var.env
    # SSMManaged = "true"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
    Env  = var.env
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
    Env  = var.env
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_eip" {
  count = length(var.private_subnet_cidrs)

  tags = {
    Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.vpc_name}-nat-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

