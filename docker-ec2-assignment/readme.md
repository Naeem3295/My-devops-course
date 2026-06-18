# 🐳 Docker Installation and Networking on AWS EC2

> **Assignment:** Module 9 - Docker Installation and Networking  



## 📌 Table of Contents
1. [Overview](#overview)
2. [Tools Used](#tools-used)
3. [Step 1: Terraform Configuration](#step-1-terraform-configuration)
4. [Step 2: Deploy EC2 Instance](#step-2-deploy-ec2-instance)
5. [Step 3: Docker Installation](#step-3-docker-installation)
6. [Step 4: Docker Network Types](#step-4-docker-network-types)
   - [Bridge Network](#1-bridge-network-default)
   - [Host Network](#2-host-network)
   - [None Network](#3-none-network)
   - [Custom Bridge Network](#4-custom-bridge-network)




## 📖 Overview

This assignment demonstrates:
- **Infrastructure as Code (IaC):** Using Terraform to deploy an AWS EC2 instance
- **Docker Installation:** Automated via User Data script
- **Docker Networking:** Exploring 4 different network types:
  - Bridge Network (Default)
  - Host Network
  - None Network
  - Custom Bridge Network

---

## 🛠️ Tools Used

| Tool | Version | Purpose |
|------|---------|---------|
| **Terraform** | v1.15.4 | Infrastructure as Code |
| **AWS CLI** | v2.34.59 | AWS Authentication |
| **AWS EC2** | t2.micro | Compute Instance |
| **Ubuntu AMI** | 22.04 LTS | Operating System |
| **Docker** | 29.1.3 | Container Runtime |

---

## 📁 Step 1: Terraform Configuration

### 1.1 Project Structure
📁 docker-ec2-assignment/
├── provider.tf # AWS Provider Configuration
├── variables.tf # Input Variables
├── main.tf # Main Resources (EC2 + Security Group)
└── outputs.tf # Output Values

text

### 1.2 `provider.tf` - AWS Provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}
1.3 variables.tf - Input Variables
hcl
variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "shopbd-docker-server"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for ap-southeast-1"
  type        = string
  default     = "ami-06c2685db9a20aac5"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
  default     = "naeem-shopbd-key"
}
1.4 main.tf - EC2 Instance + Security Group
hcl
# Security Group
resource "aws_security_group" "shopbd_docker_sg" {
  name        = "shopbd-docker-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shopbd-docker-sg"
  }
}

# EC2 Instance - Ubuntu
resource "aws_instance" "shopbd_docker_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.shopbd_docker_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = var.instance_name
  }
}
1.5 outputs.tf - Output Values
hcl
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.shopbd_docker_server.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.shopbd_docker_server.id
}
🚀 Step 2: Deploy EC2 Instance
2.1 Initialize Terraform
powershell
C:\Users\MN\Desktop\terraform init
Output:

text
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.100.0...
Terraform has been successfully initialized!
2.2 Plan
powershell
C:\Users\MN\Desktop\terraform plan
Output:

text
Plan: 2 to add, 0 to change, 0 to destroy.
2.3 Apply
powershell
C:\Users\MN\Desktop\terraform apply
Output:

text
aws_security_group.shopbd_docker_sg: Creation complete
aws_instance.shopbd_docker_server: Creation complete

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
instance_id = "i-0773e0ffa317db518"
instance_public_ip = "18.141.207.24"
2.4 SSH Connection
powershell
ssh -i "naeem-shopbd-key.pem" ubuntu@18.141.207.24
🐳 Step 3: Docker Installation
3.1 Verify Docker Version
bash
docker --version
Output:

text
Docker version 29.1.3, build 29.1.3-0ubuntu3~22.04.2
3.2 Run Hello-World
bash
docker run hello-world
Output:

text
Hello from Docker!
This message shows that your installation appears to be working correctly.
🌐 Step 4: Docker Network Types
1. Bridge Network (Default)
Explanation: Default network driver. Containers get private IPs (172.17.0.x) and communicate via IP addresses.

Commands:
bash
# Run 2 Nginx containers
docker run -d --name web1 -p 8081:80 nginx
docker run -d --name web2 -p 8082:80 nginx

# Check IP addresses
docker inspect web1 | grep IPAddress
docker inspect web2 | grep IPAddress
Output:

text
"IPAddress": "172.17.0.2"
"IPAddress": "172.17.0.3"
bash
# Test communication via IP
docker exec web2 curl -s http://172.17.0.2
Output:

html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
</html>
Key Feature: Containers communicate using IP addresses.

2. Host Network
Explanation: Container shares the host's network stack directly. No port mapping required.

Commands:
bash
# Run container with host network
docker run -d --name web-host --network host nginx

# Access directly via host port 80
curl http://localhost:80
Output:

html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
</html>
Key Feature: Container uses host's network directly.

3. None Network
Explanation: Complete network isolation. Container has only loopback interface (lo).

Commands:
bash
# Run container with none network
docker run -d --name isolated --network none nginx

# Check network settings
docker inspect isolated | grep -A 10 "NetworkSettings"
Output:

text
"Networks": {
    "none": {
        "IPAMConfig": null,
        "Gateway": "",
        "IPAddress": "",    ← Empty!
        "IPPrefixLen": 0,
        "MacAddress": ""
    }
}
Key Feature: No external network access. Complete isolation.

4. Custom Bridge Network
Explanation: User-defined bridge network with DNS resolution. Containers can communicate using container names.

Commands:
bash
# Create custom network
docker network create my-app-network

# Run containers on custom network
docker run -d --name app1 --network my-app-network nginx
docker run -d --name app2 --network my-app-network nginx

# Test communication using container name (DNS resolution!)
docker exec app2 curl -s http://app1 | head -n 5
Output:

html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
Key Feature: Containers communicate using container names (DNS resolution).

4.5 List All Networks
bash
docker network ls
Output:

text
NETWORK ID     NAME             DRIVER    SCOPE
37e1e6ba6dea   bridge           bridge    local
5e4a79b17b46   host             host      local
15b4c7751b06   my-app-network   bridge    local
05999cdd0466   none             null      local

<img width="847" height="479" alt="Dcoker hello " src="https://github.com/user-attachments/assets/9ccee758-cc75-46e0-ad01-ac7444ac5c06" />

<img width="880" height="573" alt="docker network" src="https://github.com/user-attachments/assets/0b92011f-b8ab-4c62-ac1c-9a30bd2c0aa5" />


<img width="840" height="387" alt="host-network" src="https://github.com/user-attachments/assets/a265ff6b-eb8c-4ca6-a8fb-f0d033cfdc92" />

<img width="843" height="213" alt="None Network" src="https://github.com/user-attachments/assets/66754a10-71e9-4385-bf5f-86f03dccbca3" />



<img width="843" height="235" alt="Custom Bridge Network" src="https://github.com/user-attachments/assets/c4b2f747-51e4-460c-beaf-c51decb5290d" />

<img width="836" height="157" alt="docker network 2" src="https://github.com/user-attachments/assets/55fb44cb-d1cf-43fa-ba2a-d58028918613" />









