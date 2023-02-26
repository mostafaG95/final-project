resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc"
  }
}

# -----------------------------------------public-sub------------------------------------
resource "aws_subnet" "pub1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-sub1"
    "kubernetes.io/cluster/eks-cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}
resource "aws_subnet" "pub2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-sub2"
    "kubernetes.io/cluster/eks-cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# -----------------------------------------private-sub------------------------------------
resource "aws_subnet" "pv1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-sub1"
    "kubernetes.io/cluster/eks-cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "pv2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-sub2"
    "kubernetes.io/cluster/eks-cluster" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# -----------------------------------------"internet-gw"------------------------------------
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "eks-gw"
  }
}

# -----------------------------------------"pub-rout-table"------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rw"
  }
}

# -----------------------------------------"nat-gw"-------------------------------------------------

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub1.id
  tags = {
    Name = "eks--nat-gw"
  }
}

# -----------------------------------------"private-rout-table"------------------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "rw-private"
  }
}

# -----------------------------------------"rout-table-association"------------------------------------
resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pv1" {
  subnet_id      = aws_subnet.pv1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "pv2" {
  subnet_id      = aws_subnet.pv2.id
  route_table_id = aws_route_table.private.id
}


# --------------------------------------"aws_security_group"-----------------------------
resource "aws_security_group" "eks" {
  name        = "eks-sec-group"
  description = "Allow HTTP traffic from anywhere"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}