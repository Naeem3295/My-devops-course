# Bastion Host
resource "aws_instance" "bastion" {
  ami                    = "ami-0e8bf7e1d1f339c74"
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_name

  tags = {
    Name        = "${var.project_name}-bastion"
    Environment = var.environment
  }
}

# App Server
resource "aws_instance" "app" {
  ami                    = "ami-0e8bf7e1d1f339c74"
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.app_sg_id]
  key_name               = var.key_name

  tags = {
    Name        = "${var.project_name}-app-server"
    Environment = var.environment
  }
}

# Database Server
resource "aws_instance" "db" {
  ami                    = "ami-0e8bf7e1d1f339c74"
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.db_sg_id]
  key_name               = var.key_name

  tags = {
    Name        = "${var.project_name}-db-server"
    Environment = var.environment
  }
}