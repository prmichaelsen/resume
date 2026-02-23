#!/bin/bash
# Setup Cloudflare Zone for domain

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions
source "$SCRIPT_DIR/cloudflare-common.sh"

# Change to project root
cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Cloudflare Zone Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check dependencies
check_dependencies

# Load and validate environment
load_env
validate_env

echo
log_info "Setting up zone for domain: $CLOUDFLARE_DOMAIN"
echo

# Check if zone already exists
log_info "Checking if zone exists..."
EXISTING_ZONE=$(cf_api GET "/zones?name=$CLOUDFLARE_DOMAIN")

if check_response "$EXISTING_ZONE"; then
  ZONE_COUNT=$(echo "$EXISTING_ZONE" | jq -r '.result | length')
  
  if [ "$ZONE_COUNT" -gt 0 ]; then
    ZONE_ID=$(echo "$EXISTING_ZONE" | jq -r '.result[0].id')
    ZONE_STATUS=$(echo "$EXISTING_ZONE" | jq -r '.result[0].status')
    
    log_success "Zone already exists"
    echo "  Zone ID: $ZONE_ID"
    echo "  Status: $ZONE_STATUS"
    
    if [ "$ZONE_STATUS" = "active" ]; then
      log_success "Zone is active"
    else
      log_warning "Zone status is: $ZONE_STATUS"
      log_info "Update nameservers at your domain registrar:"
      echo "$EXISTING_ZONE" | jq -r '.result[0].name_servers[]' | while read ns; do
        echo "  - $ns"
      done
    fi
    
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✓ Zone setup complete"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 0
  fi
fi

# Create new zone
log_info "Creating new zone..."

CREATE_DATA=$(cat <<EOF
{
  "name": "$CLOUDFLARE_DOMAIN",
  "account": {
    "id": "$CLOUDFLARE_ACCOUNT_ID"
  },
  "jump_start": true,
  "type": "full"
}
EOF
)

CREATE_RESPONSE=$(cf_api POST "/zones" "$CREATE_DATA")

if ! check_response "$CREATE_RESPONSE"; then
  log_error "Failed to create zone"
  exit 1
fi

ZONE_ID=$(echo "$CREATE_RESPONSE" | jq -r '.result.id')
log_success "Zone created successfully"
echo "  Zone ID: $ZONE_ID"

# Get nameservers
NAMESERVERS=$(echo "$CREATE_RESPONSE" | jq -r '.result.name_servers[]')

echo
log_warning "Update nameservers at your domain registrar:"
echo "$NAMESERVERS" | while read ns; do
  echo "  - $ns"
done

echo
log_info "DNS propagation can take 5 minutes to 48 hours (usually < 1 hour)"

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Zone setup complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
