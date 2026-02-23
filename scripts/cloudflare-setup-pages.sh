#!/bin/bash
# Setup Cloudflare Pages project via API

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions
source "$SCRIPT_DIR/cloudflare-common.sh"

# Change to project root
cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📄 Cloudflare Pages Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check dependencies
check_dependencies

# Load and validate environment
load_env
validate_env

PAGES_PROJECT=${CLOUDFLARE_PAGES_PROJECT:-zen-warrior}
GITHUB_REPO=${GITHUB_REPO:-prmichaelsen/zen-warrior}
PRODUCTION_BRANCH=${PRODUCTION_BRANCH:-main}

echo
log_info "Pages project: $PAGES_PROJECT"
log_info "GitHub repo: $GITHUB_REPO"
log_info "Production branch: $PRODUCTION_BRANCH"
echo

# Check if project exists
log_info "Checking if Pages project exists..."
EXISTING_PROJECT=$(cf_api GET "/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects/$PAGES_PROJECT")

if check_response "$EXISTING_PROJECT" 2>/dev/null; then
  log_success "Pages project already exists"
  
  PROJECT_URL=$(echo "$EXISTING_PROJECT" | jq -r '.result.subdomain')
  DEPLOYMENT_URL=$(echo "$EXISTING_PROJECT" | jq -r '.result.canonical_deployment.url // "N/A"')
  
  echo "  Project URL: https://$PROJECT_URL"
  echo "  Latest deployment: $DEPLOYMENT_URL"
  
  echo
  log_warning "To update project settings, use the Cloudflare dashboard:"
  echo "  https://dash.cloudflare.com/$CLOUDFLARE_ACCOUNT_ID/pages/view/$PAGES_PROJECT"
  
  echo
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✓ Pages project exists"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 0
fi

# Note: Pages project creation via API requires GitHub OAuth token
# This is complex to automate, so we'll provide instructions instead

echo
log_warning "Pages project does not exist"
echo
log_info "To create a Pages project, use the Cloudflare dashboard:"
echo
echo "1. Go to: https://dash.cloudflare.com/$CLOUDFLARE_ACCOUNT_ID/pages"
echo "2. Click 'Create a project'"
echo "3. Connect to Git → Select GitHub"
echo "4. Authorize Cloudflare"
echo "5. Select repository: $GITHUB_REPO"
echo "6. Configure build settings:"
echo "   - Project name: $PAGES_PROJECT"
echo "   - Production branch: $PRODUCTION_BRANCH"
echo "   - Framework preset: Vite"
echo "   - Build command: npm run build"
echo "   - Build output directory: dist"
echo "7. Click 'Save and Deploy'"
echo
log_info "After creating the project, run this script again to verify"

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "ℹ Manual setup required"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
