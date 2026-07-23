resource "aws_instance" "frontend" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = "keypair"

  tags = {
    Name = "Frontend"
  }
}

resource "aws_instance" "backend" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = "keypair"

  tags = {
    Name = "Backend"
  }
}

resource "aws_instance" "database" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = "keypair"

  tags = {
    Name = "Database"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = "keypair"

  tags = {
    Name = "Jenkins"
  }
}
