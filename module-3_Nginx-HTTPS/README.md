# Module 3: Nginx Web Server with HTTPS, SSL & Reverse Proxy

## 📌 Assignment Completed on AWS EC2

### Server Details:
| Detail | Value |
|--------|-------|
| **Public IP** | 16.171.195.185 |
| **OS** | Ubuntu 24.04 |
| **Instance Type** | t3.micro |
| **Security Group Ports** | SSH (22), HTTP (80), HTTPS (443) |

---

## 🔷 Part 1: Basic Setup 

### Commands Used:
```bash
# Update package list
sudo apt update

# Install Nginx and OpenSSL
sudo apt install nginx openssl -y

# Create web directory
sudo mkdir -p /var/www/secure-app

# Create HTML page
echo '<h1>Secure Server Running via Nginx</h1>' | sudo tee /var/www/secure-app/index.html

# Set permissions
sudo chown -R www-data:www-data /var/www/secure-app

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
Verification Commands:
bash
nginx -v
sudo systemctl status nginx
cat /var/www/secure-app/index.html
📸 Screenshots:
Screenshot	Proof
Nginx Version & Status	https://raw.githubusercontent.com/Naeem3295/My-devops-course/main/module-3_Nginx-HTTPs/screenshots/Nginx%2520Version.png
HTML File Content	https://raw.githubusercontent.com/Naeem3295/My-devops-course/main/module-3_Nginx-HTTPs/screenshots/HTML%2520File.png
🔷 Part 2: SSL Certificate 
Commands Used:
bash
# Create SSL directory
sudo mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate (365 days)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/server.key \
  -out /etc/nginx/ssl/server.crt \
  -subj "/C=BD/ST=Dhaka/L=Dhaka/O=Student/CN=ec2-16-171-195-185.eu-north-1.compute.amazonaws.com"
Verification Commands:
bash
ls -la /etc/nginx/ssl/
📸 Screenshot:
Screenshot	Proof
SSL Files (server.crt & server.key)	https://raw.githubusercontent.com/Naeem3295/My-devops-course/main/module-3_Nginx-HTTPs/screenshots/ssl-certificate.png
🔷 Part 3: Nginx Configuration 
Commands Used:
bash
# Remove default config
sudo rm -f /etc/nginx/sites-enabled/default

# Create custom config file
sudo nano /etc/nginx/sites-available/secure-app

# Enable the site
sudo ln -s /etc/nginx/sites-available/secure-app /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
Nginx Configuration File Content:
nginx
# HTTP → HTTPS redirect (Port 80)
server {
    listen 80;
    listen [::]:80;
    server_name _;
    return 301 https://$host$request_uri;
}

# HTTPS with SSL (Port 443)
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name _;

    # SSL Certificate paths
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    # Root directory & index
    root /var/www/secure-app;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
📸 Screenshots:
Screenshot	Proof
Nginx Config File	https://screenshots/nginx-config.png
Nginx Test	https://screenshots/nginx-test.png

🔷 Part 4: Reverse Proxy 
Commands Used:
bash
# Update config with proxy
sudo nano /etc/nginx/sites-available/secure-app

# Test and reload
sudo nginx -t
sudo systemctl reload nginx

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y

# Create backend directory and file
mkdir -p ~/backend && cd ~/backend

cat > server.js << 'EOF'
const http = require('http');
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.write('Backend Response\n');
  res.write('Host: ' + req.headers.host + '\n');
  res.write('X-Real-IP: ' + (req.headers['x-real-ip'] || 'Not set') + '\n');
  res.end();
});
server.listen(3000, () => console.log('Backend running on port 3000'));
EOF

# Run backend in background
node server.js &
Updated Nginx Config (with Reverse Proxy):
nginx
# HTTP → HTTPS redirect (Port 80)
server {
    listen 80;
    listen [::]:80;
    server_name _;
    return 301 https://$host$request_uri;
}

# HTTPS with SSL + Reverse Proxy (Port 443)
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name _;

    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    root /var/www/secure-app;
    index index.html;

    # Reverse Proxy to backend on port 3000
    location /api {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location / {
        try_files $uri $uri/ =404;
    }
}
📸 Screenshots:
Screenshot	Proof
Backend Running	https://screenshots/backend-running.png
Final Nginx Config	https://screenshots/nginx-config-final.png

🔷 Part 5: Testing 
Test Commands:
bash
# Test Nginx configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

# Check backend is running
ps aux | grep node
Live URLs:
Service	URL
Website (HTTPS)	https://16.171.195.185
Backend API	https://16.171.195.185/api
Test Results:
Test	Expected Result	Status	Screenshot
HTTP → HTTPS Redirect	Browser auto-redirects HTTP to HTTPS	✅ Pass	https://screenshots/redirect-working.png
HTTPS Working	"Secure Server Running via Nginx" displayed	✅ Pass	https://screenshots/https-working.png
Backend via Proxy	"Backend Response" with Host and X-Real-IP	✅ Pass	https://screenshots/backend-proxy.png
nginx -t	"syntax is ok" and "test is successful"	✅ Pass	https://screenshots/nginx-test-final.png
⚠️ Note on Self-Signed Certificate:
Browser shows "Not Secure" warning — this is expected because we are using a self-signed certificate

Click "Advanced → Proceed to site" to view the page

This confirms HTTPS encryption is working, just not trusted by browsers

📦 Submission Information
Field	Value
Topic	Nginx Web Server with HTTPS, SSL & Reverse Proxy
Date	April 19, 2026
Platform	AWS EC2 (Ubuntu 24.04)
GitHub Repository	https://github.com/Naeem3295/My-devops-course
✅ Final Checklist
Requirement	Status
Nginx & OpenSSL installed	✅
/var/www/secure-app with HTML file	✅
Self-signed SSL certificate generated	✅
SSL files stored in /etc/nginx/ssl/	✅
HTTP (80) → HTTPS (443) redirect	✅
HTTPS (443) serving with SSL	✅
Root and index correctly set	✅
Backend running on port 3000	✅
Reverse proxy configured (/api → port 3000)	✅
Host and X-Real-IP headers passed	✅
All tests passed
