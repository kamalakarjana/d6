#!/bin/bash

# Quick Test Script - Fast health check

VM_IP="102.37.56.150"

echo "🚀 QUICK HEALTH CHECK"
echo "======================"

# Quick HTTP test
echo -n "HTTP Test: "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "http://$VM_IP")
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ SUCCESS (Code: $HTTP_CODE)"
    echo "🌐 Website is LIVE: http://$VM_IP"
    
    # Quick content check
    echo -n "Content Check: "
    if curl -s --connect-timeout 5 "http://$VM_IP" | grep -q "Hello from Azure VM"; then
        echo "✅ PASSED"
    else
        echo "❌ FAILED - Wrong content"
    fi
else
    echo "❌ FAILED (Code: $HTTP_CODE)"
fi

# Quick SSH test
echo -n "SSH Test: "
ssh -i ~/.ssh/azure_vm_africa -o ConnectTimeout=5 -o BatchMode=yes azureuser@$VM_IP "echo 'Connected'" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ SUCCESS"
else
    echo "❌ FAILED"
fi

echo ""
echo "📊 NEXT STEPS:"
echo "1. Open in browser: http://$VM_IP"
echo "2. Run detailed test: ./scripts/health-check.sh"
echo "3. Monitor continuously: ./scripts/monitor-vm.sh"
