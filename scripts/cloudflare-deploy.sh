#!/bin/bash
# Deploy to Cloudflare Pages using Wrangler CLI

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions
source "$SCRIPT_DIR/cloudflare-common.sh"

# Change to project root
cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Deploy to Cloudflare Pages"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check dependencies
check_dependencies

# Load and validate environment
load_env
validate_env

PAGES_PROJECT=${CLOUDFLARE_PAGES_PROJECT:-zen-warrior}

echo
log_info "Project: $PAGES_PROJECT"
log_info "Deployment method: Direct (no GitHub connection required)"
echo

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
  log_warning "Wrangler CLI not found"
  read -p "Install wrangler globally? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installing wrangler..."
    npm install -g wrangler
    log_success "Wrangler installed"
  else
    log_error "Wrangler is required for deployment"
    echo "Install with: npm install -g wrangler"
    exit 1
  fi
fi

# Build project
log_info "Building project..."
npm run build

if [ ! -d "dist" ]; then
  log_error "Build failed - dist directory not found"
  exit 1
fi

log_success "Build complete"
echo

# Deploy to Pages using environment variables
log_info "Deploying to Cloudflare Pages..."
echo

# Export environment variables for wrangler
export CLOUDFLARE_API_TOKEN
export CLOUDFLARE_ACCOUNT_ID

# Deploy with wrangler
if [ -n "$CLOUDFLARE_EMAIL" ]; then
  # Using Global API Key
  log_info "Using Global API Key authentication"
  CLOUDFLARE_API_KEY="$CLOUDFLARE_API_TOKEN" \
  CLOUDFLARE_EMAIL="$CLOUDFLARE_EMAIL" \
  wrangler pages deploy dist \
    --project-name="$PAGES_PROJECT" \
    --branch="main"
else
  # Using API Token
  log_info "Using API Token authentication"
  wrangler pages deploy dist \
    --project-name="$PAGES_PROJECT" \
    --branch="main"
fi

log_success "Deployment complete"
echo

# Get deployment URL
DEPLOYMENT_INFO=$(cf_api GET "/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects/$PAGES_PROJECT")

if check_response "$DEPLOYMENT_INFO"; then
  PROJECT_URL=$(echo "$DEPLOYMENT_INFO" | jq -r '.result.subdomain')
  LATEST_URL=$(echo "$DEPLOYMENT_INFO" | jq -r '.result.canonical_deployment.url // "N/A"')
  
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✓ Deployment successful"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo
  echo "🌐 URLs:"
  echo "  Project: https://$PROJECT_URL"
  echo "  Latest: $LATEST_URL"
  
  if [ -n "$CLOUDFLARE_DOMAIN" ]; then
    echo "  Custom: https://$CLOUDFLARE_DOMAIN"
  fi
fi
