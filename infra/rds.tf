
resource "aws_db_subnet_group" "private_group" {
  name       = "private"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Security group for RDS connection"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Postgresql"
    from_port   = 5432
    to_port     = 5432
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
}
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.11"
  instance_class         = "db.t3.micro"
  identifier             = "breadshelf"
  username               = "breadshelf"
  db_subnet_group_name   = aws_db_subnet_group.private_group.name
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
}

output "db_host" {
  value = aws_db_instance.postgres.address
}
