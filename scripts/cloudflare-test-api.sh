#!/bin/bash
# Test Cloudflare API connection

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions
source "$SCRIPT_DIR/cloudflare-common.sh"

# Change to project root
cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Test Cloudflare API Connection"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check dependencies
check_dependencies

# Load environment
load_env

echo
log_info "Testing API connection..."
echo

# Test API with verify token endpoint
log_info "Verifying API credentials..."

if [ -n "$CLOUDFLARE_EMAIL" ]; then
  log_info "Using Global API Key authentication (X-Auth-Email + X-Auth-Key)"
  VERIFY_RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/user" \
    -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
    -H "X-Auth-Key: $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json")
else
  log_info "Using API Token authentication (Bearer)"
  VERIFY_RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json")
fi

echo "Response:"
echo "$VERIFY_RESPONSE" | jq '.'
echo

SUCCESS=$(echo "$VERIFY_RESPONSE" | jq -r '.success')

if [ "$SUCCESS" = "true" ]; then
  log_success "API token is valid!"
  
  TOKEN_STATUS=$(echo "$VERIFY_RESPONSE" | jq -r '.result.status')
  TOKEN_ID=$(echo "$VERIFY_RESPONSE" | jq -r '.result.id')
  
  echo "  Status: $TOKEN_STATUS"
  echo "  Token ID: $TOKEN_ID"
  echo
  
  # Test account access
  log_info "Testing account access..."
  ACCOUNT_RESPONSE=$(cf_api GET "/accounts/$CLOUDFLARE_ACCOUNT_ID")
  
  echo "Response:"
  echo "$ACCOUNT_RESPONSE" | jq '.'
  echo
  
  ACCOUNT_SUCCESS=$(echo "$ACCOUNT_RESPONSE" | jq -r '.success')
  
  if [ "$ACCOUNT_SUCCESS" = "true" ]; then
    ACCOUNT_NAME=$(echo "$ACCOUNT_RESPONSE" | jq -r '.result.name')
    log_success "Account access verified!"
    echo "  Account: $ACCOUNT_NAME"
    echo "  Account ID: $CLOUDFLARE_ACCOUNT_ID"
  else
    log_error "Cannot access account"
    echo "$ACCOUNT_RESPONSE" | jq -r '.errors[]?.message' 2>/dev/null || echo "$ACCOUNT_RESPONSE"
  fi
else
  log_error "API token is invalid!"
  echo "$VERIFY_RESPONSE" | jq -r '.errors[]?.message' 2>/dev/null || echo "$VERIFY_RESPONSE"
  echo
  log_info "Common issues:"
  echo "  1. Token is incorrect or expired"
  echo "  2. Token doesn't have required permissions"
  echo "  3. Token format is wrong (should be a long string)"
  echo
  log_info "Create a new token at:"
  echo "  https://dash.cloudflare.com/profile/api-tokens"
  echo
  log_info "Required permissions:"
  echo "  - Zone:Read, Zone:Edit"
  echo "  - DNS:Read, DNS:Edit"
  echo "  - Cloudflare Pages:Edit"
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

