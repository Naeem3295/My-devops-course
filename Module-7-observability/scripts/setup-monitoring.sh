#!/bin/bash
echo "========================================="
echo "Setting up Monitoring Stack on EC2"
echo "========================================="

sudo apt update && sudo apt upgrade -y

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y

sudo apt install mysql-server -y
sudo systemctl start mysql
sudo mysql -e "CREATE DATABASE IF NOT EXISTS mydb;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'password123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON mydb.* TO 'admin'@'localhost';"

cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
tar xvf node_exporter-1.8.1.linux-amd64.tar.gz
sudo mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/
sudo useradd --no-create-home --shell /bin/false node_exporter 2>/dev/null || true

sudo tee /etc/systemd/system/node_exporter.service > /dev/null << 'EOF'
[Unit]
Description=Node Exporter
After=network.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

wget https://github.com/prometheus/prometheus/releases/download/v2.53.0/prometheus-2.53.0.linux-amd64.tar.gz
tar xvf prometheus-2.53.0-linux-amd64.tar.gz
sudo mv prometheus-2.53.0-linux-amd64 /opt/prometheus

sudo tee /opt/prometheus/prometheus.yml > /dev/null << 'EOF'
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
EOF

sudo tee /etc/systemd/system/prometheus.service > /dev/null << 'EOF'
[Unit]
Description=Prometheus
After=network.target
[Service]
User=ubuntu
ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml --web.listen-address=:9090
Restart=always
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" -y
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y grafana

sudo systemctl start grafana-server
sudo systemctl enable grafana-server

echo "========================================="
echo "✅ Monitoring stack installed!"
echo "========================================="
echo "🔗 Grafana: http://$(curl -s ifconfig.me):3000 (admin/admin)"
echo "🔗 Prometheus: http://$(curl -s ifconfig.me):9090"
