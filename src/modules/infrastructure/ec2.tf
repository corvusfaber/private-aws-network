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
