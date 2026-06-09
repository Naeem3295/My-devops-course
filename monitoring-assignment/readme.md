
# 🚀 Module 8: Complete DevOps Monitoring & Deployment Solution

## 📋 Project Overview

This project demonstrates a complete **DevOps monitoring and deployment solution** using industry-standard tools. The infrastructure is provisioned using **Terraform** on AWS EC2, and all monitoring tools are containerized using **Docker Compose**. A **CI/CD pipeline** using GitHub Actions enables automated deployment on every code push.

**Server IP:** `34.227.49.172`

---

## 🏗️ Architecture
┌─────────────────────────────────────────────────────────────────┐
│ AWS Cloud │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ EC2 Instance (34.227.49.172) │ │
│ │ ┌─────────┐ ┌──────────┐ ┌─────────┐ ┌──────────┐ │ │
│ │ │ Grafana │ │Prometheus│ │ Loki │ │Promtail │ │ │
│ │ │ Port3000│ │ Port9090 │ │Port3100 │ │ Port9080 │ │ │
│ │ └────┬────┘ └────┬─────┘ └────┬────┘ └────┬─────┘ │ │
│ │ │ │ │ │ │ │
│ │ ┌────┴────────────┴─────────────┴────────────┴─────┐ │ │
│ │ │ Node Exporter (Port 9100) │ │ │
│ │ └───────────────────────────────────────────────────┘ │ │
│ └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘

text

---

## 🛠️ Technologies Used

| Category | Tools |
|----------|-------|
| **Infrastructure as Code** | Terraform |
| **Cloud Provider** | AWS EC2 (Ubuntu 22.04) |
| **Container Orchestration** | Docker, Docker Compose |
| **Monitoring** | Prometheus, Node Exporter |
| **Visualization** | Grafana |
| **Logging** | Loki, Promtail |
| **CI/CD** | GitHub Actions |

---

## 📊 Grafana Dashboard Metrics

| Metric | Description |
|--------|-------------|
| **CPU Usage** | System, User, I/O wait, IRQ utilization |
| **Memory Usage** | Total, Used, Cache, Buffer, Free memory |
| **Disk Usage** | Read/Write I/O, Disk space utilization |
| **Network Traffic** | Incoming/Outgoing bytes and packets |
| **System Logs** | Real-time logs via Loki |

---

## 🚀 Live Access

| Service | URL | Credentials |
|---------|-----|-------------|
| **Grafana Dashboard** | http://34.227.49.172:3000 | admin / admin |
| **Prometheus Metrics** | http://34.227.49.172:9090 | - |
| **Node Exporter Metrics** | http://34.227.49.172:9100/metrics | - |
| **Loki API** | http://34.227.49.172:3100/ready | - |

---

## 🔧 Deployment Guide

### Prerequisites

- AWS Account
- Terraform installed locally
- GitHub Account
- SSH Key Pair

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/monitoring-assignment.git
cd monitoring-assignment
Step 2: Configure AWS Credentials
bash
aws configure
# Enter your Access Key ID, Secret Key, region (us-east-1)
Step 3: Deploy Infrastructure with Terraform
bash
terraform init
terraform plan
terraform apply -auto-approve
Actual Output from Deployment:

text
Apply complete! Resources: 2 added, 0 changed, 1 destroyed.

Outputs:

grafana_url = "http://34.227.49.172:3000"
public_ip = "34.227.49.172"
Step 4: Access Grafana Dashboard
Open your browser and navigate to:

👉 http://34.227.49.172:3000

Login Credentials:

Username: admin

Password: admin

Step 5: Data Sources Configuration
After logging into Grafana:

Connections → Data sources → Add data source

Prometheus: URL http://prometheus:9090 → Save & Test

Loki: URL http://loki:3100 → Save & Test

Step 6: Import Dashboard
Dashboards → Import

Enter ID: 1860 (Node Exporter Full)

Select Prometheus data source

Click Import

🔄 CI/CD Pipeline (GitHub Actions)
The pipeline automatically deploys updates when code is pushed to the main branch.

Workflow File: .github/workflows/deploy.yml
yaml
name: Deploy Monitoring Stack

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: SSH and Deploy
        uses: appleboy/ssh-action@v0.1.5
        with:
          host: ${{ secrets.SERVER_IP }}
          username: ubuntu
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /home/ubuntu
            docker-compose pull
            docker-compose up -d --force-recreate
GitHub Secrets Required
Secret Name	Value
SERVER_IP	34.227.49.172
SSH_PRIVATE_KEY	Content of monitoring-key file


<img width="1366" height="635" alt="Garafana login page 2" src="https://github.com/user-attachments/assets/08a8945b-a528-45bf-a38a-08272967176f" />

<img width="1191" height="677" alt="Grafana login page" src="https://github.com/user-attachments/assets/b7d1593e-ee62-434c-86cb-db693a42afa5" />


<img width="1349" height="672" alt="loki log" src="https://github.com/user-attachments/assets/ca849fb3-65fd-48fc-9287-f716069bd05a" />


<img width="1351" height="664" alt="LOKI" src="https://github.com/user-attachments/assets/e185c5e1-5763-41c6-9ac2-ac4e01674e61" />


<img width="1359" height="681" alt="prometheus dashboard" src="https://github.com/user-attachments/assets/75e2d07d-af5a-4e1e-a223-af484d1a2340" />


<img width="1352" height="684" alt="prometheus" src="https://github.com/user-attachments/assets/1550941c-47fd-44eb-8aa9-b69967c8348f" />






