resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet" {

  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 1, 0)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_route_table" "table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table" "routing_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "association" {
  count = 1

  route_table_id = aws_route_table.table.id
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
}

resource "aws_security_group" "forwarder" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 9300
    to_port     = 9300
    cidr_blocks = [aws_subnet.subnet.cidr_block]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 9200
    to_port     = 9200
    cidr_blocks = [aws_subnet.subnet.cidr_block]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 5601
    to_port     = 5601
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
}
