#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install basic packages
apt-get install -y curl wget vim

# Install Docker
echo "Installing Docker..."
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add user to docker group
usermod -aG docker azureuser

# Verify Docker installation
docker --version
echo "Docker installed successfully!"

# Run a test container
docker run hello-world

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

# Verify Nginx installation
nginx -v
echo "Nginx installed successfully!"

echo "Setup completed successfully at $(date)!"
