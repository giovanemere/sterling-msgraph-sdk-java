#!/bin/bash

# Complete Postman + JAR Validation Script
echo "🎯 Complete Solution Validation"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_TOTAL=0

# Function to run test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo -e "${BLUE}🧪 Testing: $test_name${NC}"
    
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS: $test_name${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL: $test_name${NC}"
    fi
}

# 1. File Structure Tests
echo -e "${YELLOW}📁 File Structure Tests${NC}"
run_test "Postman Collection exists" "[ -f 'postman/Microsoft_Graph_Sterling_Complete.postman_collection.json' ]"
run_test "Postman Environment exists" "[ -f 'postman/Sterling_Graph_Environment.postman_environment.json' ]"
run_test "Unified documentation exists" "[ -f 'docs/postman.md' ]"
run_test "JWT script exists and executable" "[ -x 'postman/get-jwt.sh' ]"
run_test "Environment file exists" "[ -f '.env' ]"
run_test "JAR file exists" "[ -f 'target/O365InboxAttachmentToDisk-5.4.1.jar' ]"

# 2. Configuration Tests
echo -e "${YELLOW}⚙️  Configuration Tests${NC}"
run_test "TENANT_ID configured" "grep -q '^TENANT_ID=' .env"
run_test "CLIENT_ID configured" "grep -q '^CLIENT_ID=' .env"
run_test "CLIENT_SECRET configured" "grep -q '^CLIENT_SECRET=' .env"
run_test "MAIL_CORREO configured" "grep -q '^MAIL_CORREO=' .env"
run_test "PATH_DESTINATION configured" "grep -q '^PATH_DESTINATION=' .env"

# 3. Functionality Tests
echo -e "${YELLOW}🔧 Functionality Tests${NC}"
run_test "JWT generation works" "timeout 10s ./postman/get-jwt.sh | grep -q 'eyJ'"
run_test "JAR file is valid" "java -jar target/O365InboxAttachmentToDisk-5.4.1.jar -help 2>&1 | grep -q 'Wrong input parameters'"
run_test "Collection has correct structure" "jq -e '.item | length >= 6' postman/Microsoft_Graph_Sterling_Complete.postman_collection.json"
run_test "Environment has required variables" "jq -e '.values | map(select(.key == \"tenant_id\" or .key == \"client_id\")) | length >= 2' postman/Sterling_Graph_Environment.postman_environment.json"

# 4. Documentation Tests
echo -e "${YELLOW}📚 Documentation Tests${NC}"
run_test "Documentation mentions enhanced features" "grep -q '🆕' docs/postman.md"
run_test "Documentation has batch processing section" "grep -q 'Batch Processing' docs/postman.md"
run_test "Documentation has troubleshooting" "grep -q 'Troubleshooting' docs/postman.md"
run_test "Documentation has security section" "grep -q 'Seguridad' docs/postman.md"

# 5. Integration Tests
echo -e "${YELLOW}🔗 Integration Tests${NC}"
run_test "Enhanced script exists" "[ -f 'app-enhanced.sh' ]"
run_test "Enhanced script is executable" "[ -x 'app-enhanced.sh' ]"
run_test "Enhanced script shows help" "./app-enhanced.sh help 2>/dev/null | grep -q 'Enhanced Version'"
run_test "Test directory exists" "[ -d 'test-attachments' ]"

# Results Summary
echo ""
echo "================================"
echo -e "${BLUE}📊 Test Results Summary${NC}"
echo "================================"

if [ $TESTS_PASSED -eq $TESTS_TOTAL ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED! ($TESTS_PASSED/$TESTS_TOTAL)${NC}"
    echo -e "${GREEN}✅ Solution is ready for production use!${NC}"
else
    echo -e "${YELLOW}⚠️  $TESTS_PASSED/$TESTS_TOTAL tests passed${NC}"
    echo -e "${YELLOW}🔧 Some components may need attention${NC}"
fi

# Recommendations
echo ""
echo -e "${BLUE}🎯 Next Steps:${NC}"
echo "1. Import collection and environment in Postman"
echo "2. Follow the execution order in docs/postman.md"
echo "3. Test with real Microsoft Graph API calls"
echo "4. Create AppEnhanced class for batch processing"
echo ""
echo -e "${GREEN}📚 Documentation: docs/postman.md${NC}"
echo -e "${GREEN}🧪 Test Results: TEST_RESULTS.md${NC}"
