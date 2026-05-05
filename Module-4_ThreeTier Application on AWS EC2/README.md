🏗️ Architecture Overview
Internet → Presentation Layer (Nginx) → Application Layer (Node.js) → Data Layer (MySQL)
               16.16.184.106              10.0.2.65:3000                10.0.3.32:3306

               
1️⃣ Network Setup (VPC & Networking)
Created VPC: 3Tier-VPC (10.0.0.0/16)
Created 3 Subnets:
3Tier-Public-Subnet (10.0.1.0/24) - Presentation Layer

3Tier-App-Subnet (10.0.2.0/24) - Application Layer

3Tier-DB-Subnet (10.0.3.0/24) - Data Layer

Created Internet Gateway & attached to VPC

Created NAT Gateway for private instances

Configured Route Tables:

Public RT: 0.0.0.0/0 → IGW

Private RT: 0.0.0.0/0 → NAT
<img width="1156" height="695" alt="https-working" src="https://github.com/user-attachments/assets/d8e19ac3-1ec7-43cf-b51a-adfe7ca415a0" />


2️⃣ Security Groups Created
Security Group	Inbound Rules	Purpose
Web-Layer-SG	HTTP (80): 0.0.0.0/0
SSH (22): My IP	Presentation Tier
App-Layer-SG	Custom TCP (3000): Web-Layer-SG
SSH (22): My IP	Application Tier
DB-Layer-SG	MySQL (3306): App-Layer-SG	Database Tier

3️⃣ EC2 Instances Launched
Instance Name	Subnet	Security Group	IP Address
3Tier-Presentation	Public Subnet	Web-Layer-SG	16.16.184.106
3Tier-Application	App Subnet	App-Layer-SG	10.0.2.65
3Tier-Database	DB Subnet	DB-Layer-SG	10.0.3.32

4️⃣ Presentation Tier (Nginx Setup)
bash
# Nginx installed and configured
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

Nginx Reverse Proxy Configuration:

nginx
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://10.0.2.65:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

5️⃣ Application Tier (Node.js Backend)
bash
# Node.js installed
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y

# Dependencies installed
npm install express mysql2 cors

Backend Code (server.js):

javascript
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
    host: '10.0.3.32',
    user: 'appuser',
   password: '123456',
    database: 'appdb'
});

// Endpoints
app.get('/health', (req, res) => {...});
app.get('/setup', (req, res) => {...});
app.get('/api/users', (req, res) => {...});
app.get('/api/test', (req, res) => {...});

app.listen(PORT, '0.0.0.0');

6️⃣ Database Tier (MySQL Setup)
bash
# MySQL installed
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql
Database Configuration:

sql
CREATE DATABASE appdb;
CREATE USER 'appuser'@'%' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON appdb.* TO 'appuser'@'%';
FLUSH PRIVILEGES;
Bind Address Changed:

ini
# /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address = 0.0.0.0

🌐 Application Access Results
Endpoint	URL	Response
Health Check	http://16.16.184.106/health	{"status":"ok","message":"3-Tier App Running!"}
Setup Table	http://16.16.184.106/setup	{"message":"Table created successfully"}
Get Users	http://16.16.184.106/api/users	[]
Test API	http://16.16.184.106/api/test	{"message":"Backend is working!","timestamp":"..."}


🎯 Architecture Diagram
text
        Internet
           │
           ▼
┌─────────────────────┐
│  Presentation Tier   │
│   Nginx (Ubuntu)     │
│   16.16.184.106      │
└──────────┬──────────┘
           │ (Port 3000)
           ▼
┌─────────────────────┐
│  Application Tier    │
│  Node.js (Express)   │
│     10.0.2.65        │
└──────────┬──────────┘
           │ (Port 3306)
           ▼
┌─────────────────────┐
│    Data Tier         │
│   MySQL Database     │
│     10.0.3.32        │
└─────────────────────┘

✅ Conclusion
Successfully deployed a fully functional 3-Tier Application on AWS EC2 with:

✅ Proper network isolation using public/private subnets

✅ NAT Gateway for private instances

✅ Security groups for layer-wise access control

✅ Nginx as reverse proxy

✅ Node.js backend with MySQL integration

✅ All layers communicating properly

