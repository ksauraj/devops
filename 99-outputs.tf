output "private_key_path" {
  value = local_file.private_key.filename
}

output "nlb_dns_name" {
  value = aws_lb.network_lb.dns_name
}

output "bastion_public_ip" {
  value = aws_instance.bastion-instance.public_ip
}

output "pvt_1_instance_private_ip" {
  value = aws_instance.pvt-1-instance.private_ip
}

output "pvt_2_instance_private_ip" {
  value = aws_instance.pvt-2-instance.private_ip
}

output "bucker_name" {
  value = aws_s3_bucket.app_bucket.bucket  
}