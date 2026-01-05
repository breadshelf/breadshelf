
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "rails" {
    key_name = "breadshelf-key"
    public_key = var.ec2_public_key
}

resource "aws_security_group" "rails" {
  name        = "rails-sg"
  description = "Security group for rails app"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rails-sg"
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.rails.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.rails.key_name

  tags = {
    Name = "Breadshelf"
  }
}

output "ec2_public_ip" {
    value = aws_instance.server.public_ip
    description = "Public IP address of the EC2 instance"
}