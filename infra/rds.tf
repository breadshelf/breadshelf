
resource "aws_db_subnet_group" "private_group" {
    name = "private"
    subnet_ids = [aws_subnet.private.id]
}

resource "aws_db_instance" "postgres" {
    allocated_storage = 20
    engine = "postgresql"
    instance_class = "db.t3.micro"
    identifier = "breadshelf"
    username = "breadshelf"
    db_subnet_group_name = aws_db_subnet_group.private_group.name
}