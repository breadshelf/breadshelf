
resource "aws_db_subnet_group" "private_group" {
  name       = "private"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "16.11"
  instance_class       = "db.t3.micro"
  identifier           = "breadshelf"
  username             = "breadshelf"
  db_subnet_group_name = aws_db_subnet_group.private_group.name
  password             = var.db_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [ aws_security_group.rails.id ]
}

output "db_host" {
  value = aws_db_instance.postgres.endpoint
}
