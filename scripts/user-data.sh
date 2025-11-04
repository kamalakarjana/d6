#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install basic packages
apt-get install -y curl wget vim

# Install Docker
echo "Installing Docker..."
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add user to docker group
usermod -aG docker azureuser

# Install Nginx
echo "Installing Nginx..."
apt-get install -y nginx

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Create a simple HTML page
cat > /var/www/html/index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Azure VM</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #0078d4; }
    </style>
</head>
<body>
    <h1>Hello from Azure VM!</h1>
    <p>Docker and Nginx installed via Terraform</p>
    <p>VM Hostname: $(hostname)</p>
    <p>Timestamp: $(date)</p>
</body>
</html>
EOL

# Restart nginx to apply changes
systemctl restart nginx

echo "Setup completed successfully at $(date)!"
