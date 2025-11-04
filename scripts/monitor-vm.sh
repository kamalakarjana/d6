#!/bin/bash

# Advanced VM Monitoring Script
# Continuously monitors the VM and provides real-time status

VM_IP="102.37.56.150"
SSH_KEY="$HOME/.ssh/azure_vm_africa"
SSH_USER="azureuser"
LOG_FILE="vm-monitor.log"

echo "=== AZURE VM REAL-TIME MONITOR ==="
echo "Monitoring VM: $VM_IP"
echo "Log File: $LOG_FILE"
echo "Press Ctrl+C to stop monitoring"
echo ""

# Function to get status
get_status() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Check HTTP accessibility
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "http://$VM_IP")
    
    # Check SSH accessibility
    ssh -i "$SSH_KEY" -o ConnectTimeout=5 -o BatchMode=yes "$SSH_USER@$VM_IP" "echo '1'" > /dev/null 2>&1
    local ssh_status=$?
    
    # Get Nginx status if SSH is working
    local nginx_status="UNKNOWN"
    if [ $ssh_status -eq 0 ]; then
        nginx_status=$(ssh -i "$SSH_KEY" -o ConnectTimeout=5 "$SSH_USER@$VM_IP" "sudo systemctl is-active nginx 2>/dev/null || echo 'inactive'")
    fi
    
    # Determine overall status
    if [ "$http_code" = "200" ] && [ "$nginx_status" = "active" ]; then
        local status="HEALTHY"
        local emoji="🟢"
    elif [ "$http_code" = "200" ]; then
        local status="DEGRADED"
        local emoji="🟡"
    else
        local status="UNHEALTHY"
        local emoji="🔴"
    fi
    
    echo "$emoji [$timestamp] Status: $status | HTTP: $http_code | SSH: $ssh_status | Nginx: $nginx_status"
    echo "$timestamp,$status,$http_code,$ssh_status,$nginx_status" >> "$LOG_FILE"
}

# Create log file header
echo "timestamp,status,http_code,ssh_status,nginx_status" > "$LOG_FILE"

# Continuous monitoring
while true; do
    get_status
    sleep 30  # Check every 30 seconds
done
