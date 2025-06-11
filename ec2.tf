resource "aws_security_group" "allow_ssh_http" {
  name   = "web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "public_vm" {
  ami                         = "ami-0261755bbcb8c4a84"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.generated.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = { Name = "public-nginx" }
}

resource "aws_instance" "private_vm" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  key_name               = aws_key_pair.generated.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = { Name = "private-vm" }
}
