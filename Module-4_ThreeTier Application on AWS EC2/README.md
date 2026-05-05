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
<img width="1357" height="421" alt="health" src="https://github.com/user-attachments/assets/89c6ca7e-7dcb-456b-bd69-cf622b7a05ea" />
<img width="1366" height="644" alt="EC2 Instances" src="https://github.com/user-attachments/assets/83b9a241-18cd-4c52-a9ba-64c286fa2b8f" />
<img width="1366" height="641" alt="DB-Layer-SG" src="https://github.com/user-attachments/assets/84e8ef3c-c3fd-41df-bb7c-b57e7809e1fd" />
<img width="1354" height="649" alt="Database Tier Details" src="https://github.com/user-attachments/assets/dc5eec1e-9f66-41dd-9d59-f550c65e7053" />
<img width="1361" height="636" alt="Application Tier Details" src="https://github.com/user-attachments/assets/3ef013dc-198e-49f1-b42b-d6b22a7f557b" />
<img width="1365" height="466" alt="api_users" src="https://github.com/user-attachments/assets/a08c638a-ff3a-4ece-8575-a50a8f54e9ec" />
<img width="1360" height="496" alt="api_test" src="https://github.com/user-attachments/assets/427c020f-d6db-4ab0-83cc-0ba6e991c9b3" />
<img width="1366" height="651" alt="Web-Layer-SG" src="https://github.com/user-attachments/assets/01a82bae-3f6c-495f-abf5-e23654a611eb" />
<img width="1337" height="587" alt="Web server" src="https://github.com/user-attachments/assets/eebf59e2-780e-426d-96e2-ac9f3d29ffa5" />
<img width="1366" height="639" alt="VPC" src="https://github.com/user-attachments/assets/13b6cf51-d9b4-4c4e-9be0-e9a408020f53" />
<img width="1357" height="629" alt="Subnets" src="https://github.com/user-attachments/assets/c8614e4b-2634-4425-bd30-65aacf686910" />
<img width="1340" height="411" alt="setup" src="https://github.com/user-attachments/assets/d727e79d-d20a-416b-9a69-1c0b0173c8a8" />
<img width="1354" height="620" alt="Route Tables" src="https://github.com/user-attachments/assets/f79f317e-650f-43da-9b5d-1969d2cd9d05" />
<img width="1358" height="651" alt="Presentation Tier Details" src="https://github.com/user-attachments/assets/65d0930a-bfef-4f8b-8111-7664ce4d4644" />
<img width="1354" height="628" alt="NAT Gateway" src="https://github.com/user-attachments/assets/d16db230-94ba-4f4b-ab63-b9bfa048f221" />
<img width="1364" height="650" alt="Internet Gateway" src="https://github.com/user-attachments/assets/9b94ae4b-58ad-4786-8fd4-7adb5784d2f4" />

