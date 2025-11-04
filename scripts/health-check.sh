#!/bin/bash

# Health Check Script for Azure VM
# This script checks if Nginx is running and the website is accessible

VM_IP="102.37.56.150"
SSH_KEY="$HOME/.ssh/azure_vm_africa"
SSH_USER="azureuser"

echo "=== AZURE VM HEALTH CHECK ==="
echo "VM IP: $VM_IP"
echo "Timestamp: $(date)"
echo ""

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo "✅ $2"
    else
        echo "❌ $2"
    fi
}

# Check 1: Test SSH connectivity
echo "1. Testing SSH connectivity..."
ssh -i "$SSH_KEY" -o ConnectTimeout=10 -o BatchMode=yes "$SSH_USER@$VM_IP" "echo 'SSH connection successful'" > /dev/null 2>&1
print_status $? "SSH Connection"

# Check 2: Test if VM is reachable via ping
echo "2. Testing VM network reachability..."
ping -c 3 -W 5 "$VM_IP" > /dev/null 2>&1
print_status $? "Network Reachability"

# Check 3: Test if port 22 (SSH) is open
echo "3. Testing SSH port (22)..."
nc -zv -w 5 "$VM_IP" 22 > /dev/null 2>&1
print_status $? "SSH Port (22)"

# Check 4: Test if port 80 (HTTP) is open
echo "4. Testing HTTP port (80)..."
nc -zv -w 5 "$VM_IP" 80 > /dev/null 2>&1
print_status $? "HTTP Port (80)"

# Check 5: Test HTTP connectivity and get response
echo "5. Testing HTTP response..."
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "http://$VM_IP")
if [ "$HTTP_RESPONSE" = "200" ]; then
    echo "✅ HTTP Response: $HTTP_RESPONSE (OK)"
else
    echo "❌ HTTP Response: $HTTP_RESPONSE (Expected: 200)"
fi

# Check 6: Test website content
echo "6. Testing website content..."
curl -s --connect-timeout 10 "http://$VM_IP" | grep -q "Hello from Azure VM"
print_status $? "Website Content"

# Check 7: Get full HTTP response for debugging
echo ""
echo "=== FULL HTTP RESPONSE ==="
curl -s --connect-timeout 10 "http://$VM_IP" | head -20

# Check 8: Remote VM service status (if SSH is working)
echo ""
echo "=== REMOTE VM STATUS ==="
if ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "sudo systemctl is-active nginx" 2>/dev/null | grep -q "active"; then
    echo "✅ Nginx service: ACTIVE"
else
    echo "❌ Nginx service: INACTIVE"
    
    # Try to start nginx if inactive
    echo "Attempting to start Nginx..."
    ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "sudo systemctl start nginx && sudo systemctl enable nginx" 2>/dev/null
    sleep 3
    
    # Check again
    if ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "sudo systemctl is-active nginx" 2>/dev/null | grep -q "active"; then
        echo "✅ Nginx started successfully"
    else
        echo "❌ Failed to start Nginx"
    fi
fi

# Check 9: Remote VM Nginx configuration
echo ""
echo "=== NGINX CONFIGURATION CHECK ==="
ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SSH_USER@$VM_IP" "sudo nginx -t 2>&1"
NGINX_TEST=$?
if [ $NGINX_TEST -eq 0 ]; then
    echo "✅ Nginx configuration test: PASSED"
else
    echo "❌ Nginx configuration test: FAILED"
fi

echo ""
echo "=== HEALTH CHECK SUMMARY ==="
echo "VM IP: http://$VM_IP"
echo "SSH Command: ssh -i $SSH_KEY $SSH_USER@$VM_IP"
echo "Health Check Completed: $(date)"
