
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-00e428798e77d38d9"]
  }
}

resource "aws_key_pair" "rails" {
  key_name   = "breadshelf-key"
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


resource "aws_iam_role" "ec2_cloudwatch" {
  name = "ec2-cloudwatch-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach CloudWatch policy
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2_cloudwatch" {
  name = "ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch.name
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.rails.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.rails.key_name
  user_data                   = file("${path.module}/user-data.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch.name

  tags = {
    Name = "Breadshelf"
  }
}

output "ec2_public_ip" {
  value       = aws_instance.server.public_ip
  description = "Public IP address of the EC2 instance"
}