
resource "aws_vpc" "mf_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.mf_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.mf_vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = "eu-west-1a"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mf_vpc.id
  tags = {
    Name = "mf-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.mf_vpc.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.mf_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

resource "aws_instance" "public-ec2-instance" {
  ami           = "ami-0c38b837cd80f13bb" # Ubuntu Linux AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_sg.id]

  tags = {
    Name = "public-ec2-instance"
  }
}

resource "aws_instance" "private-ec2-instance" {
  ami           = "ami-0c38b837cd80f13bb" # Ubuntu Linux AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.id]

  tags = {
    Name = "private-ec2-instance"
  }
}
