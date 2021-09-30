# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

# VPC
#--------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "vpc-${var.group}-${var.env}"
  }
}

# PUBLIC SUBNETS
# -------
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "subnet-${var.group}-${var.env}-pub-${count.index + 1}"
    Scope = "public"
  }
}

# PRIVATE SUBNETS
# -------
resource "aws_subnet" "private" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "subnet-${var.group}-${var.env}-prv-${count.index + 1}"
    Scope = "private"
  }
}

# INTERNET GATEWAY
# ----------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "igw-${var.group}-${var.env}"
  }
}

# ROUTE TABLE
# -----------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "rtbl-${var.group}-${var.env}-pub"
    Scope = "public"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

# ELASTIC IP FOR NATGATEWAY
# -------------------------
resource "aws_eip" "ngw" {
  count = var.az_count
  vpc   = true

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "eip-${var.group}-${var.env}-${count.index + 1}"
  }
}

# NATGATEWAY
# ----------
resource "aws_nat_gateway" "ngw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.ngw.*.id, count.index)

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "ngw-${var.group}-${var.env}-${count.index + 1}"
  }
}

# PRIVATE ROUTETABLE
# ------------------
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = "rtbl-${var.group}-${var.env}-${count.index + 1}-prv"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}
