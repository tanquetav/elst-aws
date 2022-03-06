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
  route_table_id = aws_route_table.table.id
  subnet_id      = element(aws_subnet.subnet.*.id, 0)
}

resource "aws_security_group" "forwarder" {
  vpc_id      = aws_vpc.vpc.id
  description = "Allow inbound SSH and Kibana traffic"

  ingress {
    description = "Allow inbound SSH"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sg
  }

  ingress {
    description = "Allow elastic peer internal traffic"
    protocol    = "tcp"
    from_port   = 9300
    to_port     = 9300
    cidr_blocks = [aws_subnet.subnet.cidr_block]
  }

  ingress {
    description = "Allow elastic internal traffic"
    protocol    = "tcp"
    from_port   = 9200
    to_port     = 9200
    cidr_blocks = [aws_subnet.subnet.cidr_block]
  }

  ingress {
    description = "Allow inbound Kibana Access"
    protocol    = "tcp"
    from_port   = 5601
    to_port     = 5601
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sg
  }
  egress {
    description = "Allow outbound traffic"
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sg
  }
}
