#!/bin/bash
# Complete Cloudflare setup - runs all scripts in correct order

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load common functions
source "$SCRIPT_DIR/cloudflare-common.sh"

# Change to project root
cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Complete Cloudflare Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "This script will guide you through the complete setup process."
echo

# Check dependencies
check_dependencies

# Load and validate environment
load_env
validate_env

echo
log_info "Domain: $CLOUDFLARE_DOMAIN"
log_info "Pages project: ${CLOUDFLARE_PAGES_PROJECT:-zen-warrior}"
echo

# Step 1: Setup Zone
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1/5: Setup Cloudflare Zone"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

read -p "Run cloudflare-setup-zone.sh? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  "$SCRIPT_DIR/cloudflare-setup-zone.sh"
  
  echo
  log_warning "IMPORTANT: Update nameservers at your domain registrar!"
  log_info "This is shown in the output above."
  echo
  read -p "Press Enter after updating nameservers..."
  
  echo
  log_info "Waiting for DNS propagation..."
  log_info "This can take 5 minutes to 48 hours (usually < 1 hour)"
  echo
  read -p "Press Enter when DNS has propagated (or continue anyway)..."
else
  log_info "Skipping zone setup"
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2/5: Setup DNS Records"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

read -p "Run cloudflare-setup-dns.sh? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  "$SCRIPT_DIR/cloudflare-setup-dns.sh"
else
  log_info "Skipping DNS setup"
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3/5: Setup Pages Project"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

read -p "Check Pages project status? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  "$SCRIPT_DIR/cloudflare-setup-pages.sh"
  
  echo
  log_warning "If Pages project doesn't exist, create it manually:"
  log_info "1. Go to Cloudflare dashboard → Pages"
  log_info "2. Create project → Connect to Git → GitHub"
  log_info "3. Select repository: ${GITHUB_REPO:-prmichaelsen/zen-warrior}"
  log_info "4. Configure: Framework=Vite, Build=npm run build, Output=dist"
  echo
  read -p "Press Enter after creating Pages project (or skip if exists)..."
else
  log_info "Skipping Pages check"
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 4/5: Add Custom Domains"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

log_warning "Add custom domains in Cloudflare dashboard:"
log_info "1. Go to Pages project → Custom domains"
log_info "2. Add domain: $CLOUDFLARE_DOMAIN"
log_info "3. Add domain: www.$CLOUDFLARE_DOMAIN"
log_info "4. Wait for SSL certificate (~5 minutes)"
echo
read -p "Press Enter after adding custom domains..."

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 5/5: Check Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

"$SCRIPT_DIR/cloudflare-status.sh"

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
log_success "Your site should be live at:"
echo "  🌐 https://$CLOUDFLARE_DOMAIN"
echo "  🌐 https://www.$CLOUDFLARE_DOMAIN"
echo
log_info "To deploy updates, run:"
echo "  ./scripts/cloudflare-deploy.sh"
