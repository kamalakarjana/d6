# Browser Testing Instructions

## VM Details
- **IP Address**: 102.37.56.150
- **URL**: http://102.37.56.150
- **SSH**: ssh -i ~/.ssh/azure_vm_africa azureuser@102.37.56.150

## Manual Browser Testing Steps:

### Chrome/Firefox/Safari:
1. Open your web browser
2. Navigate to: http://102.37.56.150
3. Expected Result: You should see a page with:
   - "Hello from Azure VM in South Africa!"
   - VM Hostname
   - Region: South Africa North
   - Current timestamp

### What to Check:
- ✅ Page loads without errors
- ✅ Correct content is displayed
- ✅ No SSL certificate warnings (it's HTTP, not HTTPS)
- ✅ Page loads quickly (< 3 seconds)

### Common Issues:
- ❌ "Connection refused" - Nginx not running
- ❌ "Connection timeout" - Network/firewall issue
- ❌ Wrong content - Custom data script didn't run properly
- ❌ Slow loading - Network latency to South Africa

### Quick Fixes:
1. Run: ./scripts/fix-common-issues.sh
2. Run: ./scripts/health-check.sh
3. Check Azure Portal for VM status

### Performance Testing:
- Test from different locations if possible
- Check loading time in browser developer tools
- Test on mobile devices if applicable
