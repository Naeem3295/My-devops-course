output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = module.ec2.bastion_public_ip
}

output "app_private_ip" {
  description = "App server private IP"
  value       = module.ec2.app_private_ip
}

output "db_private_ip" {
  description = "Database server private IP"
  value       = module.ec2.db_private_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}