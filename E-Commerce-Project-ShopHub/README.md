# 🛍️ ShopHub - E-Commerce Platform

[![AWS](https://img.shields.io/badge/AWS-EC2-orange)](https://aws.amazon.com/ec2/)
[![PHP](https://img.shields.io/badge/PHP-8.1-blue)](https://php.net)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)](https://mysql.com)
[![Apache](https://img.shields.io/badge/Apache-2.4-red)](https://apache.org)

## 🌐 Live Demo
**URL:** http://16.170.225.209:8000

---

## 📋 Project Overview

**ShopHub** is a fully functional e-commerce platform deployed on **AWS EC2** infrastructure. This project demonstrates a complete online shopping system with product management, user authentication, shopping cart, order processing, and admin dashboard.

---

## ✨ Features

### 👥 Customer Features
- User Registration & Login
- Browse Products with Categories
- Shopping Cart Management
- Checkout Process
- Order History
- Product Search

### 👑 Admin Features
- Admin Dashboard
- Product CRUD Operations
- Order Management
- User Management
- Inventory Control

---

## 🏗️ Technology Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Frontend | HTML5, CSS3, Bootstrap | - |
| Backend | PHP | 8.1 |
| Database | MySQL | 8.0 |
| Web Server | Apache | 2.4 |
| Cloud | AWS EC2 | t3.micro |
| OS | Ubuntu | 24.04 LTS |

---

## 🚀 AWS Deployment Steps

### Step 1: Launch EC2 Instance
```bash
AMI: Ubuntu 24.04 LTS
Instance Type: t3.micro
Security Group: HTTP (80), HTTPS (443), Custom (8000), SSH (22)
Key Pair: Use existing or create new
Step 2: SSH into Instance
bash
ssh -i "your-key.pem" ubuntu@16.170.225.209
Step 3: Install LAMP Stack
bash
sudo apt update
sudo apt install apache2 php php-mysql php-curl php-gd php-zip php-mbstring mysql-server -y
Step 4: Configure Apache Port
bash
sudo sed -i 's/Listen 80/Listen 8000/g' /etc/apache2/ports.conf
sudo sed -i 's/:80>/:8000>/g' /etc/apache2/sites-available/000-default.conf
sudo systemctl restart apache2
Step 5: Setup Database
bash
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Mynewpass123!';
CREATE DATABASE ecommerce;
EXIT;
Step 6: Deploy Code
bash
cd /var/www/html
sudo git clone https://github.com/jmrashed/ecommerce-using-php-mysql.git .
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
Step 7: Import Database
bash
sudo mysql -u root -p ecommerce < db_dothedeals_lastupdated.sql
Step 8: Configure Database Connection
bash
sudo nano classes/application.php
# Update password: 'MyNewPass123!'
Step 9: Restart Apache
bash
sudo systemctl restart apache2
🔐 Access Credentials
Role	URL	Email	Password
Customer	http://16.170.225.209:8000	Register new	Set your own
Admin	http://16.170.225.209:8000/admin	admin@example.com	admin
<img width="1600" height="857" alt="shopup 1" src="https://github.com/user-attachments/assets/1efb6754-332f-4b
<img width="1600" height="884" alt="shopup 3" src="https://github.com/user-attachments/assets/07c69a19-302e-40fe-b29f-5930260aefdf" />
<img width="1600" height="864" alt="shopup 2" src="https://github.com/user-attachments/assets/2cec0b04-dab4-4762-a200-cca42348a7cc" />
81-9a2c-418096eab7ab" />
## 📸 Screenshots

### 🏠 Homepage
![ShopHub Homepage](https://github.com/user-attachments/assets/1efb6754-332f-4b81-9a2c-418096eab7ab)

### 🛍️ Products Page
![Products Page](https://github.com/user-attachments/assets/2cec0b04-dab4-4762-a200-cca42348a7cc)

### 👑 Admin Dashboard
![Admin Dashboard](https://github.com/user-attachments/assets/07c69a19-302e-40fe-b29f-5930260ae6df)

