#!/bin/bash

# URL Testing Script - Simulates browser testing from command line

VM_IP="102.37.56.150"
URL="http://$VM_IP"

echo "=== BROWSER-LIKE URL TESTING ==="
echo "Testing URL: $URL"
echo ""

# Function to test with different user agents
test_with_user_agent() {
    local agent_name="$1"
    local user_agent="$2"
    
    echo "--- Testing as: $agent_name ---"
    
    # Get headers
    echo "Headers:"
    curl -s -I -X GET -A "$user_agent" --connect-timeout 10 "$URL" | head -10
    
    # Get content with specific user agent
    echo "Content (first 10 lines):"
    curl -s -A "$user_agent" --connect-timeout 10 "$URL" | head -10
    
    # Check for specific content
    if curl -s -A "$user_agent" --connect-timeout 10 "$URL" | grep -q "Hello from Azure VM"; then
        echo "✅ Content verification: PASSED"
    else
        echo "❌ Content verification: FAILED - Expected content not found"
    fi
    
    echo ""
}

# Test 1: As Chrome Browser
test_with_user_agent "Chrome" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"

# Test 2: As Firefox Browser
test_with_user_agent "Firefox" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0"

# Test 3: As Safari Browser
test_with_user_agent "Safari" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15"

# Test 4: As curl (default)
test_with_user_agent "curl" "curl/7.68.0"

# Performance Testing
echo "=== PERFORMANCE TESTING ==="
echo "Response time test (5 requests):"

for i in {1..5}; do
    response_time=$(curl -s -o /dev/null -w "%{time_total}s" --connect-timeout 10 "$URL")
    echo "Request $i: ${response_time}s"
done

# Security Headers Check
echo ""
echo "=== SECURITY HEADERS CHECK ==="
SECURITY_HEADERS=("X-Frame-Options" "X-Content-Type-Options" "X-XSS-Protection" "Strict-Transport-Security")

for header in "${SECURITY_HEADERS[@]}"; do
    header_value=$(curl -s -I --connect-timeout 10 "$URL" | grep -i "^$header:" | head -1)
    if [ -n "$header_value" ]; then
        echo "✅ $header: $header_value"
    else
        echo "❌ $header: Missing"
    fi
done

# Final Accessibility Report
echo ""
echo "=== ACCESSIBILITY REPORT ==="
echo "URL to open in Chrome: $URL"
echo "Quick test command: curl -s http://$VM_IP | grep -A 5 -B 5 'Hello'"
echo ""
echo "If you have a browser available, manually test:"
echo "1. Open Chrome/Firefox/Safari"
echo "2. Navigate to: http://$VM_IP"
echo "3. Verify you see 'Hello from Azure VM in South Africa!'"
echo "4. Check that the page loads without errors"
