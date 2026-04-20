# Angular Deployment - Academica Frontend

This folder contains the **academica_frontend** Angular project that was deployed on AWS EC2 with Nginx.

---

## 📌 Project Overview

| Detail | Information |
|--------|-------------|
| **Project Name** | Academica Frontend |
| **Framework** | Angular 20 + Tailwind CSS |
| **Original Repository** | [anik2644/academica_frontend](https://github.com/anik2644/academica_frontend) |
| **Deployed On** | AWS EC2 (Ubuntu 24.04) |
| **Web Server** | Nginx (Reverse Proxy + SSL) |
| **Backend API** | Node.js on Port 3000 (via proxy_pass /api) |

---

## 🚀 Deployment Process (What I Did)

### 1. Cloned the Repository on EC2 Server
```bash
cd /var/www
sudo git clone https://github.com/anik2644/academica_frontend.git
2. Installed Node.js 20 & Dependencies
bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y
cd academica_frontend
npm install
3. Built the Angular Project
bash
npm run build --prod
Build output: /var/www/academica_frontend/dist/fusion-angular-tailwind-starter/browser/

4. Configured Nginx with SSL & Reverse Proxy
nginx
server {
    listen 80;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    
    root /var/www/academica_frontend/dist/fusion-angular-tailwind-starter/browser;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
5. Set Correct Permissions
bash
sudo chown -R www-data:www-data /var/www/academica_frontend
sudo chmod -R 755 /var/www/academica_frontend
6. Reloaded Nginx & Verified
bash
sudo nginx -t
sudo systemctl reload nginx
🌐 Live URLs (AWS EC2)
Service	URL
HTTPS Website	https://16.170.218.149
Backend API	https://16.170.218.149/api
⚠️ Self-signed certificate used — browser shows "Not Secure" warning. This is expected.
