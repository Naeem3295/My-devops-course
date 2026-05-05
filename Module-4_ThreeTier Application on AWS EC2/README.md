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
<img width="1366" height="639" alt="VPC" src="https://github.com/user-attachments/assets/a26f2d2a-a77c-4713-9f21-902e843c3b59" />
<img width="1357" height="629" alt="Subnets" src="https://github.com/user-attachments/assets/4eef022f-5553-4420-bc94-7d884a214746" />
<img width="1364" height="650" alt="Internet Gateway" src="https://github.com/user-attachments/assets/dc0d79c2-66d3-441b-9fe7-5865aa466237" />
<img width="1354" height="628" alt="NAT Gateway" src="https://github.com/user-attachments/assets/7b8ee13a-d293-41eb-ab3f-5692d91014c0" />
<img width="1354" height="620" alt="Route Tables" src="https://github.com/user-attachments/assets/70d521cb-c01a-4339-9b33-629625443489" />
<img width="1366" height="651" alt="Web-Layer-SG" src="https://github.com/user-attachments/assets/ec90a1f0-def0-4304-8f9e-33afa3d7be34" />
<img width="1366" height="641" alt="DB-Layer-SG" src="https://github.com/user-attachments/assets/2c514d44-c64c-4721-b202-409178f925a6" />
<img width="1337" height="587" alt="Web server" src="https://github.com/user-attachments/assets/c10282eb-225c-4462-980b-de369a837c17" />
<img width="1358" height="651" alt="Presentation Tier Details" src="https://github.com/user-attachments/assets/e5890f04-4624-410a-b3c8-560326126e6c" />
<img width="1366" height="644" alt="EC2 Instances" src="https://github.com/user-attachments/assets/35915629-1669-4699-869b-f728da20bdae" />
<img width="1358" height="651" alt="Presentation Tier Details" src="https://github.com/user-attachments/assets/dfe6528e-a886-4103-a0bd-041d28c03de6" />

<img width="1361" height="636" alt="Application Tier Details" src="https://github.com/user-attachments/assets/0b3580d7-b6ad-41f3-b231-e26cdb682f64" />
<img width="1357" height="421" alt="health" src="https://github.com/user-attachments/assets/ff9928bd-4a67-4ae6-8c9b-ae4cefe76cc2" />
<img width="1354" height="649" alt="Database Tier Details" src="https://github.com/user-attachments/assets/90b2dbea-9ce8-4a03-9256-a7047aad7e6c" />
<img width="1365" height="466" alt="api_users" src="https://github.com/user-attachments/assets/46d5e58a-4c3c-4a04-9c9f-94f4add6aab0" />
<img width="1357" height="421" alt="health" src="https://github.com/user-attachments/assets/c9d0346a-9f65-4928-b480-467cdad63903" />
<img width="1365" height="466" alt="api_users" src="https://github.com/user-attachments/assets/16499db1-6144-478b-b96d-8e2d0e5df502" />

<img width="1360" height="496" alt="api_test" src="https://github.com/user-attachments/assets/57a773f5-722f-4323-9bc2-ab20f1a4fb3a" />

