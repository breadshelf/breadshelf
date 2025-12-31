terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27"
    }
  }

  backend "s3" {
    bucket = "breadshelf-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
  required_version = ">= 1.2"
}