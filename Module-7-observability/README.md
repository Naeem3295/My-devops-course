# Module 7: Backend Deployment with Observability & CI/CD

## Project Overview
This project deploys a Node.js backend application with MySQL database on AWS EC2, 
implements monitoring with Prometheus, Node Exporter, and Grafana, 
and automates deployment using GitHub Actions.

## Architecture
- EC2 Instance (Ubuntu 22.04)
- Node.js Backend (Port 3000)
- MySQL Database
- Prometheus (Port 9090)
- Node Exporter (Port 9100)
- Grafana (Port 3000 - different instance or port mapping)
- GitHub Actions CI/CD

## Setup Instructions

### Prerequisites
- AWS Account
- GitHub Account

### Deployment Steps

1. **Launch EC2 Instance**
   - Ubuntu 22.04 LTS
   - t2.micro (free tier)
   - Security Group ports: 22, 3000, 9090, 9100, 3000

2. **SSH into EC2**
   ```bash
   ssh -i your-key.pem ubuntu@<EC2_IP>