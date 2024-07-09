output "s3_bucket_name" {
  value = aws_s3_bucket.main.bucket
}

output "ec2_instance_public_ip" {
  value = aws_instance.main.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}
