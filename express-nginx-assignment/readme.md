Docker Containerization

Dockerfile
dockerfile
FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]

Build Docker Image

bash
docker build -t express-nginx-app .
Run Docker Container
bash
docker run -p 3000:3000 express-nginx-app
 Docker Compose with Nginx
docker-compose.yml
yaml
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - express-app
    networks:
      - app-network

  express-app:
    build: .
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
nginx.conf
nginx
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://express-app:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location /api {
        proxy_pass http://express-app:5000/api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
Run with Docker Compose
bash
docker-compose up -d

AWS EC2 Deployment

Step 1: Launch EC2 Instance
AMI: Ubuntu 22.04 LTS

Instance Type: t2.micro

Security Group:

SSH (22) - My IP

HTTP (80) - 0.0.0.0/0

Key Pair: naeem-shopbd-key.pem

Step 2: Connect to EC2 Instance
bash
ssh -i "naeem-shopbd-key.pem" ubuntu@54.179.77.220
Step 3: Install Docker & Docker Compose
bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install -y docker-compose-plugin
Step 4: Deploy Application
bash
# Clone repository
git clone https://github.com/naeem3295/My-devops-course.git
cd Module-3-deployment

# Run with Docker Compose
sudo docker-compose up -d

# Verify containers
sudo docker-compose ps
🌐 Live Application
Application URL: http://54.179.77.220

API URL: http://54.179.77.220/api

🐳 DockerHub Repository
Image: naeem3295/express-nginx-app:latest

Pull Command:

bash
docker pull naeem3295/express-nginx-app:latest
📊 Application Routes
Route	Method	Response
/	GET	HTML Page with "Roy"
/api	GET	JSON: {"message": "Hello World changes"}
