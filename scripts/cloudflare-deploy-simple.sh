#!/bin/bash
# Simple one-liner deploy using environment variables

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

# Load environment
set -a
source .env.cloudflare.local
set +a

# Build
echo "Building..."
npm run build

# Deploy with Global API Key + Email
echo "Deploying..."
if [ -n "$CLOUDFLARE_EMAIL" ]; then
  # Using Global API Key (X-Auth-Email + X-Auth-Key)
  echo "Using Global API Key authentication"
  CLOUDFLARE_API_KEY="$CLOUDFLARE_API_TOKEN" \
  CLOUDFLARE_EMAIL="$CLOUDFLARE_EMAIL" \
  CLOUDFLARE_ACCOUNT_ID="$CLOUDFLARE_ACCOUNT_ID" \
  wrangler pages deploy dist \
    --project-name="${CLOUDFLARE_PAGES_PROJECT:-zen-warrior}" \
    --branch="main"
else
  # Using API Token (Bearer)
  echo "Using API Token authentication"
  CLOUDFLARE_API_TOKEN="$CLOUDFLARE_API_TOKEN" \
  CLOUDFLARE_ACCOUNT_ID="$CLOUDFLARE_ACCOUNT_ID" \
  wrangler pages deploy dist \
    --project-name="${CLOUDFLARE_PAGES_PROJECT:-zen-warrior}" \
    --branch="main"
fi

echo "✓ Deployed!"
