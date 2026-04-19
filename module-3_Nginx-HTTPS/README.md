# Module 3: Nginx Web Server with HTTPS, SSL & Reverse Proxy

## Assignment Completed on AWS EC2

### Server Details:
- **Public IP:** 16.171.195.185
- **OS:** Ubuntu 24.04
- **Instance Type:** t3.micro

---

## Part 1: Basic Setup 


```bash
sudo apt update
sudo apt install nginx openssl -y
sudo mkdir -p /var/www/secure-app
echo '<h1>Secure Server Running via Nginx</h1>' | sudo tee /var/www/secure-app/index.html
sudo chown -R www-data:www-data /var/www/secure-app
sudo systemctl start nginx
sudo systemctl enable nginx


