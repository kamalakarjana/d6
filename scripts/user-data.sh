#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install Docker
if ${install_docker}; then
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
fi

# Install Nginx
if ${install_nginx}; then
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
</head>
<body>
    <h1>Hello from Azure VM!</h1>
    <p>Docker and Nginx installed via Terraform</p>
</body>
</html>
EOL
    
    # Verify Nginx installation
    nginx -v
    echo "Nginx installed successfully!"
fi

# Install Azure CLI (optional)
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

echo "Setup completed successfully!"
