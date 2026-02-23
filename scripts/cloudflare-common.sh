#!/bin/bash
# Common functions for Cloudflare API scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load environment variables
load_env() {
  if [ -f .env.cloudflare.local ]; then
    source .env.cloudflare.local
    echo -e "${GREEN}✓${NC} Loaded .env.cloudflare.local"
  else
    echo -e "${RED}✗${NC} .env.cloudflare.local not found"
    echo -e "${YELLOW}→${NC} Copy .env.cloudflare.local.example to .env.cloudflare.local and fill in your values"
    exit 1
  fi
}

# Validate required environment variables
validate_env() {
  local required_vars=("CLOUDFLARE_API_TOKEN" "CLOUDFLARE_ACCOUNT_ID" "CLOUDFLARE_DOMAIN")
  local missing_vars=()
  
  for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
      missing_vars+=("$var")
    fi
  done
  
  if [ ${#missing_vars[@]} -gt 0 ]; then
    echo -e "${RED}✗${NC} Missing required environment variables:"
    for var in "${missing_vars[@]}"; do
      echo -e "  - $var"
    done
    exit 1
  fi
  
  echo -e "${GREEN}✓${NC} All required environment variables set"
}

# Make API request to Cloudflare
cf_api() {
  local method=$1
  local endpoint=$2
  local data=$3
  
  local url="https://api.cloudflare.com/client/v4${endpoint}"
  
  # Check if using API Token (Bearer) or Global API Key (X-Auth-Email + X-Auth-Key)
  if [ -n "$CLOUDFLARE_EMAIL" ]; then
    # Using Global API Key
    if [ -z "$data" ]; then
      curl -s -X "$method" "$url" \
        -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
        -H "X-Auth-Key: $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json"
    else
      curl -s -X "$method" "$url" \
        -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
        -H "X-Auth-Key: $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$data"
    fi
  else
    # Using API Token (Bearer)
    if [ -z "$data" ]; then
      curl -s -X "$method" "$url" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json"
    else
      curl -s -X "$method" "$url" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$data"
    fi
  fi
}

# Check if API response was successful
check_response() {
  local response=$1
  local success=$(echo "$response" | jq -r '.success')
  
  if [ "$success" != "true" ]; then
    echo -e "${RED}✗${NC} API request failed:"
    echo "$response" | jq -r '.errors[]?.message' 2>/dev/null || echo "$response"
    return 1
  fi
  
  return 0
}

# Get zone ID for domain
get_zone_id() {
  local domain=$1
  local response=$(cf_api GET "/zones?name=$domain")
  
  if ! check_response "$response"; then
    return 1
  fi
  
  local zone_id=$(echo "$response" | jq -r '.result[0].id')
  
  if [ "$zone_id" = "null" ] || [ -z "$zone_id" ]; then
    echo -e "${RED}✗${NC} Zone not found for domain: $domain"
    return 1
  fi
  
  echo "$zone_id"
}

# Pretty print JSON
pretty_json() {
  echo "$1" | jq '.'
}

# Log info message
log_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

# Log success message
log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

# Log error message
log_error() {
  echo -e "${RED}✗${NC} $1"
}

# Log warning message
log_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

# Check if jq is installed
check_jq() {
  if ! command -v jq &> /dev/null; then
    log_error "jq is not installed"
    echo "Install with: sudo apt-get install jq (Ubuntu/Debian) or brew install jq (macOS)"
    exit 1
  fi
}

# Check if curl is installed
check_curl() {
  if ! command -v curl &> /dev/null; then
    log_error "curl is not installed"
    echo "Install with: sudo apt-get install curl (Ubuntu/Debian) or brew install curl (macOS)"
    exit 1
  fi
}

# Check all dependencies
check_dependencies() {
  check_curl
  check_jq
  log_success "All dependencies installed"
}
