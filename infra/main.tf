provider "aws" {
  region = "us-east-2"
}

resource "aws_ecr_repository" "breadshelf_repo" {
  name                 = "breadshelf"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repo_arn" {
  value = aws_ecr_repository.breadshelf_repo.arn
}