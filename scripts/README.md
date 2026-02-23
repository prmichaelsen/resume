# Cloudflare Deployment Scripts

Automated scripts for deploying Zen Warrior to Cloudflare Pages with custom domain.

## Prerequisites

1. **Cloudflare Account**: Free account at https://dash.cloudflare.com/sign-up
2. **Domain**: Purchase `zenwarrior.app` from any registrar
3. **API Token**: Create at https://dash.cloudflare.com/profile/api-tokens
   - Required permissions: `Zone:Edit`, `DNS:Edit`, `Cloudflare Pages:Edit`
4. **Dependencies**: `curl` and `jq` installed

## Quick Start

### 1. Configure Environment

```bash
# Copy example config
cp .env.cloudflare.local.example .env.cloudflare.local

# Edit with your values
nano .env.cloudflare.local
```

Required values:
- `CLOUDFLARE_API_TOKEN`: Your API token
- `CLOUDFLARE_ACCOUNT_ID`: Found in dashboard URL
- `CLOUDFLARE_DOMAIN`: Your domain (zenwarrior.app)

### 2. Run Setup Scripts

```bash
# 1. Setup Cloudflare zone
./scripts/cloudflare-setup-zone.sh

# 2. Update nameservers at your domain registrar (shown in output)

# 3. Wait for DNS propagation (5 min - 48 hours, usually < 1 hour)

# 4. Setup DNS records
./scripts/cloudflare-setup-dns.sh

# 5. Create Pages project (manual step via dashboard)
./scripts/cloudflare-setup-pages.sh

# 6. Check status
./scripts/cloudflare-status.sh
```

### 3. Deploy

```bash
# Deploy to Cloudflare Pages
./scripts/cloudflare-deploy.sh
```

## Scripts

### `cloudflare-common.sh`
Common functions used by all scripts:
- API request handling
- Environment validation
- Pretty output formatting
- Error handling

### `cloudflare-setup-zone.sh`
Creates Cloudflare zone for your domain:
- Creates zone if it doesn't exist
- Shows nameservers to update at registrar
- Checks zone status

### `cloudflare-setup-dns.sh`
Configures DNS records:
- Creates CNAME for apex domain (zenwarrior.app)
- Creates CNAME for www subdomain
- Optional: Creates CNAME for api subdomain
- All records proxied through Cloudflare CDN

### `cloudflare-setup-pages.sh`
Checks Pages project status:
- Verifies project exists
- Shows project URL
- Provides instructions for manual setup (GitHub OAuth required)

### `cloudflare-deploy.sh`
Deploys to Cloudflare Pages:
- Builds project (`npm run build`)
- Deploys using Wrangler CLI
- Shows deployment URLs

### `cloudflare-status.sh`
Checks deployment status:
- Zone status and nameservers
- DNS records
- Pages project info
- Latest deployment
- Custom domains

## Usage Examples

### Check Status
```bash
./scripts/cloudflare-status.sh
```

### Deploy After Code Changes
```bash
./scripts/cloudflare-deploy.sh
```

### Update DNS Records
```bash
./scripts/cloudflare-setup-dns.sh
```

## Troubleshooting

### "jq: command not found"
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

### "Zone not found"
Run setup script:
```bash
./scripts/cloudflare-setup-zone.sh
```

### "DNS not propagating"
Check propagation:
```bash
dig zenwarrior.app
nslookup zenwarrior.app
```

Wait longer (up to 48 hours) or flush DNS cache:
```bash
# macOS
sudo dscacheutil -flushcache

# Windows
ipconfig /flushdns

# Linux
sudo systemd-resolve --flush-caches
```

### "Wrangler not found"
Install Wrangler CLI:
```bash
npm install -g wrangler
```

## API Token Permissions

Create token at: https://dash.cloudflare.com/profile/api-tokens

Required permissions:
- **Zone - Zone - Edit**: Create and manage zones
- **Zone - DNS - Edit**: Manage DNS records
- **Account - Cloudflare Pages - Edit**: Deploy to Pages

## Security

- `.env.cloudflare.local` is gitignored
- Never commit API tokens to git
- Use read-only tokens when possible
- Rotate tokens regularly

## Cost

- **Cloudflare Pages**: Free (unlimited bandwidth)
- **Cloudflare DNS**: Free
- **SSL Certificate**: Free
- **Domain**: ~$10-15/year

**Total**: $0/month (domain is annual)

## Related Documentation

- [Cloudflare Deployment Design](../agent/design/cloudflare-deployment-design.md)
- [Task 26: Cloudflare Deployment](../agent/tasks/task-26-cloudflare-deployment.md)
- [Cloudflare API Docs](https://developers.cloudflare.com/api/)
- [Cloudflare Pages Docs](https://developers.cloudflare.com/pages/)
