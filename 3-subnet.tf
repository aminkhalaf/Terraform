# create 2 Public subnets
resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "${var.cidr_block_public_subnet1}"
  availability_zone = "us-east-2a"
  tags = {
      Name = "${var.customer}.${var.env_name}_public_subnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "${var.cidr_block_public_subnet2}"
  availability_zone = "us-east-2b"
  tags = {
      Name = "${var.customer}.${var.env_name}_public_subnet2"
  }
}

# 2private subnets with nat
resource "aws_subnet" "private_nat_a1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.cidr_block_private_sub_a1}"
  availability_zone = "us-east-2a"
  tags = {
    Name = "${var.customer}_${var.env_name}_private_subneta1_nat"
  }
}

resource "aws_subnet" "private_nat_b1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.cidr_block_private_sub_b1}"
  availability_zone = "us-east-2b"
  tags = {
    Name = "${var.customer}_${var.env_name}_private_subnetb1_nat"
  }
}

# 2 privates regular subnets
resource "aws_subnet" "private_a2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.cidr_block_private_sub_a2}"
  availability_zone = "us-east-2a"

  tags = {
    Name = "${var.customer}_${var.env_name}_private_subneta2"
  }
}

resource "aws_subnet" "private_b2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.cidr_block_private_sub_b2}"
  availability_zone = "us-east-2b"

  tags = {
    Name = "${var.customer}_${var.env_name}_private_subnetb2"
  }
}

# internet gatway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
      Name = "${var.customer}_${var.env_name}_igw"
  }
}

# elastic IP
resource "aws_eip" "main" {
  vpc = true
}

# NAT gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public1.id
  tags = {
    Name = "${var.customer}_${var.env_name}_nat_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

# route table
# public route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.customer}_${var.env_name}_public_rt"
  }
}

# route table private with nat
resource "aws_route_table" "private_nat" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = "${var.customer}_${var.env_name}_private_nat_rt"
  }
}

# route table private regular subnet
resource "aws_route_table" "regular_private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.customer}_${var.env_name}_private_pure_rt"
  }
}

# subnets association

# public subnets
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# private with nat subnets
resource "aws_route_table_association" "private_nat_a1" {
  subnet_id      = aws_subnet.private_nat_a1.id
  route_table_id = aws_route_table.private_nat.id
}
resource "aws_route_table_association" "private_nat_b1" {
  subnet_id      = aws_subnet.private_nat_b1.id
  route_table_id = aws_route_table.private_nat.id
}

#private regular subnets 
resource "aws_route_table_association" "private_a2" {
  subnet_id      = aws_subnet.private_a2.id
  route_table_id = aws_route_table.regular_private.id
}
resource "aws_route_table_association" "private_b2" {
  subnet_id      = aws_subnet.private_b2.id
  route_table_id = aws_route_table.regular_private.id
}