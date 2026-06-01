Module 7 Assignment
Backend Deployment with Observability and CI/CD Automation
📖 Project Overview

This project demonstrates the deployment of a Node.js backend application with a MySQL database on AWS EC2. A complete monitoring stack was implemented using Prometheus, Node Exporter, and Grafana. Deployment automation was achieved using GitHub Actions CI/CD.

🏗️ Architecture
Developer
   │
   ▼
GitHub Repository
   │
   ▼
GitHub Actions
   │
   ▼
AWS EC2 (Ubuntu 22.04)
   │
   ├── Node.js Backend
   ├── MySQL Database
   ├── Prometheus
   ├── Node Exporter
   └── Grafana
1️⃣ AWS EC2 Setup
Connect to EC2
ssh -i "New_naeem_key.pem" ubuntu@13.60.206.189
Update Server
sudo apt update
sudo apt upgrade -y

📸 Screenshot 1: EC2 Instance Running

📸 Screenshot 2: Successful SSH Connection
<img width="870" height="245" alt="mydb" src="https://github.com/user-attachments/assets/25d1a1c2-f829-406e-baa3-3e0acd8ff218" />


2️⃣ MySQL Installation & Configuration
Install MySQL
sudo apt install mysql-server -y
Verify Service
sudo systemctl status mysql
Create Database
sudo mysql -e "CREATE DATABASE mydb;"
Create User
sudo mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON mydb.* TO 'admin'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
Verify Databases
sudo mysql -e "SHOW DATABASES;"

Output:

information_schema
mydb
mysql
performance_schema
sys

📸 Screenshot 3: MySQL Database Verification

3️⃣ Node.js Backend Deployment
Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y
Verify Installation
node -v
npm -v
Clone Repository
git clone https://github.com/Naeem3295/My-devops-course.git
Navigate to Backend
cd ~/My-devops-course/Module-7-observability/app/backend
Install Dependencies
npm install
Start Application
npm start &
Verify Running Process
ps aux | grep node
4️⃣ Backend Health Verification
Health Endpoint
curl http://13.60.206.189:3000/health

Response:

{
  "status":"UP",
  "timestamp":"2026-06-01T17:04:37.084Z"
}

📸 Screenshot 4: Backend Health Endpoint

5️⃣ Node Exporter Installation
Download
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
Extract
tar xvf node_exporter-1.8.1.linux-amd64.tar.gz
Move Binary
sudo mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/
Start Exporter
/usr/local/bin/node_exporter &
Verify Metrics
curl http://localhost:9100/metrics

📸 Screenshot 5: Node Exporter Metrics

6️⃣ Prometheus Installation
Download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.53.0/prometheus-2.53.0.linux-amd64.tar.gz
Extract
tar xvf prometheus-2.53.0.linux-amd64.tar.gz
Move Files
sudo mv prometheus-2.53.0.linux-amd64 /opt/prometheus
Configure Prometheus

Edit:

sudo nano /opt/prometheus/prometheus.yml

Configuration:

global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]

  - job_name: "backend_app"
    static_configs:
      - targets: ["localhost:3000"]
Start Prometheus
cd /opt/prometheus
./prometheus --config.file=prometheus.yml &
Verify
curl http://localhost:9090/-/healthy

📸 Screenshot 6: Prometheus Targets Page

7️⃣ Grafana Installation
Download Grafana
wget https://dl.grafana.com/oss/release/grafana_11.6.0_amd64.deb
Install
sudo dpkg -i grafana_11.6.0_amd64.deb
sudo apt install -f -y
Start Grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
Verify Service
sudo systemctl status grafana-server
Configure Data Source
Grafana → Connections → Data Sources

Prometheus URL:

http://localhost:9090
Import Dashboard

Dashboard ID:

1860

Dashboard:

Node Exporter Full

Metrics Monitored:

CPU Usage
Memory Usage
Disk Usage
Network Traffic
Filesystem Usage
Uptime

📸 Screenshot 7: Grafana Dashboard

8️⃣ GitHub Actions CI/CD

Workflow File:

.github/workflows/deploy.yml
name: Deploy Backend with Observability

on:
  push:
    branches:
      - development

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Deploy to EC2
        uses: appleboy/ssh-action@v1.0.3

        with:
          host: ${{ secrets.EC2_HOST }}
          username: ubuntu
          key: ${{ secrets.SSH_KEY }}

          script: |
            cd ~/My-devops-course/Module-7-observability/app/backend
            git pull
            npm install
            pkill node || true
            npm start &
9️⃣ GitHub Secrets

Repository → Settings → Secrets and Variables → Actions

Secret	Purpose
EC2_HOST	EC2 Public IP
SSH_KEY	Private Key Content

📸 Screenshot 8: GitHub Secrets

🔟 Deployment Verification

Push code:

git add .
git commit -m "Update backend"
git push origin development

GitHub Actions automatically:

Connects to EC2
Pulls latest code
Installs dependencies
Restarts application

📸 Screenshot 9: Successful GitHub Actions Workflow

📊 Monitoring Results

The monitoring stack successfully provides:

✅ CPU Monitoring

✅ RAM Monitoring

✅ Disk Monitoring

✅ Network Monitoring

✅ System Load Monitoring

✅ Server Uptime Monitoring

Grafana Dashboard confirms all infrastructure metrics are collected from Node Exporter through Prometheus.
