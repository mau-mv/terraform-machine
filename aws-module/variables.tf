variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "ec2_instance_type" {
  description = "The type of EC2 instance"
  type        = string
}

variable "rds_instance_type" {
  description = "The type of RDS instance"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "primary_subnet_id" {
  description = "Primary subnet id"
  type        = string
}

variable "secondary_subnet_id" {
  description = "secondary subnet id"
  type        = string
}