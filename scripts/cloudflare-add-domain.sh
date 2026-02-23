#!/bin/bash
# Add custom domain to Cloudflare Pages project

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions
source "$SCRIPT_DIR/cloudflare-common.sh"

# Change to project root
cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Add Custom Domain to Pages"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check dependencies
check_dependencies

# Load and validate environment
load_env
validate_env

PAGES_PROJECT=${CLOUDFLARE_PAGES_PROJECT:-zen-warrior}
DOMAIN=${1:-$CLOUDFLARE_DOMAIN}

if [ -z "$DOMAIN" ]; then
  log_error "Domain not specified"
  echo "Usage: $0 [domain]"
  echo "Or set CLOUDFLARE_DOMAIN in .env.cloudflare.local"
  exit 1
fi

echo
log_info "Adding custom domain: $DOMAIN"
log_info "Pages project: $PAGES_PROJECT"
echo

# Add custom domain to Pages project
log_info "Adding domain to Pages project..."

ADD_DATA=$(cat <<EOF
{
  "name": "$DOMAIN"
}
EOF
)

ADD_RESPONSE=$(cf_api POST "/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects/$PAGES_PROJECT/domains" "$ADD_DATA")

if check_response "$ADD_RESPONSE"; then
  log_success "Custom domain added successfully"
  
  # Get domain details
  DOMAIN_ID=$(echo "$ADD_RESPONSE" | jq -r '.result.id')
  VALIDATION_STATUS=$(echo "$ADD_RESPONSE" | jq -r '.result.validation_status // "pending"')
  
  echo "  Domain: $DOMAIN"
  echo "  Status: $VALIDATION_STATUS"
  
  if [ "$VALIDATION_STATUS" = "pending" ]; then
    log_info "DNS validation pending..."
    log_info "Cloudflare will automatically configure DNS records"
    log_info "SSL certificate will be provisioned automatically"
  fi
else
  log_error "Failed to add custom domain"
  echo "$ADD_RESPONSE" | jq '.'
  exit 1
fi

echo
log_info "Checking DNS configuration..."

# Get zone ID
ZONE_ID=$(get_zone_id "$DOMAIN")

if [ -n "$ZONE_ID" ]; then
  # Check if DNS records exist
  DNS_CHECK=$(cf_api GET "/zones/$ZONE_ID/dns_records?name=$DOMAIN&type=CNAME")
  
  if check_response "$DNS_CHECK"; then
    RECORD_COUNT=$(echo "$DNS_CHECK" | jq -r '.result | length')
    
    if [ "$RECORD_COUNT" -gt 0 ]; then
      CURRENT_TARGET=$(echo "$DNS_CHECK" | jq -r '.result[0].content')
      log_warning "Existing CNAME record found: $DOMAIN → $CURRENT_TARGET"
      log_info "Cloudflare Pages will manage this automatically"
    else
      log_info "No existing DNS records - Cloudflare will create them"
    fi
  fi
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Custom domain added"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
log_info "Next steps:"
echo "  1. Wait for DNS validation (~5 minutes)"
echo "  2. SSL certificate will be provisioned automatically"
echo "  3. Check status: ./scripts/cloudflare-status.sh"
echo
log_info "Your site will be available at:"
echo "  https://$DOMAIN"
