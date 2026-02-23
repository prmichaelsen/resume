#!/bin/bash
# Setup DNS records for Cloudflare Pages

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions
source "$SCRIPT_DIR/cloudflare-common.sh"

# Change to project root
cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Cloudflare DNS Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check dependencies
check_dependencies

# Load and validate environment
load_env
validate_env

# Get Pages project name
PAGES_PROJECT=${CLOUDFLARE_PAGES_PROJECT:-zen-warrior}
PAGES_DOMAIN="$PAGES_PROJECT.pages.dev"

echo
log_info "Setting up DNS for: $CLOUDFLARE_DOMAIN"
log_info "Pages project: $PAGES_DOMAIN"
echo

# Get zone ID
log_info "Getting zone ID..."
ZONE_ID=$(get_zone_id "$CLOUDFLARE_DOMAIN")

if [ -z "$ZONE_ID" ]; then
  log_error "Could not get zone ID. Run cloudflare-setup-zone.sh first"
  exit 1
fi

log_success "Zone ID: $ZONE_ID"
echo

# Function to create or update DNS record
setup_dns_record() {
  local record_type=$1
  local record_name=$2
  local record_content=$3
  local proxied=$4
  
  log_info "Setting up $record_type record: $record_name"
  
  # Check if record exists
  local existing=$(cf_api GET "/zones/$ZONE_ID/dns_records?type=$record_type&name=$record_name")
  
  if check_response "$existing"; then
    local record_count=$(echo "$existing" | jq -r '.result | length')
    
    if [ "$record_count" -gt 0 ]; then
      local record_id=$(echo "$existing" | jq -r '.result[0].id')
      local current_content=$(echo "$existing" | jq -r '.result[0].content')
      
      if [ "$current_content" = "$record_content" ]; then
        log_success "Record already exists with correct value"
        return 0
      fi
      
      log_info "Updating existing record..."
      
      local update_data=$(cat <<EOF
{
  "type": "$record_type",
  "name": "$record_name",
  "content": "$record_content",
  "proxied": $proxied,
  "ttl": 1
}
EOF
)
      
      local update_response=$(cf_api PUT "/zones/$ZONE_ID/dns_records/$record_id" "$update_data")
      
      if check_response "$update_response"; then
        log_success "Record updated successfully"
        return 0
      else
        log_error "Failed to update record"
        return 1
      fi
    fi
  fi
  
  # Create new record
  log_info "Creating new record..."
  
  local create_data=$(cat <<EOF
{
  "type": "$record_type",
  "name": "$record_name",
  "content": "$record_content",
  "proxied": $proxied,
  "ttl": 1
}
EOF
)
  
  local create_response=$(cf_api POST "/zones/$ZONE_ID/dns_records" "$create_data")
  
  if check_response "$create_response"; then
    log_success "Record created successfully"
    return 0
  else
    log_error "Failed to create record"
    return 1
  fi
}

# Setup apex domain (zenwarrior.app)
setup_dns_record "CNAME" "$CLOUDFLARE_DOMAIN" "$PAGES_DOMAIN" "true"
echo

# Setup www subdomain
setup_dns_record "CNAME" "www.$CLOUDFLARE_DOMAIN" "$PAGES_DOMAIN" "true"
echo

# Optional: Setup api subdomain for future use
read -p "Setup api subdomain for future use? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  setup_dns_record "CNAME" "api.$CLOUDFLARE_DOMAIN" "$PAGES_DOMAIN" "true"
  echo
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ DNS setup complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
log_info "DNS records configured:"
echo "  - $CLOUDFLARE_DOMAIN → $PAGES_DOMAIN (proxied)"
echo "  - www.$CLOUDFLARE_DOMAIN → $PAGES_DOMAIN (proxied)"
echo
log_warning "Note: You still need to add custom domains in Cloudflare Pages dashboard"
echo "  1. Go to Pages project → Custom domains"
echo "  2. Add $CLOUDFLARE_DOMAIN"
echo "  3. Add www.$CLOUDFLARE_DOMAIN"
