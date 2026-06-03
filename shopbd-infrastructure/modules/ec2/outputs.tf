output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = aws_instance.bastion.public_ip
}

output "app_private_ip" {
  description = "App server private IP"
  value       = aws_instance.app.private_ip
}

output "db_private_ip" {
  description = "Database server private IP"
  value       = aws_instance.db.private_ip
}