#!/bin/bash

# Fix Common Issues Script
# Automatically fixes common Nginx and VM issues

VM_IP="102.37.56.150"
SSH_KEY="$HOME/.ssh/azure_vm_africa"
SSH_USER="azureuser"

echo "=== AUTOMATIC ISSUE FIXER ==="

# Fix 1: Start Nginx if not running
echo "1. Checking Nginx status..."
ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "
    if ! sudo systemctl is-active nginx > /dev/null; then
        echo '   Starting Nginx...'
        sudo systemctl start nginx
        sudo systemctl enable nginx
        sleep 2
    fi
    sudo systemctl status nginx --no-pager
"

# Fix 2: Check and fix Nginx configuration
echo "2. Testing Nginx configuration..."
ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "sudo nginx -t"

# Fix 3: Ensure web directory exists and has correct permissions
echo "3. Checking web directory..."
ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "
    sudo chown -R www-data:www-data /var/www/html/
    sudo chmod -R 755 /var/www/html/
    ls -la /var/www/html/
"

# Fix 4: Check firewall rules
echo "4. Checking firewall rules..."
ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "
    echo 'Open ports:'
    sudo ss -tulpn | grep -E ':(80|22)'
"

# Fix 5: Restart Nginx to apply all changes
echo "5. Restarting Nginx..."
ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "
    sudo systemctl restart nginx
    echo 'Nginx restarted'
"

echo ""
echo "✅ All fixes applied. Running health check..."
./scripts/quick-test.sh
