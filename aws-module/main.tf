provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "main" {
  bucket = var.s3_bucket_name
}

resource "aws_instance" "main" {
  ami           = "ami-06c68f701d8090592"
  instance_type = var.ec2_instance_type

  tags = {
    Name = "EC2Instance"
  }
}

resource "aws_db_instance" "main" {
  identifier              = "example-rds"
  instance_class          = var.rds_instance_type
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  username                = "admin"
  password                = "password1234"
  skip_final_snapshot     = true

  db_subnet_group_name    = aws_db_subnet_group.main.name

  tags = {
    Name = "RDSInstance"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "rds-subnet-group"
  subnet_ids = [var.primary_subnet_id, var.secondary_subnet_id]
}

