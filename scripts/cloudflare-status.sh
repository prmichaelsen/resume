#!/bin/bash
# Check status of Cloudflare zone, DNS, and Pages

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions
source "$SCRIPT_DIR/cloudflare-common.sh"

# Change to project root
cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Cloudflare Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check dependencies
check_dependencies

# Load and validate environment
load_env
validate_env

PAGES_PROJECT=${CLOUDFLARE_PAGES_PROJECT:-zen-warrior}

echo
log_info "Domain: $CLOUDFLARE_DOMAIN"
log_info "Pages project: $PAGES_PROJECT"
echo

# Check zone status
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Zone Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

ZONE_INFO=$(cf_api GET "/zones?name=$CLOUDFLARE_DOMAIN")

if check_response "$ZONE_INFO"; then
  ZONE_COUNT=$(echo "$ZONE_INFO" | jq -r '.result | length')
  
  if [ "$ZONE_COUNT" -gt 0 ]; then
    ZONE_ID=$(echo "$ZONE_INFO" | jq -r '.result[0].id')
    ZONE_STATUS=$(echo "$ZONE_INFO" | jq -r '.result[0].status')
    ZONE_PLAN=$(echo "$ZONE_INFO" | jq -r '.result[0].plan.name')
    
    log_success "Zone exists"
    echo "  Zone ID: $ZONE_ID"
    echo "  Status: $ZONE_STATUS"
    echo "  Plan: $ZONE_PLAN"
    
    if [ "$ZONE_STATUS" != "active" ]; then
      log_warning "Zone is not active yet"
      echo
      log_info "Nameservers:"
      echo "$ZONE_INFO" | jq -r '.result[0].name_servers[]' | while read ns; do
        echo "  - $ns"
      done
    fi
  else
    log_error "Zone not found"
    echo "  Run: ./scripts/cloudflare-setup-zone.sh"
  fi
else
  log_error "Failed to get zone info"
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 DNS Records"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

if [ -n "$ZONE_ID" ]; then
  DNS_RECORDS=$(cf_api GET "/zones/$ZONE_ID/dns_records")
  
  if check_response "$DNS_RECORDS"; then
    RECORD_COUNT=$(echo "$DNS_RECORDS" | jq -r '.result | length')
    
    if [ "$RECORD_COUNT" -gt 0 ]; then
      log_success "Found $RECORD_COUNT DNS record(s)"
      echo
      echo "$DNS_RECORDS" | jq -r '.result[] | "  \(.type) \(.name) → \(.content) (proxied: \(.proxied))"'
    else
      log_warning "No DNS records found"
      echo "  Run: ./scripts/cloudflare-setup-dns.sh"
    fi
  else
    log_error "Failed to get DNS records"
  fi
else
  log_warning "Skipping DNS check (no zone ID)"
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📄 Pages Project"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

PAGES_INFO=$(cf_api GET "/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects/$PAGES_PROJECT")

if check_response "$PAGES_INFO" 2>/dev/null; then
  PROJECT_URL=$(echo "$PAGES_INFO" | jq -r '.result.subdomain')
  CREATED_ON=$(echo "$PAGES_INFO" | jq -r '.result.created_on')
  LATEST_DEPLOYMENT=$(echo "$PAGES_INFO" | jq -r '.result.canonical_deployment.url // "N/A"')
  DEPLOYMENT_STAGE=$(echo "$PAGES_INFO" | jq -r '.result.canonical_deployment.stages[-1].status // "N/A"')
  
  log_success "Pages project exists"
  echo "  Project URL: https://$PROJECT_URL"
  echo "  Created: $CREATED_ON"  echo "  Latest deployment: $LATEST_DEPLOYMENT"
  echo "  Deployment status: $DEPLOYMENT_STAGE"
  
  # Get custom domains
  DOMAINS=$(echo "$PAGES_INFO" | jq -r '.result.domains // [] | .[]')
  if [ -n "$DOMAINS" ]; then
    echo
    log_info "Custom domains:"
    echo "$DOMAINS" | while read domain; do
      echo "  - https://$domain"
    done
  fi
else
  log_warning "Pages project not found"
  echo "  Run: ./scripts/cloudflare-setup-pages.sh"
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Status check complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
