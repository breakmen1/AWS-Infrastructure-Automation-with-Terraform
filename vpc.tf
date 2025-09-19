terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
  }
   backend "s3" {
    bucket = "mys300259ede69013c771e40"
    key = "remote-backend.tfstate"
    region = "us-east-1"
    
  }
}
provider "aws" {
  region = "us-east-1"
}



resource "aws_vpc" "my-aws-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "MY-VPC"
  }
}

variable "aws_availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

resource "aws_subnet" "my-public-subnet" {
  vpc_id            = aws_vpc.my-aws-vpc.id
  count             = length(var.aws_availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.my-aws-vpc.cidr_block, 8, count.index + 1)
  availability_zone = element(var.aws_availability_zones, count.index)

  tags = {
    Name = "Public_subnet ${count.index + 1}"
  }
}


resource "aws_subnet" "my-private-subnet" {
  vpc_id            = aws_vpc.my-aws-vpc.id
  count             = length(var.aws_availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.my-aws-vpc.cidr_block, 8, count.index + 3)
  availability_zone = element(var.aws_availability_zones, count.index)

  tags = {
    Name = "Private_Subnet ${count.index + 1}"
  }

}


resource "aws_internet_gateway" "my-aws-igw" {
  vpc_id = aws_vpc.my-aws-vpc.id

  tags = {
    Name = "MY_IGW"
  }
}

resource "aws_route_table" "my-aws-rt" {
  vpc_id = aws_vpc.my-aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-aws-igw.id
  }
}

resource "aws_route_table_association" "my-aws-pub-rta" {
  route_table_id = aws_route_table.my-aws-rt.id
  count          = length(var.aws_availability_zones)
  subnet_id      = element(aws_subnet.my-public-subnet[*].id, count.index)
}

resource "aws_eip" "my-pub-elastic-ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my-aws-igw]
}

resource "aws_nat_gateway" "my-aws-nat" {
  subnet_id     = element(aws_subnet.my-public-subnet[*].id, 0)
  allocation_id = aws_eip.my-pub-elastic-ip.id
  depends_on    = [aws_internet_gateway.my-aws-igw]

  tags = {
    Name = "MY_NAT"
  }
}

resource "aws_route_table" "my-aws-pri-rt" {
  vpc_id = aws_vpc.my-aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-aws-nat.id
  }
  depends_on = [aws_nat_gateway.my-aws-nat]

  tags = {
    Name = "MY_PRIVATE_RT"
  }

}

resource "aws_route_table_association" "my-aws-pri-rta" {
  route_table_id = aws_route_table.my-aws-pri-rt.id
  count          = length(var.aws_availability_zones)
  subnet_id      = element(aws_subnet.my-private-subnet[*].id, count.index)

}

